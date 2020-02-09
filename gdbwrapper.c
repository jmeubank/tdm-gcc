/* - gdbwrapper.c -
 * Author: John E. / TDM, 2014-12-20
 *
 * A simple "wrapper" program to run the actual GDB executable, existing in a
 * different but known directory, with any arguments passed to this program.
 *
 * In a Windows (SysWOW64) environment, it can be desirable to build and debug
 * both 32-bit and 64-bit software on the same 64-bit system. This requires two
 * different instances of GDB, one 32-bit (for debugging 32-bit programs), and
 * one 64-bit (for debugging 64-bit programs). Having both GDB instances coexist
 * in the same "bin" directory is problematic for several reasons. This wrapper
 * program is used to create "gdb32" and "gdb64" executables which can coexist
 * in the bin directory; when run, they will simply re-execute the actual
 * corresponding GDB program in a different subdirectory, and pass along any
 * arguments, environment variables, and the input/output streams.
 *
 * COPYING:
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

#define _WIN32_WINNT 0x500

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>

#include <stdio.h>
#include <process.h>
#include <malloc.h>
#include <wchar.h>


#ifndef REAL_GDB_PATH
#error REAL_GDB_PATH must be defined!
#endif


int main()
{
	fwide(stdin, 1);
	fwide(stdout, 1);
	fwide(stderr, 1);

	wchar_t* modname;
	DWORD alloc_size = MAX_PATH + 1;
	DWORD modname_len;
	while (1)
	{
		modname = malloc(sizeof(wchar_t) * alloc_size);
		if (!modname)
		{
			fwprintf(stderr, L"gdbwrapper: Failed to allocate wchar_t string of length %lu", alloc_size);
			exit(1);
		}
		modname_len = GetModuleFileNameW(0, modname, alloc_size - 1);
		if (modname_len < (alloc_size - 1))
			break;
		free(modname);
		alloc_size *= 2;
	}

	DWORD at;
	for (at = modname_len - 1; at > 0; --at)
	{
		if (modname[at] == L'\\' || modname[at] == L'/')
			break;
	}
	if (at <= 0)
	{
		fwprintf(stderr, L"gdbwrapper: Invalid module path\n");
		exit(1);
	}
	modname[at + 1] = 0;

	wchar_t* newmodname = malloc(sizeof(wchar_t) * (at + wcslen(REAL_GDB_PATH) + 2));
	wcscpy(newmodname, modname);
	wcscpy(newmodname + at + 1, REAL_GDB_PATH);
	free(modname);

	HANDLE jobhandle = CreateJobObjectW(0, 0);
	if (!jobhandle)
	{
		fwprintf(stderr, L"gdbwrapper: Couldn't create job object\n");
		exit(1);
	}
	JOBOBJECT_EXTENDED_LIMIT_INFORMATION joeli;
	memset(&joeli, 0, sizeof(JOBOBJECT_EXTENDED_LIMIT_INFORMATION));
	joeli.BasicLimitInformation.LimitFlags = 0x2000;
	if (!SetInformationJobObject(jobhandle, JobObjectExtendedLimitInformation,
	 &joeli, sizeof(JOBOBJECT_EXTENDED_LIMIT_INFORMATION)))
	{
		fwprintf(stderr, L"gdbwrapper: Couldn't set job object limit\n");
	}

	STARTUPINFOW si = {0};
	si.cb = sizeof(si);
	si.dwFlags = STARTF_USESTDHANDLES;
	si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
	si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
	PROCESS_INFORMATION pi = {0};
	if (!CreateProcessW(newmodname, GetCommandLineW(), 0, 0, TRUE, 0, 0, 0, &si,
	 &pi))
	{
		fwprintf(stderr, L"gdbwrapper: CreateProcess failed (%s)\n",
		 newmodname);
		exit(1);
	}
	if (!AssignProcessToJobObject(jobhandle, pi.hProcess))
	{
		fwprintf(stderr, L"gdbwrapper: AssignProcessToJobObject failed\n");
		exit(1);
	}
	SetConsoleCtrlHandler(NULL, TRUE);

	WaitForSingleObject(pi.hProcess, INFINITE);
	DWORD result = 1;
	GetExitCodeProcess(pi.hProcess, &result);
	CloseHandle(jobhandle);
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	free(newmodname);
	return result;
}
