#!/bin/env bash
###############################################################################################################################################################################################################
mkdir -p ./rootfs/
mkdir -p ./mount/
mount ${1} ./mount
###############################################################################################################################################################################################################
pacstrap -cGMd ./rootfs $(cat ./packages)
cp -arfv airootfs/* rootfs/

cp ./install.sh ./rootfs/root/
arch-chroot ./rootfs /root/install.sh ${1}
###############################################################################################################################################################################################################
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" syslinux.cfg > ./rootfs/boot/syslinux/syslinux.cfg
bootctl --path ./mount install
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" arch.conf    > ./mount/loader/entries/arch.conf
cp -ar ./rootfs/boot/* ./mount/
sync
rm -r ./rootfs/boot
mksquashfs rootfs ./mount/rootfs.squashfs
sync
#umount ./mount
sync
echo " quick and dirty... "
