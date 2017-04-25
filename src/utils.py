import os

file_dir = os.path.dirname(__file__)

HISTORY_FILE = file_dir + "/../data/dir_history.json"
BASH_HISTORY = os.path.expanduser("~/.bash_history")
CD_HISTORY = file_dir + "/../data/cd_history.txt"


def strip_slash(s):
    # Strip trailing slash if it exists
    if s.endswith("/"):
        return s[:-1]
    return s