#!/usr/bin/env python

from update_history import *
import sys
import os

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith("/"):
        sys.exit()
    history = update_history().items()
    search_phrase = sys.argv[1]
    num_dirs = search_phrase.count("/") + 1
    to_match = {"/".join(x.split("/")[-1*num_dirs:]):v for x,v in history if len(x.split("/")) > num_dirs}
    matching_history = [x for x in to_match.iteritems() if x[0].startswith(sys.argv[1])]
    names = [x[0] for x in sorted(matching_history, key=lambda x : x[1])]
    seen = set()
    for n in names:
        if n not in seen:
            print n + "/",
            seen.add(n)