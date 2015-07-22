#!/bin/env bash
###############################################################################################################################################################################################################
mkdir -p ./rootfs/
mkdir -p ./mount/
mount ${1} ./mount
###############################################################################################################################################################################################################
pacstrap -cGMd ./rootfs $(cat ./packages)
cp -arfv airootfs/* rootfs/
arch-chroot ./rootfs /root/install.sh ${1}
###############################################################################################################################################################################################################
mv    ./rootfs/boot/* ./mount/
rmdir ./rootfs/boot
bootctl --path ./mount install
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" ./boot/syslinux.cfg > ./mount/syslinux/syslinux.cfg
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" ./boot/arch.conf    > ./mount/loader/entries/arch.conf
mksquashfs rootfs ./mount/rootfs.squashfs
sync
echo " quick and dirty... "
