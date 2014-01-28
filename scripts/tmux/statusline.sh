#!/bin/bash

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
  nc 127.0.0.1 61234
fi
