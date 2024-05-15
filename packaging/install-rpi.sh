#!/usr/bin/env bash

sudo apt update

# minimal
sudo apt install -y git neovim zsh neofetch


mkdir -p ~/.ssh
chmod 700 ~/.ssh

mkdir -p ~/src/christo

echo TODO: add public key to ~/.ssh/authorized_keys
echo TODO: clone or pull https://github.com/christo/christosh.git to ~/src/christo
