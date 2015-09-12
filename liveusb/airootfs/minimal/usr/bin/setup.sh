#!/bin/env bash
###############################################################################################################################################################################################################
umask 077
###############################################################################################################################################################################################################
# oneshot isnt loaded && usb exists 
if [[ $(ps aux|grep gpg-agent|grep /home/user/gnupg/persistent) || $(ls /home/user/gnupg/persistent) != "" || ! -b /dev/archiso1 || ! -b /dev/archiso2 || ! -b /dev/archiso3 ]];then exit;fi
# if container directory for given usb already exists...
if [[ -f /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).rawfs || -f /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).luks ]];then echo "container rawfs already exists";exit;fi
###############################################################################################################################################################################################################
mount /dev/archiso2
mount /dev/archiso3
cp -ar /home/user/.mount/key/gnupg/persistent/* /home/user/gnupg/persistent
unset input;read -rp "enter pin: " input
if [[ ${input} =~ ^0-9+$ ]];then echo "numberic pin";exit;fi
if gpg --homedir /home/user/gnupg/persistent --passphrase-fd 0 -d /home/user/.mount/key/gnupg/trigger.asc <<< $(dd if=/home/user/.mount/random/randomfs bs=1 count=100 ibs=1 skip=${input} 2>/dev/null);then
###############################################################################################################################################################################################################
dd if=/dev/random bs=1 count=8192 | gpg --homedir /home/user/gnupg/persistent -o /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).luks -e
fallocate -l 1G /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).rawfs
gpg --homedir /home/user/gnupg/persistent -d /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).luks 2>/dev/null|
cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --key-file - --type=plain --offset 0 open /mnt/$(blkid /dev/archiso2 -s PARTUUID -o value).rawfs container 
mkfs.ext4 /dev/mapper/container
mkdir -p /mnt/container
mount /dev/mapper/container /mnt/container
###############################################################################################################################################################################################################

#gnupg
###############################################################################################################################################################################################################

mkdir -p /mnt/container/gnupg/{root,persistent,revoke}
for i in root persistent revoke;do cp -ar /etc/key/gnupg/gpg* /mnt/container/gnupg/${i};done

# root key
gpg --homedir /mnt/container/gnupg/root --passphrase-fd 0 --gen-key --batch /etc/key/gnupg/batch.root <<< ""
gpg --homedir /mnt/container/gnupg/root --output /mnt/container/gnupg/root.public --export root

# revoke key
gpg --homedir /mnt/container/gnupg/revoke --passphrase-fd 0 --gen-key --batch /etc/key/gnupg/batch.revoke <<< ""
gpg --homedir /mnt/container/gnupg/revoke --output /mnt/container/gnupg/revoke.public --export revoke

# persistent key
gpg --homedir /mnt/container/gnupg/persistent --passphrase-fd 0 --gen-key --batch /etc/key/gnupg/batch.persistent <<< ""
gpg --homedir /mnt/container/gnupg/persistent --output /mnt/container/gnupg/persistent.public --export persistent

# root sign
gpg --homedir /mnt/container/gnupg/root --passphrase-fd 0 --output /mnt/container/gnupg/persistent.sig --sign /mnt/container/gnupg/persistent.public <<< ""

# import to persistent keyring
gpg --homedir /mnt/container/gnupg/persistent --import /mnt/container/gnupg/root.public
gpg --homedir /mnt/container/gnupg/persistent --import /mnt/container/gnupg/revoke.public
gpg --homedir /mnt/container/gnupg/persistent --sign-key root <<< ""
gpg --homedir /mnt/container/gnupg/persistent --sign-key revoke <<< ""

# persistent trigger
gpg --homedir /mnt/container/gnupg/persistent -o /mnt/container/gnupg/trigger.asc -e <<< "mounted && cached persitstent keyring"

# cleanup
pkill gpg-agent
###############################################################################################################################################################################################################

#openssh
###############################################################################################################################################################################################################

mkdir -p /mnt/container/openssh

ssh-keygen -t rsa -b 4096 -f "/mnt/container/openssh/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "/mnt/container/openssh/client_ca" -N ""

echo "@cert-authority $(cat /mnt/container/openssh/server_ca.pub) user@container" > /mnt/container/openssh/known_hosts

###############################################################################################################################################################################################################

#openssl
###############################################################################################################################################################################################################

mkdir -p /mnt/container/openssl

mkdir -p    /mnt/container/openssl/certs
touch       /mnt/container/openssl/index.txt
echo 1001 > /mnt/container/openssl/serial
touch       /mnt/container/openssl/.random

# root
openssl genrsa -out /mnt/container/openssl/root.key 4096
openssl req -config /etc/key/openssl/root.cnf -key /mnt/container/openssl/root.key -new -x509 -days 365 -sha512 -extensions root -out /mnt/container/openssl/root.cert -subj '/CN=root'

# persistent
openssl genrsa -out /mnt/container/openssl/persistent.key 4096
openssl req -config /etc/key/openssl/persistent.cnf -new -sha512 -key /mnt/container/openssl/persistent.key -out /mnt/container/openssl/persistent.csr -subj '/CN=persistent'
openssl ca  -config /etc/key/openssl/root.cnf -extensions persistent -days 365 -notext -md sha512 -in /mnt/container/openssl/persistent.csr -out /mnt/container/openssl/persistent.cert

# one ca cert to rule them all
cat /mnt/container/openssl/root.cert /mnt/container/openssl/persistent.cert > /mnt/container/openssl/ca-certificates.crt

# cleanup
rm /mnt/container/openssl/persistent.csr
rm -r /mnt/container/openssl/certs
rm /mnt/container/openssl/index*
rm /mnt/container/openssl/serial*
rm /mnt/container/openssl/.random

###############################################################################################################################################################################################################

sync
umount /dev/archiso2
umount /dev/archiso3
rm -r /home/user/gnupg/persistent/*

###############################################################################################################################################################################################################
else
  pkill gpg-agent
  rm -r /home/user/gnupg/persistent/*
  umount /dev/archiso2
  umount /dev/archiso3
  echo "Y U NO ENTER CORRECT PIN!"
fi
###############################################################################################################################################################################################################
