#!/bin/bash

source /home/user/.local/.axiom.env

EVENT_TYPE="$1"
if [ -z "$EVENT_TYPE" ]; then
  echo "Need event type"
  exit 1
fi

mkdir -p "$(dirname "$AXIOM_LOCAL_FILE")"
# touch "$AXIOM_LOCAL_FILE"
# chmod 600 "$AXIOM_LOCAL_FILE"


TIMESTAMP=$(TZ=Europe/Moscow date +"%Y-%m-%dT%H:%M:%S%z")

BATTERY_PATH=$(find /sys/class/power_supply/ -type d -name "BAT*" | head -n 1)
BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "unknown")

IP=$(curl -s --max-time 2 api.ipify.org || echo "unavailable")

MESSAGE="${EVENT_TYPE} detected"

JSON=$(jq -n \
  --arg ts "$TIMESTAMP" \
  --arg event "$EVENT_TYPE" \
  --arg battery "$BATTERY_LEVEL" \
  --arg ip "$IP" \
  '{
    timestamp: $ts,
    event: $event,
    battery: $battery,
    ip: $ip
  }')

echo "$TIMESTAMP | $EVENT_TYPE | battery=$BATTERY_LEVEL | ip=$IP" >> "$HOME/.auth_event_log"

curl -s -X POST https://api.axiom.co/v1/datasets/auth_logs/ingest \
  -H "Authorization: Bearer $AXIOM_API_KEY" \
  -H "Content-Type: application/json" \
  -d "[$JSON]"
