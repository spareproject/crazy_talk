#!/bin/env bash
#############################################################################################################################################################################################################
. ./session.sh
input
session
header
umask 077
#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>debug</b></h3></legend>"
echo "remote address:${REMOTE_ADDR}<br>"
if [[ -b /dev/archiso ]];then echo "plugged<br>";else echo "unplugged<br>";fi
if [[ $(ps aux |grep gpg-agent|grep /home/user/persistent) ]];then echo "gpg-agent exists<br>";else echo "gpg-agent dead<br>";fi
if [[ $(ls /home/user/persistent) == "" ]];then echo "persistent is empty<br>";else echo "persistent loaded and cached<br>";fi
if [[ ! ${#post[@]} -eq 0 ]];then echo -n "post: ";for i in ${!post[@]};do echo "[${i}:${post[${i}]}]";done;fi;echo '<br>'

if [[ $(date +%s) -lt $(cat /home/user/lighttpd/auth/oneshot.timestamp) ]];then echo "up for: $(($(cat /home/user/lighttpd/auth/oneshot.timestamp)-$(date +%s)))<br>";fi
echo "rawfs:$(ls /mnt/rawfs/)<br>"
echo "luks: $(ls /mnt/luks/) <br>"
#############################################################################################################################################################################################################
if [[ ${post[action]} == "oneshot" ]];then
if [[ ! -z ${post[timestamp]} && ! -z ${post[timestamp]} && ! -z ${post[pin]} && ${post[pin]} =~ ^[0-9]+$ ]];then
if [[ -b /dev/archiso1 && -b /dev/archiso2 && -b /dev/archiso3 ]];then
if [[ ! $(ps aux|grep gpg-agent|grep /home/user/persistent) && $(ls /home/user/persistent) == "" ]];then
  mount /dev/archiso2
  mount /dev/archiso3
  cp -ar /home/user/mount/gnupg/persistent/* /home/user/persistent
  sed -i "s/60/${post[timestamp]}/" /home/user/persistent/gpg-agent.conf
  if gpg --homedir /home/user/persistent --passphrase-fd 0 -d /home/user/mount/gnupg/trigger.asc 2>/dev/null <<< $(dd if=/home/user/random/randomfs bs=1 count=100 ibs=1 skip=${post[pin]} 2>/dev/null);then
    echo $(($(date +%s)+${post[timestamp]})) > /home/user/lighttpd/auth/oneshot.timestamp
    touch /home/user/unlocked
    (sleep ${post[timestamp]} && pkill gpg-agent && rm -r /home/user/persistent/* && rm -r /home/user/unlocked &)&
  else
    pkill gpg-agent
    rm -r /home/user/persistent/*
  fi
  umount /dev/archiso2
  umount /dev/archiso3
fi;fi;fi;fi
#############################################################################################################################################################################################################
if [[ ${post[action]} == "create" ]];then
if [[ $(mount|grep /mnt) ]];then
if [[ $(ps aux|grep gpg-agent|grep /home/user/persistent) && $(ls /home/user/persistent) != "" ]];then
if [[ ! -d /mnt/luks/${post[name]} && ! -d /mnt/rawfs/${post[name]} ]];then
if [[ ! -z ${post[size]} ]];then
if [[ ! -d /mnt/mount/${post[name]} ]];then
sudo /usr/bin/mkdir -p /mnt/mount/${post[name]}
fi
sudo /usr/bin/dd if=/dev/random of=/mnt/luks/${post[name]}.random bs=1 count=8192 2>/dev/null
sudo /usr/bin/gpg --homedir /home/user/persistent -o /mnt/luks/${post[name]} -e /mnt/luks/${post[name]}.random
sudo /usr/bin/fallocate -l ${post[size]} /mnt/rawfs/${post[name]}
sudo /usr/bin/cryptsetup --cipher aes-xts-plain64 --key-size 512 --iter-time 5000 --key-file /mnt/luks/${post[name]}.random --type=plain --offset 0 open /mnt/rawfs/${post[name]} ${post[name]}
sudo /usr/bin/rm /mnt/luks/${post[name]}.random
sudo /usr/bin/mkfs.ext4 /dev/mapper/${post[name]}

# mount doesnt work... 
sudo /usr/bin/mount /dev/mapper/${post[name]} /mnt/mount/${post[name]}
fi;fi;fi;fi;fi
#############################################################################################################################################################################################################

if [[ ${post[open]} == "open" ]];then
sudo /usr/bin/gpg --homedir /home/user/persistent -o /mnt/luks/${post[container]}.random -d /mnt/luks/${post[container]}
sudo /usr/bin/cryptsetup --cipher aes-xts-plain64 --key-size 512 --iter-time 5000 --key-file /mnt/luks/${post[container]}.random --type=plain --offset 0 open /mnt/rawfs/${post[container]} ${post[container]}
sudo /usr/bin/rm /mnt/luks/${post[container]}.random

# mount doesnt work
(sudo /usr/bin/mount /dev/mapper/${post[container]} /mnt/mount/${post[container]} &)&
fi
#############################################################################################################################################################################################################

if [[ ${post[close]} == "close" ]];then echo stub;fi
sudo /usr/bin/umount /mnt/mount/${post[container]}
sudo /usr/bin/cryptsetup close /dev/mapper/${post[container]}
#############################################################################################################################################################################################################

if [[ ${post[action]} == "start" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "stop" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "restart" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "install" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "wipe" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "delete" ]];then echo stub;fi
#############################################################################################################################################################################################################

if [[ ${post[action]} == "shutdown" ]];then echo stub;fi
#############################################################################################################################################################################################################

echo "</fieldset>"
#############################################################################################################################################################################################################

#############################################################################################################################################################################################################
if [[ ${REMOTE_ADDR} == "127.0.0.1" ]];then
#############################################################################################################################################################################################################
# plugged and not loaded
if [[ -b /dev/archiso1 && ! $(ps aux|grep gpg-agent|grep /home/user/persistent) && $(ls /home/user/persistent) == "" ]];then
 echo "
<fieldset><legend><h3><b>oneshot</b></h3></legend>
<form action=./container.cgi method=post>
<input type=text name=pin>
<select name=timestamp>
<option value=60>1m</option>
<option value=300>5m</option>
<option value=600>10m</option>
<option value=900>15m</option>
<input type=submit name=submit value=oneshot>
<input type=hidden name=action value=oneshot>
</form>
</fieldset>
"
fi
#############################################################################################################################################################################################################
#loaded
if [[ $(ps aux|grep gpg-agent|grep /home/user/persistent) && $(ls /home/user/persistent) != "" ]];then
#######################################################
echo "
<fieldset><legend><h3><b>create</b></h3></legend>
<table><tr>
<form action=/container.cgi method=post>
<td><input type=text name=name value=name></td>
<td><select name=size><option value='1G'>1G</option><option value='3G'>3G</option><option value='5G'>5G</option><option value='7G'>7G</option></select></td>
<td><input type=submit name=submit value=create></td>
<input type=hidden name=action value=create>
</form>
</tr></table>
</fieldset>
"
#######################################################
echo "<fieldset><legend><h3><b>internal</b></h3></legend><table>"
echo "loaded"
for i in $(ls /mnt/rawfs);do
if [[ -f /mnt/rawfs/${i} && -f /mnt/luks/${i} ]];then 
echo "<tr><form action='/container.cgi' method='post'><input type=hidden name=container value=${i}><td>${i}</td>"
if [[ -b /dev/mapper/${i} && $(mount|grep "/mnt/mount/${i}") ]];then
  if [[ $(machinectl|grep "^${i}") ]];then
    echo "<td><input type=submit name='stop' value='stop'></td><td><input type=submit name='restart' value='restart'></td>"
  else
    echo "<td><input type=submit name='close' value='close'></td>"
    echo "<td><input type=submit name='start' value='start'></td>"
    echo "<td><select name=config><option value=default>default</default></select><input type=submit name='install' value='install'></td>"
  fi
else
echo "<td><input type=submit name='open' value='open'></td>"
fi
echo "
<td><input type=submit name='query' value='query'></td>
<td><input type=submit name='delete' value='delete'></td>
</form></tr>
"
fi
done
echo "</table></fieldset>"
#not loaded
#############################################################################################################################################################################################################
elif [[ ! $(sudo ps aux|grep gpg-agent|grep /home/user/persistent) && $(ls /home/user/persistent) == "" ]];then
echo "<fieldset><legend><h3><b>internal</b></h3></legend><table>"
echo "not loaded"
for i in $(ls /mnt/rawfs);do
if [[ -f /mnt/rawfs/${i} && -f /mnt/luks/${i} ]];then 
echo "<tr><form action='/container.cgi' method='post'><input type=hidden name=container value=${i}><td>${i}</td>"
if [[ -b /dev/mapper/${i} && $(mount|grep "/mnt/mount/${i} ") ]];then
  if [[ $(machinectl|grep "^${i}") ]];then
    echo "<td><input type=submit name='stop' value='stop'></td><td><input type=submit name='restart' value='restart'></td>"
  else
    echo "<td><input type=submit name='close' value='close'></td>"
    echo "<td><input type=submit name='start' value='start'></td>"
    echo "<td><select name=config><option value=default>default</default></select><input type=submit name='install' value='install'></td>"
    echo "<td><input type=submit name=wipe value=wipe></td>"
  fi
fi
echo "<td><input type=submit name=query value=query></td>"
echo "<td><input type=submit name='delete' value='delete'></td>"
echo "</tr></form>"
fi
done
echo "</table></fieldset>"

#############################################################################################################################################################################################################
fi
#############################################################################################################################################################################################################
if [[ ${post[query]} == "query" ]];then
echo "
<fieldset><legend><h3><b>query - ${post[container]}</b></h3></legend>
testing 1... 2...
</fieldset>
"
fi
#############################################################################################################################################################################################################
echo "
<fieldset><legend><h3><b>shutdown</b></h3></legend>
<input type=submit name=shutdown value=shutdown> - kill everything running (doesnt actually shutdown) needs a better name
</fieldset>
"
#############################################################################################################################################################################################################
else echo "remote isnt going to be that easy";fi
#############################################################################################################################################################################################################
footer
#############################################################################################################################################################################################################

# stuff to idenitify unionfs legacy till more stuff works
#for i in $(mount | grep unionfs | awk '{print $3}');do
#echo "<tr><td>${i#/mnt/mount/}</td><td>mounted</td><td>"
#if [[ $(machinectl | grep "^${i#/mnt/mount/} ") ]];then echo "running</td>";else echo "<strike>running</strike></td>";fi
#echo "<td><form action='/index.cgi' method='post'><input type=hidden name='object' value='${i}'><input type=submit name='close' value='close'></form></td></tr>"
#done
#echo "</table>"
#echo "</fieldset>"

#############################################################################################################################################################################################################
