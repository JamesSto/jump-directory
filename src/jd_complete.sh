DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

_jd()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=`python $DIR/get_completions.py $cur`

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -o nospace -F _jd jd

