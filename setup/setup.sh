#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No login file specified; defaulting to ~/.bashrc"
    LOGIN_FILE="$HOME/.bashrc"
else
    LOGIN_FILE=$1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


BASHRC_STR="# Commands added by jump-directory on `date`
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

echo -e "$BASHRC_STR" >> $LOGIN_FILE
mkdir $DIR/../data &> /dev/null
touch $DIR/../data/cd_history.txt

COMPLETION_FUNC="# Function for autocompletion of jd command
SRC_DIR=$DIR/../src

_jd()
{
    local cur prev opts
    COMPREPLY=()
    cur=\"\${COMP_WORDS[COMP_CWORD]}\"
    prev=\"\${COMP_WORDS[COMP_CWORD-1]}\"
    opts=\`python \$SRC_DIR/get_completions.py \$cur\`

    COMPREPLY=( \$(compgen -W \"\${opts}\" -- \${cur}) )
    return 0
}
complete -o nospace -F _jd jd"

echo -e "$COMPLETION_FUNC" > /etc/bash_completion.d/jump-directory