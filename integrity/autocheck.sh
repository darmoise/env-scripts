#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Found .env file: $ENV_FILE" >&2
    exit 1
fi

if [ -z "$INTEGRITY_CHECK_SCRIPT" ]; then
    echo "INTEGRITY_CHECK_SCRIPT not exist in .env" >&2
    exit 1
fi

pkexec "$INTEGRITY_CHECK_SCRIPT"
read -p "Click Enter to close window..."