#!/usr/bin/env zsh

# installs dotfiles
# TODO research stow and decide if it's better
#

read -rq "GO_AHEAD?This script will overwrite local machine configuration files, OK? y/n"
if [[ "$GO_AHEAD" != "y" ]]; then
    echo ok exiting
    exit
fi

echo "making local changes"
echo temp exiting
exit 1
# machine install one-time config
#

if [[ $(uname) == 'Darwin' ]]; then
    "$CHRISTOSH_HOME"/mac-setup.sh
fi

# install dotfiles, asking for confirmation

cp -i dotfiles/.tmux.conf ~/
