
ifeq ($(MFTUPDATE_DIR),)
$(error Must specify MFTUPDATE_DIR)
else
export MFTUPDATE_DIR
endif
ifeq ($(PKGLIST),)
$(error Must specify PKGLIST)
else
export PKGLIST
endif
ifeq ($(PKG_SRC_DIR),)
$(error Must specify PKG_SRC_DIR)
else
export PKG_SRC_DIR
endif
ifeq ($(MFTUPDATE_TEMPLATE),)
$(error Must specify MFTUPDATE_TEMPLATE)
else
export MFTUPDATE_TEMPLATE
endif
ifeq ($(MFTUPDATE_EXE),)
$(error Must specify MFTUPDATE_EXE)
else
export MFTUPDATE_EXE
endif
ifeq ($(NEW_NET_MFT),)
$(error Must specify NEW_NET_MFT)
else
export NEW_NET_MFT
endif
ifeq ($(VER_RGX),)
$(error Must specify VER_RGX)
else
export VER_RGX
endif
ifeq ($(STAGE_DIR),)
$(error Must specify STAGE_DIR)
else
export STAGE_DIR
endif

.PHONY: default
default:
	mkdir -p -- $(MFTUPDATE_DIR)
	echo "$$MFTUPDATE_TEMPLATE" >$(MFTUPDATE_DIR)/MFTUPDATE.txt
	VER_STRING=`echo "$$PKGLIST" | gawk 'match($$0, /$(VER_RGX)/, m) { print m[1] }'` \
		&& sed -i -e "s/\:\:VER\:\:/$$VER_STRING/g" $(MFTUPDATE_DIR)/MFTUPDATE.txt
	rm -fR $(MFTUPDATE_DIR)/untarred-forsize
	mkdir -p -- $(MFTUPDATE_DIR)/untarred-forsize
	cd $(MFTUPDATE_DIR)/untarred-forsize \
		&& echo "$$PKGLIST" | sed 's!.*/!$(PKG_SRC_DIR)/!' | sed 's!\?.*!!' | xargs -i tar -axf {}
ifneq ($(ADDIN_URLS),)
	cd $(MFTUPDATE_DIR)/untarred-forsize \
		&& echo "$$PKGLIST" | sed 's!.*/!$(ADDIN_STAGE_DIR)/!' | sed 's!\?.*!!' | xargs -i tar -axf {}
endif
	UNSIZE1=`du -bs $(MFTUPDATE_DIR)/untarred-forsize | cut -f1` \
		&& sed -i -e "s/\:\:UNSIZE\:\:/$$UNSIZE1/g" $(MFTUPDATE_DIR)/MFTUPDATE.txt
# Get the individual paths and sizes of the archives
	rm -f $(MFTUPDATE_DIR)/arcs.txt
	( \
		for arc in `echo $$PKGLIST`; do \
			export ARCFILE=`basename $$arc | sed 's!\?.*!!'` ; \
			export ARCSIZE=`du -bs $(PKG_SRC_DIR)/$$ARCFILE | cut -f1` ; \
			echo "<Archive path=\"$$arc\" arcsize=\"$$ARCSIZE\" />" >>$(MFTUPDATE_DIR)/arcs.txt ; \
		done \
	)
ifneq ($(ADDIN_URLS),)
	( \
		for arc in "$(ADDIN_URLS)"; do \
			export ARCFILE=`basename $$arc | sed 's!\?.*!!'` ; \
			export ARCSIZE=`du -bs $(ADDIN_STAGE_DIR)/$$ARCFILE | cut -f1` ; \
			echo "<Archive path=\"$$arc\" arcsize=\"$$ARCSIZE\" />" >>$(MFTUPDATE_DIR)/arcs.txt ; \
		done \
	)
endif
	ARCSLIST=`cat $(MFTUPDATE_DIR)/arcs.txt` \
		&& cat $(MFTUPDATE_DIR)/MFTUPDATE.txt | awk -v r="$$ARCSLIST" '{gsub(/::ARCSLIST::/,r)}1' \
		1>$(MFTUPDATE_DIR)/MFTUPDATE.txt.new.txt
	mv $(MFTUPDATE_DIR)/MFTUPDATE.txt.new.txt $(MFTUPDATE_DIR)/MFTUPDATE.txt
# run the manifest update
	$(MFTUPDATE_EXE) <$(MFTUPDATE_DIR)/MFTUPDATE.txt 1>$(NEW_NET_MFT).new
	mv $(NEW_NET_MFT).new $(NEW_NET_MFT)
# copy the archives to the staging dir
	echo "$$PKGLIST" | sed 's!.*/!$(PKG_SRC_DIR)/!' | sed 's!\?.*!!' | xargs -i cp -p {} $(STAGE_DIR)/
