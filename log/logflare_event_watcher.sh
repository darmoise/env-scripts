#!/bin/bash

gdbus monitor --session --dest org.gnome.ScreenSaver |
while read -r line; do
  echo "line: $line"
  if echo "$line" | grep -q "WakeUpScreen"; then
    /usr/local/bin/lfs.sh screen_unlocked
  elif echo "$line" | grep -q "ActiveChanged.*true"; then
    /usr/local/bin/lfs.sh screen_locked
  fi
done