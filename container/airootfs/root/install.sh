#!/bin/env bash
###############################################################################################################################################################################################################
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
if [[ -f /usr/bin/pinentry ]];then rm /usr/bin/pinentry;ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;else ln -s /usr/bin/pinentry-curses /usr/bin/pinentry;fi
###############################################################################################################################################################################################################
chmod -R 700 /root
chmod -R 700 /etc/iptables
passwd -l root
###############################################################################################################################################################################################################
user=$(shuf -i 1000-60000 -n 1)
lulz=$(shuf -i 1000-60000 -n 1)
groupadd --gid ${lulz} lulz
useradd -m --uid ${user} -g lulz -s /bin/bash user;
ssh-keygen -t rsa -b 4096 -f "/home/user/sshd/ssh_host_rsa_key" -N ""
ssh-keygen -t rsa -b 4096 -f "/home/user/ssh/id_rsa" -N ""
chown -R user:lulz /home/user;
chmod -R 700 /home/user
passwd -l user
rm /etc/securetty
###############################################################################################################################################################################################################
systemctl enable systemd-networkd.service
systemctl enable iptables.service
systemctl enable sshd@user.service
systemctl enable ffs.service
###############################################################################################################################################################################################################
