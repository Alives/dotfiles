#!/bin/sh -e

# Load Average output for tmux status line.
# 0.12 0.09 0.07

case $(uname) in
  Darwin)
    uptime | awk -F'load average: ' '{gsub(/,/, ""); print $NF}' ;;
  Linux)
    cut -f1-3 -d' ' /proc/loadavg ;;
esac
