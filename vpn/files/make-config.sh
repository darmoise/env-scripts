#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo "Enter client name: ./make-config.sh client1"
    exit 1
fi

KEY_DIR=~/openvpn-ca/pki
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf

mkdir -p ${OUTPUT_DIR}

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/issued/${CLIENT}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/private/${CLIENT}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ~/openvpn-ca/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${CLIENT}.ovpn

echo "Done: ${OUTPUT_DIR}/${CLIENT}.ovpn"
