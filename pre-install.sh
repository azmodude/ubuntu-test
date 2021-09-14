#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 ${DEVP}3
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 ${DEVP}4

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}3 crypt-swap
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}4 crypt-system

sudo mkfs.xfs -L boot /${DEVP}2
sudo mkfs.vfat -F 16 -n ESP ${DEVP}1
