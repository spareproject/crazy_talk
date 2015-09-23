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
group=$(shuf -i 1000-60000 -n 1)
groupadd --gid ${group} group
useradd --uid ${user} -g group -s /bin/bash user

gpg --homedir /home/user/gnupg/persistent --passphrase-fd 0 --gen-key --batch /etc/gnupg/batch.user <<< "" 2>/dev/null
gpg --homedir /home/user/gnupg/persistent --output /home/user/gnupg/user.public --export persistent  2>/dev/null

ssh-keygen -t rsa -b 4096 -f "/home/user/openssh/ssh/id_rsa" -N "" 2>/dev/null
ssh-keygen -t rsa -b 4096 -f "/home/user/openssh/sshd/ssh_host_rsa_key" -N "" 2>/dev/null

gpg --homedir /home/user/gnupg/persistent -e /home/user/openssh/ssh/id_rsa 2>/dev/null;
#rm /home/user/openssh/ssh/id_rsa
gpg --homedir /home/user/gnupg/persistent -e /home/user/openssh/sshd/ssh_host_rsa_key 2>/dev/null;
#rm /home/user/openssh/sshd/ssh_host_rsa_key

chown -R user:group /home/user;
chmod -R 700 /home/user
passwd -l user
rm /etc/securetty
rm -r /boot
###############################################################################################################################################################################################################
systemctl enable iptables.service
systemctl enable systemd-networkd.service
systemctl enable sshd@user.service
systemctl enable ffs.service
###############################################################################################################################################################################################################
