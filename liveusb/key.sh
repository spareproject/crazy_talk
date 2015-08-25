#!/bin/env bash
###############################################################################################################################################################################################################
trap "exit" SIGINT
###############################################################################################################################################################################################################
function usage { echo -e "${0} - help\narg0 - usbstick /dev/sdXYZ\n${2}";exit ${1}; }
if [[ $# != 1 ]];then usage 1;fi
###############################################################################################################################################################################################################
mkdir -p ./mount/key
mkdir -p ./mount/random
###############################################################################################################################################################################################################
if [[ ! -b ${1} ]];then usage 1 "device doesnt exist";fi
if [[ ${1: -1} == [0-9] ]];then usage 1 "takes device not partition";fi
if [[ ! -b ${1}1 || ! -b ${1}2 || ! -b ${1}3 ]];then usage 1 "incorect partition scheme on device";fi
###############################################################################################################################################################################################################
lsblk
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "about to mkfs.ext4 ${1}2 continue (y/n)? " input;done
if [[ ${input} == "n" ]];then usage 1 "learn to fuck up less...";fi
###############################################################################################################################################################################################################
mkfs.ext4 ${1}2
mount ${1}2 ./mount/key
mount ${1}3 ./mount/random
###############################################################################################################################################################################################################
mkdir -p ./mount/key/{gnupg,openssh,openssl}
mkdir -p ./mount/key/gnupg/{root,persistent}
cp ./key/gnupg/gpg* ./mount/key/gnupg/root
cp ./key/gnupg/gpg* ./mount/key/gnupg/persistent
###############################################################################################################################################################################################################
read -p "enter root pin: " root
hexdump -C <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/root --passphrase-fd 0 --gen-key --batch ./key/gnupg/batch.root <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/root --output ./mount/key/gnupg/root.public --export root
read -p "enter persistent pin: " persistent
hexdump -C <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${persistent} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/persistent --passphrase-fd 0 --gen-key --batch ./key/gnupg/batch.persistent <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${persistent} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/persistent --output ./mount/key/gnupg/persistent.public --export persistent
gpg --homedir ./mount/key/gnupg/persistent --import ./mount/key/gnupg/root.public
gpg --homedir ./mount/key/gnupg/persistent --passphrase-fd 0 --sign-key root <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${persistent} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/root/ --passphrase-fd 0 --output ./mount/key/gnupg/persistent.sig --sign ./mount/key/gnupg/persistent.public <<< $(dd if=./mount/random/randomfs bs=1 count=100 ibs=1 skip=${root} 2>/dev/null)
gpg --homedir ./mount/key/gnupg/persistent -e <<< "mounted gnupg && cached passphrase" > ./mount/key/gnupg/trigger.asc
###############################################################################################################################################################################################################
ssh-keygen -t rsa -b 4096 -f "./mount/key/openssh/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "./mount/key/openssh/client_ca" -N ""
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssh/server_ca;rm ./mount/key/openssh/server_ca
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssh/client_ca;rm ./mount/key/openssh/client_ca
echo "@cert-authority $(cat ./mount/key/openssh/server_ca.pub) user@crazy_talk" > ./mount/key/openssh/known_hosts

pkill gpg-agent
pkill gpg-agent
sleep 1
pkill gpg-agent
pkill gpg-agent
###############################################################################################################################################################################################################

###############################################################################################################################################################################################################
mkdir -p /tmp/openssl/certs
touch /tmp/openssl/index.txt
echo 1001 > /tmp/openssl/serial
touch /tmp/openssl/.random
###############################################################################################################################################################################################################
cp ./key/openssl/root.ffs ./mount/key/openssl/root.cnf
cp ./key/openssl/persistent.ffs ./mount/key/openssl/persistent.cnf
###############################################################################################################################################################################################################
openssl genrsa -out ./mount/key/openssl/root.key 4096
openssl req -config ./key/openssl/root.cnf -key ./mount/key/openssl/root.key -new -x509 -days 365 -sha512 -extensions root -out ./mount/key/openssl/root.cert -subj '/CN=root'
###############################################################################################################################################################################################################
#PERSISTENT_KEY
openssl genrsa -out ./mount/key/openssl/persistent.key 4096
openssl req -config ./key/openssl/persistent.cnf -new -sha512 -key ./mount/key/openssl/persistent.key -out ./mount/key/openssl/persistent.csr -subj '/CN=persistent'
openssl ca  -config ./key/openssl/root.cnf -extensions persistent -days 365 -notext -md sha512 -in ./mount/key/openssl/persistent.csr -out ./mount/key/openssl/persistent.cert
###############################################################################################################################################################################################################
cat ./mount/key/openssl/root.cert ./mount/key/openssl/persistent.cert > ./mount/key/openssl/ca-certificates.crt
###############################################################################################################################################################################################################
# so again with openssl being shit i cant decrypt and pipe the keys means they need to exist on filesystem somewhere... or filedescriptor foo and pipe both in?
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssl/root.key
#rm ./mount/key/openssl/root.key
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssl/persistent.key
#rm ./mount/key/openssl/persistent.key
###############################################################################################################################################################################################################
rm ./mount/key/openssl/persistent.csr
rm -r /tmp/openssl
###############################################################################################################################################################################################################
sleep 3
umount ./mount/key
umount ./mount/random
###############################################################################################################################################################################################################
