PYTHON = python
OCAMLBUILD = ocamlbuild

.PHONY: all test clean

# Hack to work around ocamlbuild 3.12.1 sanitation check bug.
CLEANUP_FILES = geoip.cma geoip.cmxa geoip_test.byte geoip_test.native benchmark.byte benchmark.native

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
