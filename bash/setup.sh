#!/bin/bash

# Setup directory layout
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
rm -rf ~/.vim
cp -r $DIR/ ~/.vim

# Copy dotfiles to home folder
yes | cp -rf ~/.vim/vimrc ~/.vimrc
yes | cp -rf ~/.vim/inputrc ~/.inputrc

# Setup submodules
git init ~/.vim
git -C ~/.vim submodule init
git -C ~/.vim submodule update