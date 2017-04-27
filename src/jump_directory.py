#!/usr/bin/env python

from argparse import ArgumentParser
from update_history import update_history, prioritize, forget
from utils import strip_slash
import os

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("dir", nargs='?', default=None, help="directory to jump to")
    parser.add_argument("-l", "--list", action="store_true", default=False, help="list directories and times visited then exit")
    parser.add_argument("--prioritize", action="store_true", default=False, help="make directory artificially most visited with same name")
    parser.add_argument("--forget", action="store_true", default=False, help="remove directory from jd's memory")

    args = parser.parse_args()
    
    history = update_history()

    if args.list:
        spaces = max(len(str(x[1])) for x in history.iteritems()) + 1
        for d,n in sorted(history.items(), key=lambda x : x[1], reverse=True):
            print str(n) + " "*max(spaces - len(str(n)), 0) + ": " + d

    elif args.prioritize:
        if not args.dir:
            print "Error: require directory to prioritize"
        else:
            abspath = os.path.abspath(args.dir)
            if not os.path.isdir(abspath):
                print "Error: no such directory " + abspath
            else:
                prioritize(abspath)

    elif args.forget:
        if not args.dir:
            print "Error: require directory to forget"
        else:
            abspath = os.path.abspath(args.dir)
            if not os.path.isdir(abspath):
                print "Error: no such directory " + abspath
            else:
                forget(abspath)

    elif args.dir:
        args.dir = strip_slash(args.dir)

        best = "", -1
        for key in history:
            if key.endswith(args.dir):
                # Only look for complete directories
                if key == args.dir or key[-(len(args.dir)+1)] == "/":
                    best = max((key, history[key]), best, key=lambda x : x[1])

        # We print the output so that the bashrc file can pick up on that and actually cd to it
        # It begins with [RET_DIR] so it's clear that it's a directory
        # This means that no other output of this program can begin with [RET_DIR]
        print "[RET_DIR]" + best[0]
    else:
        print "Error: No arguments provided"