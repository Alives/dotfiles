#!/bin/bash -ex
for name in bashrc tmux.conf vim vimrc zshrc; do
  ln -svfT ${HOME}/.dotfiles/$name ${HOME}/.$name
done

touch ${HOME}/.zshrc.local

git submodule init
git submodule update
