#!/bin/env bash
###############################################################################################################################################################################################################
mkdir -p ./rootfs
###############################################################################################################################################################################################################
pacstrap -C ./pacman.conf -cGMd ./rootfs $(for i in $(cat packages);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv airootfs/* rootfs/
arch-chroot ./rootfs /root/install.sh ${dev}
###############################################################################################################################################################################################################
