#!/bin/sh

PATH=/Users/friedman/homebrew/bin:/Users/friedman/homebrew/sbin:/Users/friedman/homebrew/opt/coreutils/libexec/gnubin:/Users/friedman/scripts:/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/bin/g4bin:/usr/local/sbin

WGET='/Users/friedman/homebrew/bin/wget -qO /dev/null'
URL='http://127.0.0.1:8080/api?apikey=52bfbc6fd091dff77b6d45bdce0430a6&mode'

case $1 in
  stop)
    ${WGET} ${URL}=pause
    /usr/bin/pkill 'Plex Media Server'
    /usr/bin/pkill -f SickBeard.py
    /usr/bin/pkill -f CouchPotato.py
    ;;
  *)
    ${WGET} ${URL}=resume || \
      /usr/bin/open /Applications/SABnzbd.app
    /usr/bin/pgrep -f 'Plex Media Server' || \
      /usr/bin/open /Applications/Plex\ Media\ Server.app
    /usr/bin/pgrep -f SickBeard.py || \
      /Users/friedman/scripts/sickbeard/SickBeard.py --daemon
    /usr/bin/pgrep -f CouchPotato.py || \
      /Users/friedman/scripts/CouchPotatoServer/CouchPotato.py
    ;;
esac
