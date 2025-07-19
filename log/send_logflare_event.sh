#!/bin/bash

source /home/user/.local/bin/.logflare.env

EVENT_TYPE="$1"
if [ -z "$EVENT_TYPE" ]; then
  echo "Need event type"
  exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

BATTERY_PATH=$(find /sys/class/power_supply/ -type d -name "BAT*" | head -n 1)
BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "unknown")

IP=$(curl -s --max-time 2 api.ipify.org || echo "unavailable")

MESSAGE="${EVENT_TYPE} detected"

JSON=$(jq -n \
  --arg msg "$MESSAGE" \
  --arg ts "$TIMESTAMP" \
  --arg battery "$BATTERY_LEVEL" \
  --arg ip "$IP" \
  '{message: $msg, timestamp: $ts, battery: $battery, ip: $ip}')

curl -s -X POST https://api.logflare.app/logs \
  -H "Content-Type: application/json" \
  -H "X-API-KEY: $LOGFLARE_API_KEY" \
  -d "{\"source\": \"$LOGFLARE_SOURCE_ID\", \"event\": $JSON}"

