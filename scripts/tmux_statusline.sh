#!/bin/bash -e
DATA=${XDG_RUNTIME_DIR}/tmux.data
NICS=("eth0" "eno1")

network_tab () {
  printf "#[fg=colour27,bg=colour0]#[bg=colour27] "
  net="$(cat /proc/net/dev)"
  for nic in "${NICS[@]}"; do
    curr=($(echo "$net" | awk "/$nic:/ {printf \$2\" \"\$10}"))
    test "${#curr[@]}" -eq "2" && break
  done
  curr_rx=${curr[0]}
  curr_tx=${curr[1]}
  curr_ts=$(date +%s)

  test -r ${DATA} \
    && prev=($(cat ${DATA} 2>/dev/null))
  [[ -z "${prev[0]}" || -z "${prev[1]}" || -z "${prev[2]}" ]] \
    && prev=(${curr_rx} ${curr_tx} ${curr_ts})
  prev_rx=${prev[0]}
  prev_tx=${prev[1]}
  prev_ts=${prev[2]}
  echo "${curr_rx} ${curr_tx} ${curr_ts}" > ${DATA}

  diff_ts=$((curr_ts-prev_ts))
  if [[ $diff_ts = 0 ]]; then
    rate_rx="#[fg=colour249]        "
    rate_tx="${rate_rx}"
  else
    diff_rx=$(echo | awk "{printf(\"%f\", (($curr_rx-$prev_rx)/$diff_ts))}")
    diff_tx=$(echo | awk "{printf(\"%f\", (($curr_tx-$prev_tx)/$diff_ts))}")
    rate=($(numfmt --format='%.1fB/s' --to=iec $diff_rx $diff_tx))
    rate_rx="$(echo ${rate[0]} | \
               sed -r 's/([0-9])([A-Za-z])/\1#[fg=colour249]\2/g')"
    rate_tx="$(echo ${rate[1]} | \
               sed -r 's/([0-9])([A-Za-z])/\1#[fg=colour249]\2/g')"
  fi
  printf "#[fg=colour249]↓#[fg=colour255]%24s " "${rate_rx}"
  printf "#[fg=colour249]↑#[fg=colour255]%24s " "${rate_tx}"
  printf "#[fg=colour0,bg=colour27]#[bg=colour0]"
}

load_tab () {
  echo -n "#[bg=colour0]#[fg=colour34,bg=colour0]#[fg=colour255,bg=colour34] "
  awk '{printf $1" "$2" "$3}' /proc/loadavg
  echo -n " #[fg=colour0,bg=colour34]#[fg=colour220,bg=colour0]"
}

time_tab () {
  echo -n "#[fg=colour220,bg=colour0]#[fg=colour0,bg=colour220] "
  echo -n "$(date +'%l:%M:%S %p' | tr -d ' ') #[default]"
}

network_tab
load_tab
time_tab
