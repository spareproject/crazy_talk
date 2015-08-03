#!/bin/env bash
###############################################################################################################################################################################################################
OLD=$(stat -c %U $(tty))
chown ${USER}:tty $(tty)
umask 077
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
mount ${keys} ./mount
###############################################################################################################################################################################################################
function get_range { echo $(($(cat /proc/partition | grep ${random} | awk '{print $3}')-100)); }
mkdir -p ./mount/root
mkdir -p ./mount/user
cp ./airootfs/etc/gnupg/gpg* ./mount/root
cp ./airootfs/etc/gnupg/gpg* ./mount/user

read -p "enter root pin: " root
hexdump -C <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/root --passphrase-fd 0 --batch --gen-key ./airootfs/etc/gnupg/batch.root <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/root --output ./mount/root.public --export root

read -p "enter user pin: " user
hexdump -C <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)
gpg --homedir ./mount/user --passphrase-fd 0 --batch --gen-key ./airootfs/etc/gnupg/batch.user <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)
gpg --homedir ./mount/user --output ./mount/user.public --export user
gpg --homedir ./mount/user --import ./mount/root.public
gpg --homedir ./mount/user --passphrase-fd 0 --sign-key root <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)

gpg --homedir ./mount/root/ --passphrase-fd 0 --output ./mount/user.sig --sign ./mount/user.public <<< $(dd if=${random} bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)

ssh-keygen -t rsa -b 4096 -f "./mount/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "./mount/client_ca" -N ""
gpg --homedir ./mount/user -e ./mount/server_ca;rm ./mount/server_ca
gpg --homedir ./mount/user -e ./mount/client_ca;rm ./mount/client_ca
echo "@cert-authority $(cat ./mount/server_ca.pub) user@crazy_talk" > ./mount/known_hosts

pkill gpg-agent
###############################################################################################################################################################################################################
chown ${OLD}:tty $(tty)
###############################################################################################################################################################################################################

