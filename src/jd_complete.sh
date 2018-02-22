DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


_file_completion () 
{ 
    local i IFS='
' xspec;
    _tilde "$cur" || return 0;
    local -a toks;
    local quoted x tmp;
    _quote_readline_by_ref "$cur" quoted;
    x=$( compgen -d -- "$quoted" ) && while read -r tmp; do
        toks+=("$tmp");
    done <<< "$x";
    x=`$DIR/get_completions.py "${cur[@]}"`
    eval toks=($x)
    if [[ "$1" != -d ]]; then
        xspec=${1:+"!*.@($1|${1^^})"};
        x=$( compgen -f -X "$xspec" -- $quoted ) && while read -r tmp; do
            toks+=("$tmp");
        done <<< "$x";
    fi;
    [[ -n ${COMP_FILEDIR_FALLBACK:-} && -n "$1" && "$1" != -d && ${#toks[@]} -lt 1 ]] && x=$( compgen -f -- $quoted ) && while read -r tmp; do
        toks+=("$tmp");
    done <<< "$x";
    if [[ ${#toks[@]} -ne 0 ]]; then
        compopt -o filenames 2> /dev/null;
        COMPREPLY+=("${toks[@]}");
    fi
}



_jd()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    _file_completion -d
    return 0
}
complete -o nospace -F _jd jd

