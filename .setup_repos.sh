#!/bin/sh

if [[ ! -d ~/scripts/z ]]; then
  git clone http://github.com/rupa/z ~/scripts/z
  echo "" > ~/.z
fi
