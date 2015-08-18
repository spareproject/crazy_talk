###############################################################################################################################################################################################################
#!/bin/env bash

so went from working stick i can use aur with to no stick that i can aur with or boot containers with... this is tard logic
i cant do anything because i upgraded the same stick to sucky none working mode...
and im not dropping testing

./checkpoint....

pull pacman -Q for build and timestamp it into /mnt/storage/liveusb/checkpoint?
remember to mark it as working or dump notes into that section....
^ probably a decent system for dumping changes / notes 

^^ doesnt really work if i produce a liveusb that fails to rebuild itself
either scripts to dd one /dev/sdX2 keys partition onto another usb
so i can have old squashfs rootfs versions that have the same key set...
or double dump the old squashfs onto keys...
^ loads of read writes 


#minimum

pacman -r ./rootfs -Q > ../build_notes/ $(pwd for the dir build.sh was run in ).$(timestamp)
../should be the liveusb folder...



###############################################################################################################################################################################################################
