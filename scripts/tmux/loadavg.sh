#!/bin/sh -e
test "${OS_TYPE}" = "Darwin" && \
  uptime | awk -F'load average: ' '{gsub(/,/, ""); print $NF}' || \
  cut -f1-3 -d' ' /proc/loadavg
