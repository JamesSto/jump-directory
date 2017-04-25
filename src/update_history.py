#!/usr/bin/env python

import os
from collections import Counter
import json

file_dir = os.path.dirname(__file__)
HISTORY_FILE = file_dir + "/../data/dir_history.json"
BASH_HISTORY = os.path.expanduser("~/.bash_history")
CD_HISTORY = file_dir + "/../data/cd_history.txt"


def strip_slash(s):
    # Strip trailing slash if it exists
    if s.endswith("/"):
        return s[:-1]
    return s

def update_history():
    if not os.path.isfile(HISTORY_FILE):
        if os.path.isfile(BASH_HISTORY):
            with open(BASH_HISTORY, 'r') as h:
                # Parse the bash history for absolute filepaths that can be used
                # to initialize the history
                commands = h.readlines()
                paths = [strip_slash(c.split()[1]) for c in commands if c.startswith("cd") and 
                                                                        len(c.split()) == 2 and 
                                                                        os.path.isabs(c.split()[1])]
                paths = [p for p in paths if os.path.isdir(p)]

            with open(HISTORY_FILE, 'w') as h:
                hist_json = Counter()
                hist_json.update(paths)
                h.write(json.dumps(hist_json))

    # Update on known history
    with open(CD_HISTORY, 'r+') as h:
        cd_hist = [strip_slash(x.strip()) for x in h.readlines() if len(x.strip()) > 0]
        assert all(os.path.isabs(p) and os.path.isdir(p) for p in cd_hist)
    # Clear the history file
    open(CD_HISTORY, 'w').close()
    with open(HISTORY_FILE, 'r') as h:
        history = Counter(json.loads(h.read()))
        history.update(cd_hist)
        history = {k:v for k,v in history.iteritems() if os.path.isdir(k)}
    # Overwrite existing history
    with open(HISTORY_FILE, 'w') as h:
        h.write(json.dumps(history))

    return history