#!/bin/env bash

# setup
###############################################################################################################################################################################################################
trap "exit" SIGINT
umask 077
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

#gnupg
###############################################################################################################################################################################################################
mkdir -p ./mount/key/{gnupg,openssh,openssl}
mkdir -p ./mount/key/gnupg/{root,persistent}
cp ./key/gnupg/gpg* ./mount/key/gnupg/root
cp ./key/gnupg/gpg* ./mount/key/gnupg/persistent
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

#openssh
###############################################################################################################################################################################################################
ssh-keygen -t rsa -b 4096 -f "./mount/key/openssh/server_ca" -N ""
ssh-keygen -t rsa -b 4096 -f "./mount/key/openssh/client_ca" -N ""
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssh/server_ca
rm ./mount/key/openssh/server_ca
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssh/client_ca
rm ./mount/key/openssh/client_ca
echo "@cert-authority $(cat ./mount/key/openssh/server_ca.pub) user@host" > ./mount/key/openssh/known_hosts
###############################################################################################################################################################################################################

#openssl
###############################################################################################################################################################################################################
cp ./key/openssl/root.ffs ./mount/key/openssl/root.cnf
cp ./key/openssl/persistent.ffs ./mount/key/openssl/persistent.cnf
mkdir -p /tmp/openssl/certs
touch /tmp/openssl/index.txt
echo 1001 > /tmp/openssl/serial
touch /tmp/openssl/.random
openssl genrsa -out ./mount/key/openssl/root.key 4096
openssl req -config ./key/openssl/root.cnf -key ./mount/key/openssl/root.key -new -x509 -days 365 -sha512 -extensions root -out ./mount/key/openssl/root.cert -subj '/CN=root'
openssl genrsa -out ./mount/key/openssl/persistent.key 4096
openssl req -config ./key/openssl/persistent.cnf -new -sha512 -key ./mount/key/openssl/persistent.key -out ./mount/key/openssl/persistent.csr -subj '/CN=persistent'
openssl ca  -config ./key/openssl/root.cnf -extensions persistent -days 365 -notext -md sha512 -in ./mount/key/openssl/persistent.csr -out ./mount/key/openssl/persistent.cert
cat ./mount/key/openssl/root.cert ./mount/key/openssl/persistent.cert > ./mount/key/openssl/ca-certificates.crt
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssl/root.key
#rm ./mount/key/openssl/root.key
gpg --homedir ./mount/key/gnupg/persistent -e ./mount/key/openssl/persistent.key
#rm ./mount/key/openssl/persistent.key
###############################################################################################################################################################################################################
rm ./mount/key/openssl/persistent.csr
rm -r /tmp/openssl
###############################################################################################################################################################################################################

# permissions
###############################################################################################################################################################################################################
#./mount/gnup         - 750 - root:wheel
# /root               - 700 - root:root
# /persistent         - 750 - root:wheel
# /persistent.public  - 750 - root:wheel
# /persistent.sig     - 750 - root:wheel
# /root.public        - 750 - root:wheel
# /trigger.asc        - 750 - root:wheel
#
chown root:wheel ./mount/key/gnupg
chmod 750 ./mount/key/gnupg
chown -R root:root ./mount/key/gnupg/root
chmod -R 700 ./mount/key/gnupg/root
chown -R root:wheel ./mount/key/gnupg/persistent
chmod -R 750 ./mount/key/gnupg/persistent
chown root:wheel ./mount/key/gnupg/persistent.*
chmod 750 ./mount/key/gnupg/persistent.*
chown root:wheel ./mount/key/gnupg/root.public
chmod 750 ./mount/key/gnupg/root.public
chown root:wheel ./mount/key/gnupg/trigger.asc
chmod 750 ./mount/key/gnupg/trigger.asc
#./mount/openssh      - 700 - root:root
# /client_ca.asc      - 600
# /client_ca.pub      - 600
# /known_host         - 600
# /server_ca.asc      - 600
# /server_ca.pub      - 600
#
chown -R root:root ./mount/key/openssh
chmod -R 700 ./mount/key/openssh
#./mount/openssl      - 700 - root:root
# /ca-certificatates  - 600
# /persistent.cert    - 600
# /persistent.cnf     - 600
# /persistent.key     - 600
# /persistent.key.asc - 600
# /root.cert          - 600
# /root.cnf           - 600
# /root.key           - 600
# /root.key.asc       - 600
#
chown -R root:root ./mount/key/openssl
chmod -R 700 ./mount/key/openssl/
###############################################################################################################################################################################################################

#cleanup
###############################################################################################################################################################################################################
sleep 3
pkill gpg-agent
pkill gpg-agent
umount ./mount/key
umount ./mount/random
###############################################################################################################################################################################################################
