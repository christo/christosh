#!/usr/bin/env zsh


# system sanity check for a pile of random system configuration settings changes made
# biased towards macos

retval=0

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
if [[ ! $(which tmux) ]]; then
    echo
    echo tmux not installed
    retval=1
elif [[ ! -f "$TMUX_CONF" ]]; then
    echo 
    echo "$TMUX_CONF does not exist"
    retval=1
elif [[ ! $(egrep '^set -g default-terminal "screen-256color"' ~/.tmux.conf) ]]; then
    echo
    echo "expected $TMUX_CONF to set default-terminal thus:"
    echo 'set -g default-terminal "screen-256color"'
    echo "but here\'s what I found for that:"
    echo $(grep 'set -g default-terminal' ~/.tmux.conf)

    retval=1
fi

exit $retval
