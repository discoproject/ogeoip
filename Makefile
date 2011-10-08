LIB = geoip

PYTHON = python
OCAMLBUILD = ocamlbuild

.PHONY: all test clean

# Hack to work around ocamlbuild 3.12.1 bug.
CLEANUP_FILES = geoip.cma geoip.cmxa geoip_test.byte geoip_test.native benchmark.byte benchmark.native

OBJ_DIR = _build/lib
LIB_INSTALLS = \
	$(OBJ_DIR)/geoip.mli $(OBJ_DIR)/geoip.cmi \
	$(OBJ_DIR)/geoip.cma $(OBJ_DIR)/geoip.cmxa $(OBJ_DIR)/geoip.a

all: lib/geoip_regions.ml lib/geoip_timezones.ml Makefile
	-rm -f $(CLEANUP_FILES)
	$(OCAMLBUILD) lib/all.otarget

lib/geoip_regions.ml: tools/gen_region_names.py dat/fips10_4.txt dat/iso3166_2.txt
	$(PYTHON) $< > $@

lib/geoip_timezones.ml: tools/gen_timezones.py dat/timezone.txt
	$(PYTHON) $< > $@

test: all
	-rm -f $(CLEANUP_FILES)
	$(OCAMLBUILD) test/all.otarget

clean:
	$(OCAMLBUILD) -clean -quiet

realclean: clean
	rm -f lib/geoip_regions.ml lib/geoip_timezones.ml

install:
	ocamlfind install $(LIB) META $(LIB_INSTALLS)

uninstall:
	ocamlfind remove $(LIB)

reinstall: uninstall install
