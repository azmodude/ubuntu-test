#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 ${DEVP}3
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}3 ${DM}3_crypt

sudo mkfs.xfs -L boot /${DEVP}2
sudo mkfs.vfat -F 16 -n ESP ${DEVP}1

sudo pvcreate /dev/mapper/${DM}3_crypt
sudo vgcreate ubuntu-vg /dev/mapper/${DM}3_crypt
sudo lvcreate -L ${SWAP_SIZE} -n swap_1 ubuntu-vg
sudo lvcreate -l 100%FREE -n root ubuntu-vg
