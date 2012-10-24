for entry in $(seq 1 10); do
  wget -qO /dev/null --timeout=1 \
    "http://127.0.0.1:32400/library/sections/${entry}/refresh" &
done
