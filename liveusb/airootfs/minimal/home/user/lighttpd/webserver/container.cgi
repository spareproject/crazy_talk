#!/bin/env bash
#############################################################################################################################################################################################################
. ./session.sh
input
session
header

#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>debug</b></h3></legend>"

if [[ -b /dev/archiso ]];then
  echo "plugged<br>"
else
  echo "unplugged<br>"
fi

if [[ $(pgrep gpg-agent) ]];then 
  echo "gpg-agent exists<br>"
else
  echo "gpg-agent dead<br>"
fi

if [[ $(ls /home/user/persistent) == "" ]];then
  echo "persistent is empty"
else
  echo "persistent loaded and cached"
fi

if [[ ! ${#post[@]} -eq 0 ]];then echo -n "post: ";for i in ${!post[@]};do echo "[${i}:${post[${i}]}]";done;fi;echo '<br>'
if [[ ${post[action]} == "oneshot" ]];then echo stub;fi
if [[ ${post[action]} == "create" ]];then echo stub;fi
if [[ ${post[action]} == "map" ]];then echo stub;fi
if [[ ${post[action]} == "unionfs" ]];then echo stub;fi
if [[ ${post[action]} == "boot" ]];then echo stub;fi
if [[ ${post[action]} == "close" ]];then echo stub;fi
if [[ ${post[action]} == "delete" ]];then echo stub;fi
if [[ ${post[action]} == "install" ]];then echo stub;fi
if [[ ${post[action]} == "killall" ]];then echo stub;fi
echo "</fieldset>"
#############################################################################################################################################################################################################
echo "
<fieldset><legend><h3><b>oneshot</b></h3></legend>
<form action=./container.cgi method=post>
<input type=text name=pin>
<input type=submit name=submit value=oneshot>
<input type=hidden name=action value=oneshot>
</form>
</fieldset>
"
#############################################################################################################################################################################################################
echo "
<fieldset><legend><h3><b>create</b></h3></legend>
<form action=/container.cgi method=post>
<table><tr>
<td><input type=text name=name value=name></td>
<td><input type=text name=size value=size></td>
<td><input type=submit name=submit value=create></td>
</tr></table>
<input type=hidden name=action value=create>
</form>
</fieldset>
"
###############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>internal</b></h3></legend><table><tr>"

for i in $(ls /mnt/rawfs);do

echo "<form action='/container.cgi' method='post'><td>${i}</td>"

if [[ -f /mnt/luks/${i} ]];then
  echo "<td>key</td>"
else
  echo "<td><strike>key</strike></td>"
fi

if [[ -b /dev/mapper/${i} ]];then
  echo "<td>mapped</td>"
else
  echo "<td><strike>mapped</strike></td>"
fi

if [[ $(mount | grep "/mnt/mount/${i} ") ]];then
  echo "<td>mounted</td>"
else
  echo "<td><strike>mounted</strike></td>"
fi

if [[ $(machinectl | grep "^${i}") ]];then
  echo "<td>running</td>"
else
  echo "<td><strike>running</strike></td>"
fi

echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='map' value='map'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='boot' value='boot'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='close' value='close'></form></td>"
echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='delete' value='delete'></form></td>"
echo "</tr>"

done

echo "</table></fieldset>"
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
