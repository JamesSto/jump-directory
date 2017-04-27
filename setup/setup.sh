#!/usr/bin/env bash

unamestr=`uname`
if [ -z "$1" ]; then
    if [[ "$unamestr" == 'Darwin' ]]; then  # Setup for OSX
        echo "No login file specified; defaulting to ~/.bash_profile"
        LOGIN_FILE="$HOME/.bash_profile"
    else    
        echo "No login file specified; defaulting to ~/.bashrc"
        LOGIN_FILE="$HOME/.bashrc"
    fi
else
    LOGIN_FILE=$1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$unamestr" == 'Darwin' ]]; then
    READLINK="greadlink"
else
    READLINK="readlink"
fi


BASHRC_STR="
# Commands added by jump-directory on `date`
function cd() {
    builtin cd \"\$@\"
    RV=\$?
    if [ \$RV -ne 0 ]; then
        return \$RV
    fi
    pwd >> $DIR/../data/cd_history.txt
}
function jd() {
    found_dir=\`python $DIR/../src/jump_directory.py \"\$@\"\`
    if [[ \$found_dir == \[RET_DIR\]* ]]; then
        direc=\`echo \$found_dir | cut -c10-\`
        if [ -n \"\$direc\" ]; then
            cd \$direc
        else
            echo \"jd: cannot find \$@\"
        fi
    else
        echo \"\$found_dir\"
    fi
}
# jump-directory commands end
"

echo -e "$BASHRC_STR" >> $LOGIN_FILE
mkdir $DIR/../data &> /dev/null
touch $DIR/../data/cd_history.txt

COMPLETION_FUNC="
# Function for autocompletion of jd command
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
complete -o nospace -F _jd jd
"

BASH_COMPLETION_DIR="$HOME/.bash_completion"
echo -e "$COMPLETION_FUNC" >> "$BASH_COMPLETION_DIR"
