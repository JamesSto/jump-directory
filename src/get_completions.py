#!/usr/bin/env python2

from update_history import update_history
import sys
from utils import FLAGS
    
if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith("/"):
        sys.stderr.write(str(sys.argv))
        sys.exit()
    history = update_history().items()
    search_phrase = sys.argv[1]
    # We need to check from the start of the first directory listed by the user, so count the number of dirs
    num_dirs = search_phrase.count("/") + 1
    # Now split off every known path at that many directories (but keep the key/value pairs together)
    to_match = {"/".join(x.split("/")[-1*num_dirs:]):v for x,v in history if len(x.split("/")) > num_dirs}
    # Now we can finally check if the directories we found start with the input argument directories
    matching_history = [x for x in to_match.iteritems() if x[0].startswith(search_phrase)]

    # Sort by length and then remove counts
    names = [x[0] for x in sorted(matching_history, key=lambda x : x[1])]

    # Strip out duplicates
    seen = set()
    out_str = ""
    for n in names:
        if n not in seen:
            if " " in n:
                out_str += "\"" + n + "/\" "
            else:
                out_str += n + "/ "
            seen.add(n)

    out_str += " " + " ".join(f for f in FLAGS if f.startswith(search_phrase))

    print out_str