#!/bin/env bash
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
###############################################################################################################################################################################################################
mount ${boot} /boot
###############################################################################################################################################################################################################
sgdisk ${dev} --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=${dev}
syslinux-install_update -i
sed "s/CHANGEMEH/$(blkid ${boot} -s PARTUUID -o value)/" /root/syslinux.cfg > /boot/syslinux/syslinux.cfg
###############################################################################################################################################################################################################
bootctl --path /boot install
sed "s/CHANGEMEH/$(blkid ${boot} -s PARTUUID -o value)/" /root/arch.conf > /boot/loader/entries/arch.conf
cp /root/loader.conf /boot/loader
###############################################################################################################################################################################################################
mkinitcpio -p linux-lts
rm -r /boot/initramfs-linux-lts-fallback.img
###############################################################################################################################################################################################################

###############################################################################################################################################################################################################
locale-gen
loadkeys uk
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
if [[ -f /usr/bin/pinentry ]];then rm /usr/bin/pinentry;ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;else ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;fi
###############################################################################################################################################################################################################
chmod -R 700 /root
chmod -R 700 /etc/iptables
passwd -l root
###############################################################################################################################################################################################################
groupadd group
useradd -g group -s /bin/bash user;
chown -R user:group /home/user;
chmod -R 700 /home/user
passwd -l user
###############################################################################################################################################################################################################
aticonfig --initial
systemctl enable iptables
systemctl enable systemd-networkd.service
systemctl enable catalyst-hook
###############################################################################################################################################################################################################
umount /boot
rm -r /boot
###############################################################################################################################################################################################################
