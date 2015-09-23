#!/bin/env bash
###############################################################################################################################################################################################################
trap "exit" SIGINT
###############################################################################################################################################################################################################
function usage {
echo "
${0} - help
arg0 - usbstick /dev/sdXYZ
arg1 - airootfs config
${2}
"
exit ${1}
}
if [[ $# != 2 ]];then usage 1;fi
###############################################################################################################################################################################################################
mkdir -p ./rootfs
mkdir -p ./mount
###############################################################################################################################################################################################################
# if usb exists and is formatted correctly
if [[ ! -b ${1} ]];then usage 1 "device doesnt exist";fi
if [[ ${1: -1} == [0-9] ]];then usage 1 "takes device not partition";fi
if [[ ! -b ${1}1 || ! -b ${1}2 || ! -b ${1}3 ]];then  usage 1 "incorect partition scheme on device...";fi
# config files that build depends on
if [[ ! -d ./config/${2} ]];then                      usage 1 "airootfs directory doesnt exist";fi
if [[ ! -f ./config/${2}/root/install.sh ]];then      usage 1 "install.sh doesnt exist";fi
if [[ ! -f ./config/${2}/root/package_list ]];then    usage 1 "airootfs package list doesnt exist";fi
if [[ ! -f ./config/${2}/etc/pacman.conf ]];then      usage 1 "pacman.conf doesnt exist";fi
if [[ ! -f ./config/${2}/root/arch.conf ]];then       usage 1 "arch.conf doesnt exist";fi
if [[ ! -f ./config/${2}/root/loader.conf ]];then     usage 1 "loader.conf doesnt exist";fi
if [[ ! -f ./config/${2}/root/syslinux.cfg ]];then    usage 1 "syslinux.cfg doesnt exist";fi
if [[ ! -f ./config/${2}/root/09-gnupg.rules ]];then  usage 1 "09-gnupg.rules doesnt exist";fi
# clean rootfs for a fresh install
if [[ ! -z $(ls rootfs/) ]];then umount ./rootfs/* 2>/dev/null;rm -r ./rootfs/*;fi
###############################################################################################################################################################################################################
lsblk 
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "about to mkfs.vfat ${1}1 continue (y|n)?" input;done
if [[ ${input} == "n" ]];then usage 1 "learn to fuck up less...";fi
###############################################################################################################################################################################################################
mkfs.vfat -F32 "${1}1"
###############################################################################################################################################################################################################
pacstrap -C ./config/${2}/etc/pacman.conf -cGMd ./rootfs $(for i in $(cat ./config/${2}/root/package_list);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv config/${2}/* rootfs/
###############################################################################################################################################################################################################
mount ${1}1 ./mount
mv ./rootfs/boot/* ./mount/
umount ./mount/
###############################################################################################################################################################################################################
arch-chroot ./rootfs /root/install.sh ${1}
###############################################################################################################################################################################################################
idproduct=$(udevadm info ${1} | grep -e ID_MODEL_ID | sed 's/E: ID_MODEL_ID=//')
idvendor=$(udevadm info ${1} | grep -e ID_VENDOR_ID | sed 's/E: ID_VENDOR_ID=//')
iserial=$(udevadm info ${1} | grep -e ID_SERIAL_SHORT | sed 's/E: ID_SERIAL_SHORT=//')
sed -i -e "s/IDVENDOR/${idvendor}/" -e "s/IDPRODUCT/${idproduct}/" -e "s/SERIAL/${iserial}/" ./rootfs/root/09-gnupg.rules
###############################################################################################################################################################################################################

unset input;while [[ ${input} != @("y"|"n") ]];do read -rp "suppose to be mounting ${1}1 (y|n)" input;done
mount ${1}1 ./mount

unset input;while [[ ${input} != @("y"|"n") ]];do read -rp "check ./mount its been making corrupted squashfs (y|n)" input;done

mksquashfs ./rootfs ./mount/rootfs.squashfs
sync
umount ./mount

###############################################################################################################################################################################################################
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "remove rootfs? (y|n)?" input;done
if [[ ${input} == "y" ]];then umount ./rootfs/* 2>/dev/null;rm -r ./rootfs/*;fi
###############################################################################################################################################################################################################
