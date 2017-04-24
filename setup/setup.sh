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
    found_dir=\`python /home/james/jump-directory/setup/../src/jump_directory.py \$1\`
    if [ -n \"\$found_dir\" ]; then
        cd \$found_dir
    else
        echo \"jd: cannot find \$1\"
    fi
}
# jump-directory commands end"

echo -e "$WRITE_STR" >> $LOGIN_FILE
mkdir $DIR/../data &> /dev/null
touch $DIR/../data/cd_history.txt