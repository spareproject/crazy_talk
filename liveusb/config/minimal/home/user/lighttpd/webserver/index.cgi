#!/bin/env bash
. ./session.sh
#############################################################################################################################################################################################################
input
session
header
#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>systemctl</b></h3></legend>"
echo "<table>"
for i in iptables haveged systemd-networkd dnscrypt-proxy sshd@user lighttpd;do
  echo "<tr><td>${i}:</td><td>$(systemctl status ${i}|awk 'NR==3 {print $2$3}')</td></tr>"
done
echo "</table></fieldset>"
#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>debug</b></h3></legend>"
if [[ ! ${#post[@]} -eq 0 ]];then echo -n "post: ";for i in ${!post[@]};do echo "[${i}:${post[${i}]}]";done;fi;echo '<br>'
if [[ ! ${#get[@]} -eq 0 ]];then echo -n "post: ";for i in ${!get[@]};do echo "[${i}:${get[${i}]}]";done;fi;echo '<br>'
if [[ ! ${#cookie[@]} -eq 0 ]];then echo -n "cookie: ";for i in ${!cookie[@]};do echo "[${i}:${cookie[${i}]}]";done;fi;echo '<br>'
echo "</fieldset>"
#############################################################################################################################################################################################################
echo "
<fieldset><legend><h3><b>delete cookies</b></h3></legend>
<form action=/index.cgi method=post>
<input type=submit name=submit value=logout>
<input type=hidden name=action value=logout>
</form>
</fieldset>
"
#############################################################################################################################################################################################################
echo "
<fieldset>

header needs logout and shutdown... < - being kill all containers button

<legend><h3><b>offs</b></h3></legend>
<form action=/index.cgi method=post enctype='application/x-www-form-urlencoded'>
<input type=text value='application/x-www-form-urlencoded' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit name=default value=submit>
<input type=hidden name=action value=default>
</form>
<form action=/index.cgi method=post enctype='multipart/form-data'>
<input type=text value='multipart/form-data' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit name=ftp value=submit>
</form>
<form action=/index.cgi method=post enctype='text/plain'>
<input type=text value='text/plain' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</form>
<form action=/index.cgi method=get>
<input type=text value='get' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</fieldset>
"
#############################################################################################################################################################################################################
footer
#############################################################################################################################################################################################################
