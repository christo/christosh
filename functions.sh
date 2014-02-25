wot() {
    # like which but works with functions and aliases too
    which $1 || declare -f $1 || alias $1
}

cw() {
    # cat which - print the source of an executable on the path by name
    cat `which $1`
}

psg() {
    # ps grep - grep for a running process but not "grep"
    ps aux |grep $1 |grep -v grep
}

cleanMavenSnapshots() {
    local days=${1:-40}
    find $HOME/.m2/repository -name '*SNAPSHOT*' ! -atime -${days}d -print -delete
    echo "$? purged old unused (${days} days) snapshots from maven repo"
}

cleanMacPoo() {
    if [[ $# != 1 ]]; then 
        echo 'usage: cleanMacPoo <dir>'
    else
        echo cleaning from $1 :
        find $1 -name '._*' -o -name '.Spotlight-*' -o -name '.fseventsd' -print -delete
    fi
}

listeners() {
    # lists processes listening on tcp ports
    lsof -i -P -n -sTCP:LISTEN $@
}

server () 
{ 
    # starts an http server with docroot in the current directory
    local host=`hostname`;
    local port="${1:-8888}";
    ( sleep 1 && open "http://${host}:${port}/" ) & python -m SimpleHTTPServer "$port"
}

man() {
    # adds colour
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;148m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

pigs() {
    # which processes are consuming most cpu?
    ps auxrww | head -n 5
}
