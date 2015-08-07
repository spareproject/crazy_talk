#!/bin/env bash
###############################################################################################################################################################################################################
if [[ $# != 1 ]];then echo -e "${0} - help\narg0 - rawfs name";fi
###############################################################################################################################################################################################################
if [[ ! -b /dev/mapper/${1} ]];then echo "mapped device doesnt exist";exit;fi
if [[ ! -d /mnt/mount/${1} ]];then echo "mount point doesnt exist";exit;fi
if [[ ! $(mount | grep /mnt/mount/${1}) ]];then echo "mount point doesnt have anything mounted on it";exit;fi
###############################################################################################################################################################################################################
pacstrap -C ./pacman.conf -cGMd /mnt/mount/${1} $(for i in $(cat packages);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv airootfs/* /mnt/mount/${1}
arch-chroot /mnt/mount/${1} /root/install.sh ${dev}
cat /home/user/ssh/id_rsa.pub >> /mnt/mount/${1}/home/user/ssh/authorized_keys
#chroot chown user:lulz ./rootfs/home/user/ssh/authorized_keys
#chmod 700 ./rootfs/home/user/ssh/authorized_keys
###############################################################################################################################################################################################################
