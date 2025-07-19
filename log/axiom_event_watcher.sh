#!/bin/bash

send_event() {
  /usr/local/bin/send_axiom_event.sh $1
}

gdbus monitor --system --dest org.freedesktop.login1 |
while read -r line; do
  if echo "$line" | grep -q "LockedHint': <true>"; then
    send_event "screen_locked"
  elif echo "$line" | grep -q "LockedHint': <false>"; then
    send_event "screen_unlocked"
  fi
done