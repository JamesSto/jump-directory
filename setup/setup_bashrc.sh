#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No login file specified; defaulting to ~/.bashrc"
    LOGIN_FILE="$HOME/.bashrc"
else
    LOGIN_FILE=$1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


WRITE_STR="# Commands added by jump-directory on `date`
function cd() {
    if [ -n \"\$1\" ]; then 
        echo \`readlink -fe \$1\` >> $DIR/../data/cd_history.txt 
    fi
    builtin cd \$1
}
function jd() {
    cd \$(python $DIR/../src/jump_directory.py \$1)
}
# jump-directory commands end"

echo -e "$WRITE_STR" >> $LOGIN_FILE