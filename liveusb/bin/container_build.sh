#!/bin/env bash
###############################################################################################################################################################################################################
if [[ $# != 1 ]];then
echo "
${0} - help
arg0 - rawfs name
"
fi
###############################################################################################################################################################################################################

# takes airootfs... host pacman.conf 
# saves into /mount/.rootfs
# 
# 

if [[ ! -b /dev/mapper/${1} ]];then echo "mapped device doesnt exist";exit;fi
if [[ ! -d /mnt/mount/${1} ]];then echo "mount point doesnt exist";exit;fi
if [[ ! $(mount | grep /mnt/mount/${1}) ]];then echo "mount point doesnt have anything mounted on it";exit;fi

# to install and actually setup keys... internal needs to be unlocked
# cant sign keys if /mnt/internal isnt mounted... < - needs to actually contain all the key foo as well

if [[ ! -b /dev/mapper/internal || ! $(mount|grep /mnt/internal) ]];then echo "requires unlocked internal rawfs for key signing";exit;fi
# ^ still blagging this no testing yet

###############################################################################################################################################################################################################

pacstrap -C /etc/pacman.conf -cGMd /mnt/mount/${1} $(for i in $(cat ./airootfs/default/root/package_list);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv ./airootfs/default/* /mnt/mount/${1}
arch-chroot /mnt/mount/${1} /root/install.sh
echo ${1} > /mnt/mount/${1}/etc/hostname
###############################################################################################################################################################################################################



###############################################################################################################################################################################################################

