#!/bin/bash
test "$(uname)" = "Darwin" && \
  uptime | awk -F'load averages: ' '{print $NF}' || \
  cut -f1-3 -d' ' /proc/loadavg
