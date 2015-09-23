#!/bin/env bash
#
# try and pull everything for udev match
# takes /dev/sdX
# assumes /dev/sdXY
# flag unpartitioned
# sdX1 - bootfs vfat -F32
# sdX2 - keyfs ext4
# sdx3 - randomfs ext4
# 
#
if [[ ${1: -1} == [0-9] ]];then echo "takes device not partition";exit;fi

# number of partitions
if [[ -b ${1}1 && -b ${1}2 && -b ${1}3 ]];then

# if /dev/sdX is PART_TABLE_TYPE=gpt

# if /dev/sdX1 is FS_TYPE=fvat

# if /dev/sdx2 is FS_TYPE=ext4

# if /dev/sdx3 is FS_TYPE=ext4

echo ""
echo "usb: "
echo "########################################################################################################################################################################################################"
# /dev/sdX - usb && partition table identifier
#vendor_id,model_id,serial_short,part_table_type,part_table_uuid
for i in 'VENDOR_ID=' 'MODEL_ID=' 'SERIAL_SHORT=' 'PART_TABLE_TYPE=' 'PART_TABLE_UUID=';do
echo -n "${i}";udevadm info ${1}|grep ${i}|awk -F '=' '{print $2}'
done
echo "########################################################################################################################################################################################################"

echo "bootfs: "
echo "########################################################################################################################################################################################################"
# /dev/sdX1 - bootfs
#fs_type,fs_uuid,part_entry_uuid
for i in 'FS_TYPE=' 'FS_UUID=' 'PART_ENTRY_UUID=';do
echo -n "${i}";udevadm info ${1}1|grep ${i}|awk -F '=' '{print $2}'
done
echo "########################################################################################################################################################################################################"

echo "keyfs: "
echo "########################################################################################################################################################################################################"
# /dev/sdx2 - keyfs
#fs_type,fs_uuid,part_entry_uuid
for i in 'FS_TYPE=' 'FS_UUID=' 'PART_ENTRY_UUID=';do
echo -n "${i}";udevadm info ${1}2|grep ${i}|awk -F '=' '{print $2}'
done
echo "########################################################################################################################################################################################################"

echo "randomfs: "
echo "########################################################################################################################################################################################################"
# /dev/sdx3 - randomfs
#fs_type,fs_uuid,part_entry_uuid
for i in 'FS_TYPE=' 'FS_UUID=' 'PART_ENTRY_UUID=';do
echo -n "${i}";udevadm info ${1}3|grep ${i}|awk -F '=' '{print $2}'
done
echo "########################################################################################################################################################################################################"
echo ""

else
echo "
/dev/sdX1 - bootfs vfat -F32 
/dev/sdX2 - keyfs ext4 
/dev/sdx3 - randomfs ext4
"

fi






