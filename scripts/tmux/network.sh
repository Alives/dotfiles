#!/bin/bash -e

TMUX_SESSION=$(tmux list-session | awk -F: '/attached/ {print $1}')
NETWORK_CACHE=/tmp/tmux_network_cache.${TMUX_SESSION}

case ${OS_TYPE} in
  Darwin)
    DATA_SOURCE=$(netstat -nbi | awk 'NR>1 && !/^lo/ {rbytes+=$7; tbytes+=$10} END {printf "%0.0f %0.0f\n", rbytes, tbytes}')
    ;;
  Linux)
    DATA_SOURCE=$(awk 'NR>2 && !/^[ ]+lo/ {rbytes+=$2; tbytes+=$10} END {printf "%0.0f %0.0f\n", rbytes, tbytes}' /proc/net/dev)
    ;;
esac

function scale {
  rate=$1
  if [ ${rate} -gt 1073741824 ]; then
    units="GB/s"
    rate=$((${rate}/1073741824))
  elif [ ${rate} -gt 1048576 ]; then
    units="MB/s"
    rate=$((${rate}/1048576))
  elif [ ${rate} -gt 1024 ]; then
    units="KB/s"
    rate=$((${rate}/1024))
  else
    # I don't care about b/s.
    units="KB/s"
    rate=0
  fi
  return
}

read prev_time prev_rbytes prev_tbytes <<< $(cat ${NETWORK_CACHE} 2>/dev/null || echo "0 0 0")
read curr_rbytes curr_tbytes <<< ${DATA_SOURCE}
curr_time=$(date +%s)
echo -n "${curr_time} ${curr_rbytes} ${curr_tbytes}" > ${NETWORK_CACHE}
[ ${prev_time} -eq 0 ] && exit
d_tbytes=$((${curr_tbytes} - ${prev_tbytes}))
d_rbytes=$((${curr_rbytes} - ${prev_rbytes}))
d_time=$((${curr_time} - ${prev_time}))
[ ${d_time} -eq 0 ] && exit
rbytes=$(($d_rbytes / $d_time))
tbytes=$(($d_tbytes / $d_time))

scale ${rbytes}
printf "↓%0.0f%s " ${rate} ${units}
scale ${tbytes}
printf "↑%0.0f%s\n" ${rate} ${units}
