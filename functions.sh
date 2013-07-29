
# cat which - print the source of an executable on the path by name
cw() {
    cat `which $1`
}

# ps grep - grep for a running process but not "grep"
psg() {
    ps aux |grep $1 |grep -v grep
}

cleanMavenSnapshots() {
    find $HOME/.m2/repository -name '*SNAPSHOT*' ! -atime -40d -print -delete
    echo 'purged old unused (40 days) snapshots from maven repo'
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
    lsof -nP -i4TCP | grep LISTEN
}
