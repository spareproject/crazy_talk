#!/bin/env bash
###############################################################################################################################################################################################################
trap "exit" SIGINT
function usage {
clear;cat /etc/banner
cat << EOF
arg0 - what  you want installed ./airootfs/<name>
arg1 - where you want installed /dev/sdXYZ
EOF
if [[ ${2} ]];then printf "%s\n" "${2}";fi
exit ${1}
}
if [[ $# != 2 ]];then usage 1;fi
###############################################################################################################################################################################################################
clear;cat /etc/banner
mkdir -p ./rootfs
mkdir -p ./mount/
# config directory
if [[ ! -d ./airootfs/${1} ]];then usage 1 "airootfs directory doesnt exist";fi
# all hardcoded files used to build if they dont exist script will fail
if [[ ! -f ./airootfs/${1}/etc/pacman.conf ]];then usage 1 "pacman.conf doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/package_list ]];then useage 1 "airootfs package list doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/arch.conf ]];then usage 1 "arch.conf doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/loader.conf ]];then usage 1 "loader.conf doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/syslinux.cfg ]];then usage 1 "syslinux.cfg doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/install.sh ]];then useage 1 "install.sh doesnt exist";fi
if [[ ! -f ./airootfs/${1}/root/09-gnupg.rules ]];then usage 1 "09-gnupg.rules doesnt exist";fi
# path to /dev/sdXYZ exists and isnt a partition
if [[ ! -b ${2} ]];then echo "${2} doesnt exist...";fi
if [[ ${2: -1} == [0-9] ]];then echo "takes device not partition...";exit;fi
###############################################################################################################################################################################################################
# format the partition used to install on (saves time if re using a usb)
lsblk 
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "about to mkfs.vfat ${2}1 continue (y/n)?" input;done
if [[ ${input} == "n" ]];then usage 1 "learn to fuck up less...";fi
mkfs.vfat -F32 "${2}1"
###############################################################################################################################################################################################################
# pacstrap given packages and copy over all config files
pacstrap -C ./airootfs/${1}/etc/pacman.conf -cGMd ./rootfs $(for i in $(cat ./airootfs/${1}/root/package_list);do if [[ ! $(grep "#" <<< ${i}) ]];then echo -n "${i} " ;fi;done)
cp -arfv airootfs/${1}/* rootfs/
###############################################################################################################################################################################################################
# mounting boot was a pain it kept being ignored, so mount it copy over everything in the boot dir to the usb

read -p "debug start"
echo "mounting ${2}1"
mount ${2}1 ./mount
lsblk
mv ./rootfs/boot/* ./mount/
ls -lash ./mount
read -p "debug end"
umount ./mount/

###############################################################################################################################################################################################################
# execute chrooted install script
arch-chroot ./rootfs /root/install.sh ${2}
###############################################################################################################################################################################################################
# if the default config doesnt have pacman installed (no root cant execute it anyway) then any extra aur / abs built shit can just be dumped here...
# i know freenode bash keeps saying dont use $(ls) but meh
if [[ $(ls ./rootfs/root/packages) != "" ]];then
  for i in $(ls ./rootfs/root/packages);do
    pacman -r ./rootfs -U ./rootfs/root/packages/${i}
  done
fi
###############################################################################################################################################################################################################
# take the given usb and create a udev rule for it symlinks its to /dev/archiso%n
## this parts a bit shit it should be /etc/udev/rules.d but it wont start on boot... requires a systemd service on boot to move it

# cant be done from inside chroot install.sh means every usb needs to symlink itself on boot makes scripting easier...
# but its still a total fuck on because if its in rules.d at boot it symlinks every tty in /dev to /dev/archiso[0-50] or some shit
# not pissed at this at all its the little things that wind me up more....
# does the same thing when the matching rules arent sed properly to actual values...
# but udevadm info /dev/tty has fuck all to match it so 
# i edited this about 7 times full rebuild and reboot and it still fucked up cant debug it easily takes ages : /

idproduct=$(udevadm info ${2} | grep -e ID_MODEL_ID | sed 's/E: ID_MODEL_ID=//')
idvendor=$(udevadm info ${2} | grep -e ID_VENDOR_ID | sed 's/E: ID_VENDOR_ID=//')
iserial=$(udevadm info ${2} | grep -e ID_SERIAL_SHORT | sed 's/E: ID_SERIAL_SHORT=//')
sed -i -e "s/IDVENDOR/${idvendor}/" -e "s/IDPRODUCT/${idproduct}/" -e "s/SERIAL/${iserial}/" ./rootfs/root/09-gnupg.rules
###############################################################################################################################################################################################################
# mount the boot partition and mksquashfs directly onto the usb
mount ${2}1 ./mount
mksquashfs ./rootfs ./mount/rootfs.squashfs
umount ./mount
# some one told me umount syncs and flushes buffers... liez ive ran sync after it and had a minute wait... ive tried remounting it straight after it finishes upto a minute wait
# so i always sync and or mount / umount it anyway pulled it straight out and had read io error writes on boot and bricked usbs
###############################################################################################################################################################################################################
# so quicker dev and testing after build can fuck around with the rootfs all you want just replace the usb squashfs
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "remove rootfs? (y|n)?" input;done
if [[ ${input} == "y" ]];then umount ./rootfs/* 2>/dev/null;rm -r ./rootfs/*;fi
###############################################################################################################################################################################################################
