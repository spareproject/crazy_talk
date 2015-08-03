#!/bin/env bash
###############################################################################################################################################################################################################
mkdir -p ./rootfs/boot
mkdir -p ./mount/
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
###############################################################################################################################################################################################################
echo "
debuggery...
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
"

mount ${boot} ./rootfs/boot

ls ./rootfs/boot
lsblk
read -rp "ffs..." 

pacstrap -C ./pacman.conf -cGMd ./rootfs $(for i in $(cat packages);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
sync
clear;cat /etc/banner
ls -al ./rootfs/boot
read -rp "apperently doesnt install vmlinuz"
umount ./rootfs/boot
cp -arfv airootfs/* rootfs/
arch-chroot ./rootfs /root/install.sh ${dev}
###############################################################################################################################################################################################################
sync
umount ./rootfs/boot
rm -r ./rootfs/boot

idproduct=$(udevadm info ${dev} | grep -e ID_MODEL_ID | sed 's/E: ID_MODEL_ID=//')
idvendor=$(udevadm info ${dev} | grep -e ID_VENDOR_ID | sed 's/E: ID_VENDOR_ID=//')
iserial=$(udevadm info ${dev} | grep -e ID_SERIAL_SHORT | sed 's/E: ID_SERIAL_SHORT=//')
sed -i -e "s/IDVENDOR/${idvendor}/" -e "s/IDPRODUCT/${idproduct}/" -e "s/SERIAL/${iserial}/" ./rootfs/root/09-gnupg.rules

mount ${boot} ./mount
mksquashfs ./rootfs ./mount/rootfs.squashfs
sync
echo " quick and dirty... "
###############################################################################################################################################################################################################
