#!/bin/env bash
###############################################################################################################################################################################################################
trap "exit" SIGINT
###############################################################################################################################################################################################################
function usage { echo -e "${0} - help\narg0 - usbstick /dev/sdXYZ\n${2}";exit ${1}; }
if [[ $# != 1 ]];then usage 1;fi
###############################################################################################################################################################################################################
mkdir -p ./mount/
###############################################################################################################################################################################################################
if [[ ! -b ${1} ]];then usage 1 "device doesnt exist";fi
if [[ ${1: -1} == [0-9] ]];then usage 1 "takes device not partition";fi
if [[ ! -b ${1}1 || ! -b ${1}2 || ! -b ${1}3 ]];then usage 1 "incorect partition scheme on device...";fi
###############################################################################################################################################################################################################
lsblk
unset input;while [[ ${input} != @("y"|"n") ]];do read -r -p "about to mkfs.ext4 ${1}3 continue (y/n)? " input;done
if [[ ${input} == "n" ]];then usage 1 "learn to fuck up less...";fi
###############################################################################################################################################################################################################
mkfs.ext4 ${1}3
mount ${1}3 ./mount
###############################################################################################################################################################################################################
dd if=/dev/random of=./mount/randomfs bs=1024 status=progress
###############################################################################################################################################################################################################
chmod 444 ./mount/randomfs
###############################################################################################################################################################################################################
