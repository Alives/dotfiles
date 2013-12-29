#!/bin/bash -e
REPO=$(git rev-parse --show-toplevel)


function Deploy {
  entry=$(basename $1)
  if [ -e ${HOME}/.${entry} ]; then
    mkdir ${HOME}/backups 2>/dev/null
    mv -v ${HOME}/.${entry} ${HOME}/backups/${entry}
  fi
  ln -sv ${REPO}/${entry} ${HOME}/.${entry}
}

export -f Deploy
export REPO

find ${REPO} -maxdepth 1 -type f -name '[^.]*' -exec bash -c 'Deploy "$0"' {} \;
Deploy ssh
Deploy vim
