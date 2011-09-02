#!/usr/bin/python

import sys, re, os

def parse(fl):
    timezones = {}
    fl.readline()
    for n, l in enumerate(fl.readlines()):
        fs = l.rstrip().split('\t', 3)
        if len(fs) != 3:
            print "Invalid timezone line %d: %s" % (n+2, l)
            exit(1)
        timezones["%s/%s" % (fs[0], fs[1])] = fs[2]
    return timezones

def gen_ocaml(timezones):
    print """let table ="""
    for n, (key, tz) in enumerate(timezones.iteritems()):
        print """  %s ("%s", "%s")""" % (("[" if n == 0 else ";"), key, tz)
    print """  ]"""

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.realpath( __file__ ))
    dat_dir = os.path.join(script_dir, "../dat")
    files = map(lambda f: os.path.join(dat_dir, f), ["timezone.txt"])
    timezones = parse(file(files[0]))
    gen_ocaml(timezones)
