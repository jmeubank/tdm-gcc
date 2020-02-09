
.PHONY: default
default:
ifeq ($(BIARCH),1)
	[ ! -d $(SRC)/32/include ] || ( \
		mkdir -p $(DEST)/include \
		&& cp -Rp $(SRC)/32/include/* $(DEST)/include/ \
	)
	[ ! -d $(SRC)/64/bin ] || ( \
		mkdir -p $(DEST)/bin \
		&& cp -Rp $(SRC)/64/bin/* $(DEST)/bin/ \
	)
	[ ! -d $(SRC)/32/bin ] || ( \
		mkdir -p $(DEST)/bin32 \
		&& cp -Rp $(SRC)/32/bin/* $(DEST)/bin32/ \
	)
	mkdir -p $(DEST)/lib
	-cp -p $(SRC)/64/lib/*.a $(DEST)/lib/
	-cp -p $(SRC)/64/lib/*.o $(DEST)/lib/
	mkdir -p $(DEST)/lib32
	-cp -p $(SRC)/32/lib/*.a $(DEST)/lib32/
	-cp -p $(SRC)/32/lib/*.o $(DEST)/lib32/
else
	[ ! -d $(SRC)/include ] || ( \
		mkdir -p $(DEST)/include \
		&& cp -Rp $(SRC)/include/* $(DEST)/include/ \
	)
	[ ! -d $(SRC)/bin ] || ( \
		mkdir -p $(DEST)/bin \
		&& cp -Rp $(SRC)/bin/* $(DEST)/bin/ \
	)
	mkdir -p $(DEST)/lib
	-cp -p $(SRC)/lib/*.a $(DEST)/lib/
	-cp -p $(SRC)/lib/*.o $(DEST)/lib/
endif
