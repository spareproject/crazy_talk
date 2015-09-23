#!/bin/env bash

pacman-key --init
pacman-key --populate archlinux
curl -o /etc/pacman.d/mirrorlist 'https://www.archlinux.org/mirrorlist/?country=all&protocol=https&use_mirror_status=on'
sed -i 's/#Server/Server/g' /etc/pacman.d/mirrorlist
pacman -Sy
if [[ -d /mnt/storage/pkg && ! $(mount|grep '/var/cache/pacman/pkg') ]];then mount --bind /mnt/storage/pkg /var/cache/pacman/pkg;fi
