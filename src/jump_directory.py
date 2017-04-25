#!/usr/bin/env python

from argparse import ArgumentParser
from update_history import update_history
from utils import strip_slash

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("dir", help="The directory to jump to")

    args = parser.parse_args()
    args.dir = strip_slash(args.dir)
    
    history = update_history()

    best = "", -1
    for key in history:
        if key.endswith(args.dir):
            # Only look for complete directories
            if key == args.dir or key[-(len(args.dir)+1)] == "/":
                best = max((key, history[key]), best, key=lambda x : x[1])

    # We print the output so that the bashrc file can pick up on that and actually cd to it
    # I couldn't find any way to move directories more cleanly from within a Python script
    print best[0]