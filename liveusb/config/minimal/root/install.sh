#!/bin/env bash
###############################################################################################################################################################################################################
mount ${1}1 /boot
###############################################################################################################################################################################################################
sgdisk ${1} --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=${1}
syslinux-install_update -i
sed "s/CHANGEMEH/$(blkid ${1}1 -s PARTUUID -o value)/" /root/syslinux.cfg > /boot/syslinux/syslinux.cfg
###############################################################################################################################################################################################################
bootctl --path /boot install
sed "s/CHANGEMEH/$(blkid ${1}1 -s PARTUUID -o value)/" /root/arch.conf > /boot/loader/entries/arch.conf
cp /root/loader.conf /boot/loader
###############################################################################################################################################################################################################
mkinitcpio -p linux
rm -r /boot/initramfs-linux-fallback.img
###############################################################################################################################################################################################################

###############################################################################################################################################################################################################
locale-gen
loadkeys uk
#ln -sf /usr/share/zoneinfo/UTC /etc/localtime
if [[ -f /usr/bin/pinentry ]];then rm /usr/bin/pinentry;ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;else ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;fi
###############################################################################################################################################################################################################
chmod -R 700 /root
chmod -R 700 /etc/iptables
passwd -l root
###############################################################################################################################################################################################################
user=$(shuf -i 60000-65536 -n 1)
group=$(shuf -i 60000-65536 -n 1)
groupadd --gid ${group} group
useradd --uid ${user} -g group -s /bin/bash user
gpasswd -a user wheel
chown -R user:group /home/user
chmod -R 700 /home/user
passwd -l user
###############################################################################################################################################################################################################
systemctl enable iptables
#systemctl enable nftables
systemctl enable haveged.service
systemctl enable systemd-networkd.service
#systemctl enable systemd-resolved.service
systemctl enable dnscrypt-proxy.service
systemctl enable combine.service
rm /etc/systemd/system/remote-fs.service
###############################################################################################################################################################################################################
umount /boot
rmdir  /boot
###############################################################################################################################################################################################################
rm -r /var/lib/pacman/sync/*
###############################################################################################################################################################################################################
