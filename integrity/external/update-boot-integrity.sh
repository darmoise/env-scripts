#!/bin/bash

HASH_OUT="${ETC_BASE}/${INTEGRITY_DIR}/${INTEGRITY_FILENAME}"
PCR_OUT="${ETC_BASE}/${INTEGRITY_DIR}/${PCR_FILENAME}"

mkdir -p "$(dirname "$HASH_OUT")"
find /boot -type f ! -name grubenv -exec sha256sum {} \; | sort > "$HASH_OUT"
logger -p info "sha256 updated"
echo "sha256 updated"

tpm2_pcrread sha256 > "$PCR_OUT"
echo "PCR updated"