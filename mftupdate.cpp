/* - mftupdate.cpp -
 * Author: John E. / TDM, 2014-12-24
 *
 * Update the TDMInstall XML manifest with current version and archive info for
 * a TDM-GCC package that has just been built.
 *
 * This program reads all input data on stdin rather than using command-line
 * arguments.
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

#include <iostream>
#include <regex>
#include <string>

#include "tinyxml2.h"


using std::cin;
using std::getline;
using std::string;
using tinyxml2::XMLDocument;
using tinyxml2::XMLElement;
using tinyxml2::XMLHandle;
using tinyxml2::XMLNode;
using tinyxml2::XMLText;


XMLNode* deepCopy(XMLNode* src, XMLDocument& destDoc)
{
	XMLNode *current = src->ShallowClone(&destDoc);
	for (XMLNode* child = src->FirstChild(); child; child = child->NextSibling())
		current->InsertEndChild(deepCopy(child, destDoc));
    return current;
}


XMLElement* ChildElementMatchingRegex(
 XMLElement* parent,
 const string& regex_str,
 const string& element_type,
 const char* attribute_type
)
{
	if (!parent || regex_str.length() <= 0)
		return nullptr;
	std::regex rgx(regex_str);
	XMLElement* child;
	for (
	 child = parent->FirstChildElement(element_type.c_str());
	 child;
	 child = child->NextSiblingElement(element_type.c_str())
	)
	{
		const char* attribute_value = nullptr;
		if (attribute_type)
			attribute_value = child->Attribute(attribute_type);
		else
		{
			XMLText* childtxt = XMLHandle(child->FirstChild()).ToText();
			if (childtxt)
				attribute_value = childtxt->Value();
		}
		if (std::regex_match(attribute_value, rgx))
			break;
	}
	return child;
}


int main()
{
	string mft_path;
	XMLDocument doc;
	{
		getline(cin, mft_path);
		FILE* fp = fopen(mft_path.c_str(), "rb");
		if (!fp)
		{
			fprintf(stderr, "Unable to open '%s' for reading\n", mft_path.c_str());
			exit(1);
		}
		if (doc.LoadFile(fp) != tinyxml2::XML_NO_ERROR)
		{
			fprintf(stderr, "Unable to load '%s' as XML\n", mft_path.c_str());
			exit(1);
		}
		fclose(fp);
	}

	while (!cin.eof())
	{
		XMLElement* at_element = doc.RootElement();

		while (!cin.eof())
		{
			string linestr;
			getline(cin, linestr);
			if (linestr == "]]>]]>")
				break;
			size_t elementtype_foundpos = linestr.find(":");
			if (elementtype_foundpos == string::npos)
				continue;
			string elementtypestr = linestr.substr(0, elementtype_foundpos);
			size_t attributetype_foundpos = linestr.find("|");
			if (attributetype_foundpos == string::npos
			 || attributetype_foundpos <= elementtype_foundpos)
				continue;
			string attributetypestr = linestr.substr(elementtype_foundpos + 1,
			 attributetype_foundpos - elementtype_foundpos - 1);
			string attributevaluergx = linestr.substr(attributetype_foundpos + 1);
			XMLElement* found_element = ChildElementMatchingRegex(at_element,
			 attributevaluergx, elementtypestr, attributetypestr.c_str());
			if (!found_element)
			{
				fprintf(stderr, "Couldn't find %s element with %s matching '%s'\n",
				 elementtypestr.c_str(), attributetypestr.c_str(),
				 attributevaluergx.c_str());
				exit(1);
			}
			at_element = found_element;
		}

		string replace_contents;
		while (!cin.eof())
		{
			string addline;
			getline(cin, addline);
			if (addline == "]]>]]>")
				break;
			replace_contents += addline;
			replace_contents += '\n';
		}
		XMLDocument replace_doc;
		if (replace_doc.Parse(replace_contents.c_str()) != tinyxml2::XML_NO_ERROR)
		{
			fprintf(stderr, "Couldn't parse replacement contents as XML\n");
			exit(1);
		}

		XMLNode* previous_sibling = at_element->PreviousSibling();
		XMLElement* parent = XMLHandle(at_element->Parent()).ToElement();
		if (!parent)
		{
			fprintf(stderr, "Can't replace root element\n");
			exit(1);
		}
		parent->DeleteChild(at_element);

		XMLNode* copied_contents = deepCopy(replace_doc.RootElement(), doc);

		if (previous_sibling)
			parent->InsertAfterChild(previous_sibling, copied_contents);
		else
			parent->InsertFirstChild(copied_contents);
	}

	doc.Print();

	return 0;
}
