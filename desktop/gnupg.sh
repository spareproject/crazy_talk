#!/bin/env bash
###############################################################################################################################################################################################################
dev=${1}
boot=${dev}1
keys=${dev}2
random=${dev}3
umask 077
###############################################################################################################################################################################################################
if [[ ! -b ${dev} ]];then echo "${dev} doesnt exist...";fi
if [[ ${dev: -1} == [0-9] ]];then echo "takes device not partition fucked up this way more than once...";exit;fi
lsblk;unset input
while [[ ${input} != @("y"|"n") ]];do read -r -p "about to mkfs.ext4 ${keys} continue (y/n)? " input;done
if [[ ${input} == "n" ]];then clear;cat /etc/banner;echo "learn to fuck up less...";exit;fi
###############################################################################################################################################################################################################
mkfs.ext4 ${keys}
mount ${keys} ./mount
mkdir ./mount/random
mount ${random} ./mount/random
###############################################################################################################################################################################################################
function get_range { echo $(($(cat /proc/partition | grep ${random} | awk '{print $3}')-100)); }
mkdir -p ./mount/root
mkdir -p ./mount/user
mkdir -p ./mount/sshd
cp ./airootfs/etc/gnupg/gpg* ./mount/root
cp ./airootfs/etc/gnupg/gpg* ./mount/user

read -p "enter root pin: " root
hexdump -C <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/root --passphrase-fd 0 --batch --gen-key ./airootfs/etc/gnupg/batch.root <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/root --output ./mount/root.public --export root

read -p "enter user pin: " user
hexdump -C <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)
gpg --homedir ./mount/user --passphrase-fd 0 --batch --gen-key ./airootfs/etc/gnupg/batch.user <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)
gpg --homedir ./mount/user --output ./mount/user.public --export user
gpg --homedir ./mount/user --import ./mount/root.public
gpg --homedir ./mount/user --passphrase-fd 0 --sign-key root <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${user} 2>/dev/null)

gpg --homedir ./mount/root/ --passphrase-fd 0 --output ./mount/user.sig --sign ./mount/user.public <<< $(dd if=./mount/random/raw bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)

ssh-keygen -t rsa -b 4096 -f "./mount/sshd/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "./mount/sshd/client_ca" -N ""
gpg --homedir ./mount/user -e ./mount/sshd/server_ca;rm ./mount/sshd/server_ca
gpg --homedir ./mount/user -e ./mount/sshd/client_ca;rm ./mount/sshd/client_ca
echo "@cert-authority $(cat ./mount/sshd/server_ca.pub) user@crazy_talk" > ./mount/sshd/known_hosts

gpg --homedir ./mount/user -e <<< "mounted gnupg && cached passphrase" > ./mount/trigger.asc
pkill gpg-agent

# dekstop user:group 1000:1000, steam user:group 1000:1000, minimal user:group random:random so.... but minimal is root because
chown -R user:group ./mount/sshd
chown -R user:group ./mount/user
chown user:group ./mount/root.public
chown user:group ./mount/trigger.asc
chown user:group ./mount/user.public
chown user:group ./mount/user.sig
umount ./mount/random
rmdir ./mount/random
umount ./mount
###############################################################################################################################################################################################################
# not disk destroying 5G every pop but thats all it took to get random raw rather than random partition and it needs to be done first so....
#mkfs.ext4 /dev/archiso3
#mount /dev/archiso3 ./mount
#dd if=/dev/random if=./mount/raw bs=1024 count=5000000
###############################################################################################################################################################################################################
