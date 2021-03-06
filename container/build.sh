#!/bin/env bash
###############################################################################################################################################################################################################
if [[ $# != 1 ]];then
echo "
${0} - help
arg0 - rawfs name
"
fi
###############################################################################################################################################################################################################
if [[ ! -b /dev/mapper/${1} ]];then echo "mapped device doesnt exist";exit;fi
if [[ ! -d /mnt/mount/${1} ]];then echo "mount point doesnt exist";exit;fi
if [[ ! $(mount | grep /mnt/mount/${1}) ]];then echo "mount point doesnt have anything mounted on it";exit;fi

if [[ ! -b /dev/mapper/internal || ! $(mount|grep /mnt/internal) ]];then echo "requires unlocked internal rawfs for key signing";exit;fi

###############################################################################################################################################################################################################
pacstrap -C /etc/pacman.conf -cGMd /mnt/mount/${1} $(for i in $(cat ./airootfs/default/root/package_list);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv ./airootfs/default/* /mnt/mount/${1}
arch-chroot /mnt/mount/${1} /root/install.sh
echo ${1} > /mnt/mount/${1}/etc/hostname
###############################################################################################################################################################################################################

###############################################################################################################################################################################################################
