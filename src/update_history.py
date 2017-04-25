#!/usr/bin/env python

import os
from collections import Counter
import json
from utils import HISTORY_FILE, BASH_HISTORY, CD_HISTORY, strip_slash

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
        else:
            open(HISTORY_FILE, 'w').close()

    # Update on known history
    with open(CD_HISTORY, 'r') as h:
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