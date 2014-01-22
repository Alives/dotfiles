#!/bin/sh -e
case $(uname) in
  Darwin)
    uptime | awk -F'load average: ' '{gsub(/,/, ""); print $NF}' ;;
  Linux)
    cut -f1-3 -d' ' /proc/loadavg ;;
esac
