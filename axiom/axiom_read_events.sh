#!/bin/bash
source /home/user/.local/.axiom.env

START_TIME=$(date -u -d '3 days ago' +%Y-%m-%dT%H:%M:%SZ)
END_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)

curl -s -X POST "https://api.axiom.co/v1/datasets/$AXIOM_DATASET/query" \
  -H "Authorization: Bearer $AXIOM_API_KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF |
{
  "startTime": "$START_TIME",
  "endTime": "$END_TIME",
  "limit": 100,
  "order": [
    {
      "field": "timestamp",
      "direction": "desc"
    }
  ]
}
EOF
jq -r '.matches[].data | "\(.timestamp) \(.event) \(.ip) \(.battery)"' | while read -r ts event ip battery; do
  ts_msk=$(TZ=Europe/Moscow date -d "$ts" +"%Y-%m-%d %H:%M:%S")
  echo "$ts_msk $event ip=$ip battery=$battery"
done