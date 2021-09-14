#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

total_memory=$(lsmem | grep "^Total online memory" | \
    sed -r 's/^Total online memory:\s+([0-9]+G)/\1/')

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 ${DEVP}3
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}3 ${DM}3_crypt

sudo mkfs.xfs -L boot /${DEVP}2
sudo mkfs.vfat -F 16 -n ESP ${DEVP}1

sudo pvcreate /dev/mapper/${DM}3_crypt
sudo vgcreate ubuntu-vg /dev/mapper/${DM}3_crypt
sudo lvcreate -L ${SWAP_SIZE:-${total_memory}} -n swap_1 ubuntu-vg
sudo lvcreate -l 100%FREE -n root ubuntu-vg
