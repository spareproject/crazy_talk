#!/bin/env bash
#############################################################################################################################################################################################################
. ./session
input
session
header
#############################################################################################################################################################################################################
if [[ -b /dev/archiso  ]];then echo "<h4><b>PLUGGED </b></h4>";fi
if [[ -f /tmp/unlocked ]];then echo "<h4><b>UNLOCKED</b></h4>";fi
echo "<fieldset><legend><h3><b>internal</b></h3></legend>"
echo "<table>"
for i in $(ls /mnt/rawfs);do
echo "<tr>"
echo "<td>${i}</td>"
echo "<td>";if [[ -f /mnt/luks/${i} ]];then echo "key";else echo "<strike>key</strike>";fi;echo "</td>"
echo "<td>";if [[ -b /dev/mapper/${i} ]];then echo "mapped";else echo "<strike>mapped</strike>";fi;echo "</td>"
echo "<td>";if [[ $(mount | grep "/mnt/mount/${i} ") ]];then echo "mounted";else echo "<strike>mounted</strike>";fi
echo "<td>";if [[ $(machinectl | grep "^${i}") ]];then echo "running";else echo "<strike>running</strike>";fi
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='map' value='map'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='boot' value='boot'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='close' value='close'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='delete' value='delete'></form></td>"
echo "</tr>"
done
echo "</table>"
echo "</fieldset>"
###############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>unionfs</b></h3></legend>"
echo "<form action='/index.cgi' method='post'>"
echo "<table><tr>"
echo "<td><select name=underlay>"
for i in $(ls /mnt/mount/);do if [[ $(mount | grep "/mnt/mount/${i} ") ]];then echo "<option value=${i}>${i}</option>";fi;done
echo "</select></td>"
echo "<td><select name=overlay>"
for i in $(ls /mnt/mount/);do if [[ $(mount | grep "/mnt/mount/${i} ") ]];then echo "<option value=${i}>${i}</option>";fi;done
echo "</select></td>"
echo "<td><input type='submit' name='unionfs' value='mount_unionfs'></td>"
echo "</tr></table>"
echo "</form>"
###############################################################################################################################################################################################################
echo "<table>"
for i in $(mount | grep unionfs | awk '{print $3}');do
echo "<tr>"
echo "<td>${i#/mnt/mount/}</td>"
echo "<td>mounted</td>"
echo "<td>";if [[ $(machinectl | grep "^${i#/mnt/mount/} ") ]];then echo "running";else echo "<strike>running</strike>";fi;echo "</td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='close' value='close'></form></td>"
echo "</tr>"
done
echo "</table>"
echo "</fieldset>"
###############################################################################################################################################################################################################
echo "
<fieldset><legend><h3><b>Conky</b></h3></legend>
<p>Conky has easy mode output for alot of decent information</p>
<p>needs to also show stats of tracked services from boot...</p>
<p></p>
<p></p>
<p></p>
</fieldset>
"
###############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>Create</b></h3></legend>"
echo "
<form action=/index.cgi method=post><table><tr><td><input type=text name=name value=name></td><td><input type=text name=size value=size></td><td><input type=submit name=create value=create></td></tr></table></form>"
echo "</fieldset>"
###############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>install</b></h3></legend>"
echo "
<form action='/index.cgi' method='post'>
<table><tr><td><select name=install>
"
for i in $(ls /mnt/storage/container/airootfs/);do
echo "<option value=${i}>${i}</option>"
done
echo "</select></td>"

echo "<td><select>"
for i in $(ls /mnt/mount/);do if [[ $(mount | grep "/mnt/mount/${i} ") ]];then echo "<option value=${i}>${i}</option>";fi;done
echo "</select></td>"
echo "<td><input type=submit value=install>"
echo "</tr></table></form></fieldset>"
#############################################################################################################################################################################################################
footer
#############################################################################################################################################################################################################
