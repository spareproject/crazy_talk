#!/bin/env bash
#
# takes rw top layer first
# loops through all input after and mounts from right to left ro:ro till last layer
# picks mount as the mounting directory auto created dir names based on luks name combines...
# check the dir isnt already mounted at some point as rw... ro only multiple mounts 
# probably the only script that requires some form of thought / logic to create the rest are ez mode
#
if [[ ${1} && ${2} && ${3} ]];then
unionfs -o allow_other,use_ino,suid,dev,nonempty -o cow ${1}=RW:${2}=RO ${3}
else
echo "
takes...
1 - read write overlay
2 - read only  underlay
3 - mount point
"
fi
