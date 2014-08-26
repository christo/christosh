# like which but works with functions and aliases too
wot() {
    local it=$1
    declare -f $it || (e=`alias $it 2>&1` && echo $e) || which $it
}

#edit profile files
epfl() {
    vim -o ~/.bash_profile ~/.bashrc
}

#command line media player, good for console streaming radio
cvlc() {
    /Applications/VLC.app/Contents/MacOS/VLC -I rc $@
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
    local days=${1:-30}
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

#diskfull root filesystem percentage only
dfull() {
    df / | tail -n 1 | perl -ne '/((\S+\s+){8})(\S+\s+)/ && print"$2\n"'
}  

mcis() {
    mvn clean install -DskipTests $@
    cowbell
}

#somafm.com has many streaming radio shows
soma() {
    if [[ -z "$1" ]]; then
       cat <<ENDO
        usage: soma <showname>
        e.g.: 

        soma groovesalad
        soma dronezone
        soma dubstep
        soma deepspaceone
        soma missioncontrol
        soma lush
ENDO
    
    else
        cvlc "http://somafm.com/$1.pls"
    fi
}  

# lists processes listening on tcp ports
listeners() {
    lsof -i -P -n -sTCP:LISTEN $@
}

# starts an http server with docroot in the current directory
server () { 
    local host=`hostname`;
    local port="${1:-8888}";
    ( sleep 1 && open "http://${host}:${port}/" ) & python -m SimpleHTTPServer "$port"
}

# adds colour
man() {
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

mvno() {
    mvn -o $@
}
