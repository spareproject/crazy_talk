#!/bin/env bash
#############################################################################################################################################################################################################
. ./session.sh
#############################################################################################################################################################################################################
input
session
#############################################################################################################################################################################################################
echo "
<!DOCTYPE html><html><head><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'><title>spareProject...</title></head>
<body>
<div class='outer'><div class='middle'><div class='inner'>
<fieldset>
"
#<pre class=center>
#############################################################################################################################################################################################################
# if timestamp has expired
#if [[ -f /home/user/lighttpd/auth/challenge.timestamp && $(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
#  echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
#  random=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
#  salt=$RANDOM
#  #debug mode
#  gpg --homedir /home/user/gnupg -e <<<$random>/home/user/lighttpd/webserver/challenge
#  #actual persistent key requires hotplug
#  #gpg --homedir /home/user/gnupg -e -r persistent<<<$randoms>/home/user/lighttpd/auth/challenge
#  #legacy really wanted tee pipe foo but wtf
#  #gpg --homedir /home/user/gnupg -e -r persistent<<<$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')>/home/user/lighttpd/auth/challenge
#  echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/challenge.hash
#  unset random;unset salt
#fi
#############################################################################################################################################################################################################
# first boot
#if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp ]];then
#  echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
#  random=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
#  salt=$RANDOM
#  #debug mode
#  gpg --homedir /home/user/gnupg -e <<<$random>/home/user/lighttpd/webserver/challenge
#  #actual persistent key requires hotplug
#  #gpg --homedir /home/user/gnupg -e -r persistent<<<$randoms>/home/user/lighttpd/auth/challenge
#  #legacy really wanted tee pipe foo but wtf
#  #gpg --homedir /home/user/gnupg -e -r persistent<<<$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')>/home/user/lighttpd/auth/challenge
#  echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/challenge.hash
#  unset random;unset salt
#fi
#############################################################################################################################################################################################################
#cat /home/user/lighttpd/webserver/challenge
#</pre>
echo "
<form action='/login.cgi' method='post'>
<table class=center><tr>
<td><a href=/challenge>[challenge]</url></td>
<td><input type='text' name='response'></td>
<td>
<select name=expire>
<option value="3600">1h</option>
<option value="86400">1d</option>
<option value="604800">1w</option>
<option value="2629743">1m</option>
<option value="31556926">1y</option>
</select>
</td>
<td><input type='submit' name='submit' value='login'></td>
</tr></table>
<input type=hidden name=action value=login>
</form>
</fieldset>
</div></div></div>
</body></html>
"
#############################################################################################################################################################################################################
