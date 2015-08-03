#!/bin/env bash
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
echo "
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
"
mount ${boot} /boot
sync
ls -al ./boot
read -rp "mounted from install.sh chroot"

sgdisk ${dev} --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=${dev}
mkdir /boot/syslinux
sed "s/CHANGEMEH/$(blkid ${boot} -s PARTUUID -o value)/" /root/syslinux.cfg > /boot/syslinux/syslinux.cfg
syslinux-install_update -i

bootctl --path /boot install
sed "s/CHANGEMEH/$(blkid ${boot} -s PARTUUID -o value)/" /root/arch.conf > /boot/loader/entries/arch.conf
cp /root/initramfs.conf /boot/loader/entries/
cp /root/loader.conf /boot/loader
mkinitcpio -p linux
rm -r /boot/initramfs-linux-fallback.img

###############################################################################################################################################################################################################
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
if [[ -f /usr/bin/pinentry ]];then rm /usr/bin/pinentry;ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;else ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;fi
###############################################################################################################################################################################################################
chmod -R 700 /root
chmod -R 700 /etc/iptables
passwd -l root
###############################################################################################################################################################################################################
user=$(shuf -i 60000-65536 -n 1)
lulz=$(shuf -i 60000-65536 -n 1)
groupadd --gid ${lulz} lulz
useradd --uid ${user} -g lulz -s /bin/bash user;
chown -R user:lulz /home/user;
chmod -R 700 /home/user
passwd -l user

aticonfig --initial

###############################################################################################################################################################################################################
systemctl enable iptables
systemctl enable haveged.service
systemctl enable systemd-networkd.service
systemctl enable dhcpd4
systemctl enable dnscrypt-proxy
systemctl enable combine.service
systemctl enable catalyst-hook
###############################################################################################################################################################################################################
