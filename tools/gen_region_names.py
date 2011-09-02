#!/usr/bin/python

import sys, re, os

def parse_iso3166_2(fl):
    countries = {}
    rc_re = re.compile("^[A-Z]{2}$")
    fl.readline()
    for n, l in enumerate(fl.readlines()):
        fs = l.rstrip().split(',', 2)
        if len(fs) != 3:
            if len(fs) == 0:
                continue
            else:
                print "Invalid iso3166 line %d: %s" % (n+2, l)
                exit(1)
        cc, rc, rn = fs[0], fs[1], fs[2]
        if rc_re.match(rc) == None:
            print "Wrong iso region code on line %d: %s" % (n+2, rc)
            exit(1)
        if len(rn) == 0 or rn[0] != '"' or rn[len(rn)-1] != '"':
            print "Wrong iso region name on line %d: %s" % (n+2, rn)
            exit(1)
        cregs = countries.setdefault(cc, {})
        cregs[rc] = rn[1:-1]
    return countries

def parse_fips10_4(fl):
    countries = {}
    rc_re = re.compile("^[A-Z0-9]{2}$")
    fl.readline()
    for n, l in enumerate(fl.readlines()):
        fs = l.rstrip().split(',', 2)
        if len(fs) != 3:
            if len(fs) == 0:
                continue
            else:
                print "Invalid fips10_4 line %d: %s" % (n+2, l)
                exit(1)
        cc, rc, rn = fs[0], fs[1], fs[2]
        if rc_re.match(rc) == None:
            print "Wrong fips region code on line %d: %s (%s)" % (n+2, rc, l)
            exit(1)
        if len(rn) == 0 or rn[0] != '"' or rn[len(rn)-1] != '"':
            print "Wrong fips region name on line %d: %s" % (n+2, rn)
            exit(1)
        cregs = countries.setdefault(cc, {})
        cregs[rc] = rn[1:-1]
    return countries

def parse(fn):
    parser = parse_fips10_4 if os.path.basename(fn).startswith('fips') else parse_iso3166_2
    return parser(file(fn))

def gen_ocaml(countries):
    print """let table ="""
    for nc, cc in enumerate(countries.iterkeys()):
        for nr, (rc, rn) in enumerate(countries[cc].iteritems()):
            print """  %s ("%s/%s", "%s")""" % (("[" if nc == 0 and nr == 0 else ";"), cc, rc, rn)
    print """  ]"""

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.realpath( __file__ ))
    dat_dir = os.path.join(script_dir, "../dat")
    files = map(lambda f: os.path.join(dat_dir, f),
                ["fips10_4.txt", "iso3166_2.txt"])
    countries = parse(files[0])
    countries.update(parse(files[1]))
    gen_ocaml(countries)
