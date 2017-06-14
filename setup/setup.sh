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

SETUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$unamestr" == 'Darwin' ]]; then
    READLINK="greadlink"
else
    READLINK="readlink"
fi


BASHRC_STR="
# Command added by jump-directory on `date`
source $SETUP_DIR/../src/jd_wrappers.sh
# jump-directory commands end
"

echo -e "$BASHRC_STR" >> $LOGIN_FILE
mkdir "$SETUP_DIR/../data" &> /dev/null
touch $SETUP_DIR/../data/cd_history.txt

COMPLETION_FUNC="
# Function for autocompletion of jd command
source $SETUP_DIR/../src/jd_complete.sh
"

BASH_COMPLETION_DIR="$HOME/.bash_completion"
echo -e "$COMPLETION_FUNC" >> "$BASH_COMPLETION_DIR"
