#!/usr/env/bin bash
DIR=`dirname "${BASH_SOURCE[0]}"`

function cd() {
    builtin cd "$@"
    RV=$?
    if [ $RV -ne 0 ]; then
        return $RV
    fi
    pwd >> "$DIR/../data/cd_history.txt"
}
function jd() {
    found_dir=`$DIR/jump_directory.py "$@"`
    if [[ $found_dir == \[RET_DIR\]* ]]; then
        direc=`echo $found_dir | cut -c10-`
        if [ -n "$direc" ]; then
            cd "$direc"
        else
            echo "jd: cannot find $@"
        fi
    else
        echo "$found_dir"
    fi
}