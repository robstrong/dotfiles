#!/bin/bash
set -e

sudo apt-get install -y git vim zsh
git clone --recursive git@github.com:robstrong/dotfiles ~/.dotfiles
cd ~/.dotfiles
git init
git submodule update
ln -s ~/.dotfiles/vim ~/.vim
vim +PluginInstall +qall
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
chsh -s $(which zsh)
