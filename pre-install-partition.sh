#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

total_memory=$(lsmem | grep "^Total online memory" | \
    sed -r 's/^Total online memory:\s+([0-9]+G)/\1/')

for i in 1 2 3 4; do
    sudo sgdisk --delete=${i} ${DEV} || true
done
sudo partprobe && sleep 2

sudo sgdisk --new=1:0:+768M ${DEV} # EFI
sudo sgdisk --new=2:0:+2G ${DEV} # /boot
sudo sgdisk --new=3:0:+${LVM_SIZE} ${DEV}
sudo sgdisk --typecode=1:ef00 --typecode=2:8300 --typecode=l:8301 ${DEV}
sudo sgdisk --change-name=1:ESP --change-name=2:boot --change-name=3:swap \
    --change-name=3:root${DEV}

sudo partprobe

echo "Rebooting is the safe option if partprobe complained."
