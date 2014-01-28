#!/bin/bash

STATUSLINE_FILE="${HOME}/.tmux.statusline.txt"
STATUSLINE_LOCK="${HOME}/.tmux.statusline.pid"
RUN_STATUSLINE="/usr/bin/env python ${HOME}/.dotfiles/scripts/tmux/statusline.py \
  2>/tmp/tmux.statusline.stderr \
  > /tmp/tmux.statusline.stdout &"

if [ ! -r ${STATUSLINE_LOCK} ]; then
  ${RUN_STATUSLINE}
else
  pid=$(cat ${STATUSLINE_LOCK})
  ps -p ${pid} | grep -qi python
  if [ $? != 0 ]; then
    ${RUN_STATUSLINE}
  fi
  cat ${STATUSLINE_FILE}
fi
