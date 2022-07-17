#!usr/bin/env zsh

# machine install one-time config
#

if [[ `uname` == 'Darwin' ]]; then
    $CHRISTOSH_HOME/mac-setup.sh
fi

# install dotfiles

cp -i dotfiles/.tmux.conf ~/
