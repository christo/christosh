#!/usr/bin/env bash

# use bash for this; report on absence of preferred zsh 

# system sanity check for a pile of random system configuration settings changes made
# biased towards macos

retval=0

if [[ $(which neofetch) ]]; then
    neofetch
else
    echo "neofetch is missing"
fi

if [[ $(which machine) ]]; then
    echo -n "machine: "
    machine
elif [[ -e /proc/device-tree/model ]]; then 
    cat /proc/device-tree/model
    echo
else
    uname -a
fi

# check .ssh 
if [[ ! -d "$HOME/.ssh" ]]; then
    echo no .ssh dir in home
    echo create with:
    echo
    echo mkdir $HOME/.ssh
    echo chmod 700 $HOME/.ssh
    echo
    retval=1
fi

# terminfo 
if [[ -z "$TERMINFO" ]]; then
    echo
    echo TERMINFO is empty. Maybe add something like this to $HOME/.zshrc 
    echo export TERMINFO='/usr/share/terminfo/'
    echo see also https://unix.stackexchange.com/a/677744/428764
    retval=1
fi

# tmux 
TMUX_CONF="$HOME/.tmux.conf"
echo
if [[ ! $(which tmux) ]]; then
    echo tmux not installed
    retval=1
elif [[ -z "$TMUX_CONF" ]]; then
    echo "tmux is installed but TMUX_CONF is not defined"
elif [[ ! -f "$TMUX_CONF" ]]; then
    echo "TMUX_CONF is defined as '$TMUX_CONF' but the file does not exist"
    retval=1
elif [[ ! $(egrep '^set -g default-terminal "screen-256color"' ~/.tmux.conf) ]]; then
    echo "expected $TMUX_CONF to set default-terminal thus:"
    echo 'set -g default-terminal "screen-256color"'
    echo "but here\'s what I found for that:"
    echo $(grep 'set -g default-terminal' ~/.tmux.conf)
    retval=1
fi

# warn if missing but not fail
for i in cargo node gradle yt-dlp nvim spark neofetch ffmpeg figlet lein sbt jq npm unzip psql socat https svn hg wget curl bat docker bat; do
    if [[ ! $(which $i) ]]; then
        echo "warning: $i not found"
    fi
done

# these 

# common utilities
for i in git ghcup make gcc vim md5sum sha1sum zsh watch nc telnet perl rsync ssh nohup ; do
    if [[ ! $(which $i) ]]; then
        echo "fail: $i not found"
        retval=1
    fi
done

exit $retval
