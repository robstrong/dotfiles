#!/bin/bash
set -e

git clone git@github.com:robstrong/dotfiles ~/.dotfiles
cd ~/.dotfiles
git init
git submodule update
vim +PluginInstall +qall
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/zshrc ~/.zshrc
