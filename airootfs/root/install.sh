#!/bin/env bash
###############################################################################################################################################################################################################
# boot loader
mount ${1} /boot
sgdisk $(sed 's/.$//' <<< ${1}) --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$(sed 's/.$//' <<< ${1})
mkdir /boot/syslinux
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" /root/syslinux.cfg > /boot/syslinux/syslinux.cfg
syslinux-install_update -i
bootctl --path /boot install
sed "s/CHANGEMEH/$(blkid ${1} -s PARTUUID -o value)/" /root/arch.conf    > /boot/loader/entries/arch.conf
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
USER=$(shuf -i 60000-65536 -n 1);LULZ=${USER}
while [[ ${LULZ} == ${USER} ]];do LULZ=$(shuf -i 60000-65536 -n 1);done
groupadd --gid ${LULZ} lulz
useradd --uid ${USER} -g lulz -s /bin/bash user;
chown -R user:lulz /home/user;
chmod -R 700 /home/user
passwd -l user
###############################################################################################################################################################################################################
systemctl enable iptables
systemctl enable haveged.service
systemctl enable systemd-networkd.service
systemctl enable dhcpd4
systemctl enable dnscrypt-proxy
systemctl enable combine.service
###############################################################################################################################################################################################################
