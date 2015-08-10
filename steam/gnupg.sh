#!/bin/env bash
###############################################################################################################################################################################################################
OLD=$(stat -c %U $(tty))
chown ${USER}:tty $(tty)
umask 077
###############################################################################################################################################################################################################
if [[ ! -b ${1} ]];then echo "${1} doesnt exist...";fi
if [[ ${1: -1} == [0-9] ]];then echo "takes device not partition fucked up this way more than once...";exit;fi
lsblk
unset finish;while [[ ${finish} != @("y"|"n") ]];do read -r -p "about to mkfs.ext4 ${1}2  continue (y/n)? " finish;done
if [[ ${finish} == "n" ]];then clear;cat /etc/banner;echo "i always say putting prompts like this does nothing but encourage bad behaviour learn to fuck up less...";fi
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
###############################################################################################################################################################################################################
mkfs.ext4 ${keys}
mount ${keys} ./mount
###############################################################################################################################################################################################################
function get_range { echo $(($(cat /proc/partition | grep ${random} | awk '{print $3}')-100)); }
mkdir -p ./mount/root
mkdir -p ./mount/user
mkdir -p ./mount/sshd
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

ssh-keygen -t rsa -b 4096 -f "./mount/sshd/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "./mount/sshd/client_ca" -N ""
gpg --homedir ./mount/user -e ./mount/sshd/server_ca;rm ./mount/sshd/server_ca
gpg --homedir ./mount/user -e ./mount/sshd/client_ca;rm ./mount/sshd/client_ca
echo "@cert-authority $(cat ./mount/sshd/server_ca.pub) user@crazy_talk" > ./mount/sshd/known_hosts

gpg --homedir ./mount/user -e <<< "mounted gnupg && cached passphrase" > ./mount/trigger.asc
pkill gpg-agent
###############################################################################################################################################################################################################
chown ${OLD}:tty $(tty)
###############################################################################################################################################################################################################

