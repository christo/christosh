# waits for the given pid to finish
waitfor() {
    while ( ps $1 >/dev/null ); do sleep 1; done
}

# unmounts a volume by name (note usb drives don't seem to power down)
unmountvol() {
    if [[ -z "$1" ]]; then
        echo 'usage: unmountvol <volumename>'
    else
        diskutil unmount `df |egrep "/Volumes/\Q$1\E" |cut -d\  -f 1`
    fi
}

# sends pasteboard (pb) contents to the clipboard of the target osx machine
pbto() {
    pbpaste | ssh "$1" pbcopy
}

# receives pasteboard (pb) contents from the clipboard of the target osx machine
pbfrom() {
    ssh "$1" pbpaste | pbcopy
}

# do something to the contents of the clipboard
pbdo() {
    cmd=$@
    pbpaste | eval $cmd  | pbcopy
}

# filter to normalise track descriptors to make suitable for search
# tracks typically have a form like this:
#   Track Name (Foobar Mix) - Artist Name
# the transformed result would be:
#   Track Name Foobar Mix Artist Name
trackclean() {
    perl -pe's/[\W\s]+/ /g and s/(^\s+|\s+$)//' 
}

# like which but works with functions and aliases too
# i've since been informed about the builtin "type" which should possibly be preferred 
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
    cat `which "$1"`
}

# ps grep - grep for a running process but not "grep"
# see also psgrep
psg() {
    ps aux |grep $@ |grep -v grep
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
    df / | tail -n 1 | perl -ne '/((\S+\s+){5})(\S+\s+)/ && print"$2\n"'
}  

# disk free root fs human readable
dfree() {
     df -h / | tail -1 | perl -ne '/(\S+\s+){3}(\S+)/ && print"$2\n"'
}

#sorted size totals in megs of given dir tree (or current)
megs() {
    du -m "${1:-.}" |sort -n
}

mcis() {
    mvn clean install -DskipTests $@
    cowbell
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

# which processes are consuming most cpu?
pigs() {
    ps auxrww | head -n 5
}

mvno() {
    mvn -o $@
}

# automated maven release 
mrelease() {
    mvn -B release:prepare && mvn release:perform
}

catmf() {
    unzip -c $1 META-INF/MANIFEST.MF
}

# how slammed am i?
# show recent load averages as comes from uptime as a sparkline
# shows sparkline if you have the spark program
ups() {
    l=`uptime | perl -p -e 's/.*averages: (.*)/$1/'`
    which spark >>/dev/null && echo $l |spark || echo $l
}

# do a git pull on repos under the current directory tree unless they're already fresh
gpullr() {
    # TODO trying to only do a pull if there is a remote as reported by zero exit from: git -C "$0" remote -v
    # GIT_TERMINAL_PROMPT=0 find . -name '.git' -maxdepth 5 -type d -mtime +1 | perl -pe 's/(.*)\.git/$1/' |xargs -I % bash -c '$(git -C "$0" remote -v) && echo $0 && git -C "$0" pull' % 
    for i in *; do find "$i" -name '.git' -maxdepth 6 -type d | perl -pe 's/(.*)\.git/$1/' |xargs -I % bash -c 'echo $0 && GIT_TERMINAL_PROMPT=0 git -C "$0" pull' % ; done
    #GIT_TERMINAL_PROMPT=0 find . -name '.git' -maxdepth 5 -type d -mtime +1 | perl -pe 's/(.*)\.git/$1/' |xargs -I % bash -c 'echo $0 && git -C "$0" pull' % 
}

mcd() {
    mkdir -p "$1" && cd "$1"
}

maketargets() {
    make -qp|perl -ne's/^(\w[^#\s.\t:]+):/$1/ && print "$1\n"'|sort -u
}


# VPNs: 
# AWS Sydney 
# AWS VPN
function vpn-connect {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "AWS Sydney" 
                if exists VPN then connect VPN
                repeat while (current configuration of VPN is not connected)
                    delay 1
                end repeat
        end tell
end tell
EOF
}

function vpn-disconnect {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "AWS Sydney" 
                if exists VPN then disconnect VPN
        end tell
end tell
return
EOF
}
alias vpnu='vpn-connect'
alias vpnd='vpn-disconnect'
alias remotes='git remote -v'
