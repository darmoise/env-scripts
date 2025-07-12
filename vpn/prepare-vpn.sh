#!/bin/bash
CLIENT=$1

cd ~/openvpn-ca
./easyrsa gen-req $CLIENT nopass
./easyrsa sign-req client $CLIENT

cd ~/client-configs
./make-config.sh $CLIENT