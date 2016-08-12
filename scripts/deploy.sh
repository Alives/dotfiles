#!/bin/bash -e
REPO=$(git rev-parse --show-toplevel)
path=$(basename ${REPO})


function Deploy {
  entry=$(basename $1)
  if [ -e ${HOME}/.${entry} ]; then
    mkdir ${HOME}/backups 2>/dev/null
    mv -v ${HOME}/.${entry} ${HOME}/backups/${entry}
  fi
  ln -sv ${path}/${entry} ${HOME}/.${entry}
}

export -f Deploy
export REPO path

find ${REPO} -maxdepth 1 -type f -name '[^.]*' -exec bash -c 'Deploy "$0"' {} \;
mv ${HOME}/.ssh_rc ${HOME}/.ssh/rc
Deploy vim

touch ${HOME}/.friedman.local

mkdir -p ~/scripts
git clone http://github.com/Alives/tmux-statusline ~/scripts/tmux-statusline

git submodule init
git submodule update
