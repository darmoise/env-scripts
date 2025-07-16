#!/bin/bash

HASH_REF="${ETC_BASE}/${INTEGRITY_DIR}/${INTEGRITY_FILENAME}"
HASH_TMP="${RUN_BASE}/${INTEGRITY_DIR}/${INTEGRITY_FILENAME}.tmp"

PCR_REF="${ETC_BASE}/${INTEGRITY_DIR}/${PCR_FILENAME}"
PCR_TMP="${RUN_BASE}/${INTEGRITY_DIR}/${PCR_FILENAME}.tmp"

mkdir -p /run/bi
find /boot -type f ! -name grubenv -exec sha256sum {} \; | sort > "$HASH_TMP"

if ! cmp -s "$HASH_REF" "$HASH_TMP"; then
    echo "[!] Integrity hash error!."
    logger -p auth.warning "Integrity hash error!"
else
    echo "[OK] Integrity hash NO errors..."
    logger -p info "[OK]: Integrity hash NO errors..."
fi

tpm2_pcrread sha256 > "$PCR_TMP"

if ! cmp -s "$PCR_REF" "$PCR_TMP"; then
    echo "[!] Integrity PCR error!" >&2
    logger -p auth.warning "Integrity PCR error"
else
    echo "[OK] Integrity PCR NO errors"
    logger -p info "[OK] Integrity PCR NO errors"
fi