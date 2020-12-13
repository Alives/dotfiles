#!/bin/bash -e
DATA=${XDG_RUNTIME_DIR}/tmux.data
test -r ${DATA} || touch ${DATA}

rate () {
  echo | \
    awk -v curr="$1" -v prev="$2" -v sec="$3" '{
      c=1;
      rate=((curr-prev)/sec);
      split("b KB MB GB", u);
      while(rate>1024){rate/=1024; c++}
      printf("%.1f#[fg=colour249]%s", rate, u[c])}' | \
    sed -e 's/b/ b/g'
}

network_tab () {
  local -r nic="$(awk '$2 == "00000000" {print $1}' /proc/net/route)"
  declare -a curr prev
  readarray -t prev < "${DATA}" 2>/dev/null
  readarray -t curr < <(grep "${nic}: " /proc/net/dev | \
    awk '{gsub(":",""); printf $1"\n"$2"\n"$10}')
  curr+=( "$(date +%s.%N)" )
  local -ir curr_rx=${curr[1]}
  local -ir curr_tx=${curr[2]}
  local -r curr_ts=${curr[3]}

  test "${#prev[@]}" -ne "4" && prev=( "${curr[@]}" )
  local -ir prev_rx=${prev[1]}
  local -ir prev_tx=${prev[2]}
  local -r prev_ts=${prev[3]}
  echo "${curr[@]}" | tr ' ' '\n' > "${DATA}"

  local -r diff_ts=$(echo "${curr_ts}" "${prev_ts}" | awk '{print $1-$2}')
  if [[ $diff_ts = 0 ]]; then
    sleep "$(echo "${curr_ts}" | awk '{print 1-($1 % 1)}')"
    local -r rate_rx="#[fg=colour249]        "
    local -r rate_tx="${rate_rx}"
  else
    local -r rate_rx=$(rate "${curr_rx}" "${prev_rx}" "${diff_ts}")
    local -r rate_tx=$(rate "${curr_tx}" "${prev_tx}" "${diff_ts}")
  fi
  printf "#[fg=colour27,bg=colour0]#[bg=colour27] "
  printf "#[fg=colour249]↓#[fg=colour255]%23s " "${rate_rx}"
  printf "#[fg=colour249]↑#[fg=colour255]%23s " "${rate_tx}"
  printf "#[fg=colour0,bg=colour27]#[bg=colour0]"
}

load_tab () {
  echo -n "#[bg=colour0]#[fg=colour34,bg=colour0]#[fg=colour255,bg=colour34] "
  awk '{printf $1" "$2" "$3}' /proc/loadavg
  echo -n " #[fg=colour0,bg=colour34]#[fg=colour220,bg=colour0]"
}

time_tab () {
  echo -n "#[fg=colour220,bg=colour0]#[fg=colour0,bg=colour220] "
  echo -n "$(date +'%l:%M:%S %p' | xargs) #[default]"
}

network_tab
load_tab
time_tab
