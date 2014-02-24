# like which but works with functions and aliases too
wot() {
    which $1 || declare -f $1 || alias $1
}

# cat which - print the source of an executable on the path by name
cw() {
    cat `which $1`
}

# ps grep - grep for a running process but not "grep"
psg() {
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

# lists processes listening on tcp ports
listeners() {
    lsof -i -P -n -sTCP:LISTEN $@
}

# starts an http server with docroot in the current directory
server () 
{ 
    local host=`hostname`;
    local port="${1:-8888}";
    ( sleep 1 && open "http://${host}:${port}/" ) & python -m SimpleHTTPServer "$port"
}
