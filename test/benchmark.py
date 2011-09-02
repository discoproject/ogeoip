#!/usr/bin/python

import os, datetime, sys, time
import GeoIP

test_ips = ["24.24.24.24", "80.24.24.80", "200.24.24.40", "68.24.24.46"]

def print_usage():
    print "Usage: %s [num_iterations]"
    exit(0)

def bench(db, iters):
    gi = GeoIP.open(db, GeoIP.GEOIP_MEMORY_CACHE)
    N = len(test_ips)
    start = time.clock()
    for i in xrange(0, iters):
        gir = gi.record_by_addr(test_ips[i % N])
    duration = time.clock() - start
    print "%s: %d lookups in %f seconds (%d/sec)" % (os.path.basename(db), iters, duration, iters/duration)

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.realpath( __file__ ))
    dat_dir = os.path.join(script_dir, "../dat")
    try:
        iters = int(sys.argv[1]) if len(sys.argv) > 1 else 30000
    except:
        print_usage()
    for ed in ["GeoIPCity.dat", "GeoLiteCity.dat"]:
        db = os.path.join(dat_dir, ed)
        if os.path.isfile(db):
            bench(db, iters)


