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
    if [ -n \"\$1\" ]; then 
        echo \`$READLINK -fe \$1\` >> $DIR/../data/cd_history.txt 
    fi
    builtin cd \"\$1\"
}
function jd() {
    found_dir=\`python $DIR/../src/jump_directory.py \$1\`
    if [ -n \"\$found_dir\" ]; then
        cd \$found_dir
    else
        echo \"jd: cannot find \$1\"
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
