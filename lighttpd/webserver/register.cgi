#!/bin/bash
###############################################################################################################################################################################################################
. ./session.sh
###############################################################################################################################################################################################################
input
session
###############################################################################################################################################################################################################
#if [[ ${post[action]} == "register" ]];then
#post[email]=$(sed 's/%40/@/'<<<${post[email]})
#post[password]=$(sha512sum<<<${post[password]})
#post[pubkey]=$(sed -e 's/\+/ /g' -e 's/%0D%0A/\r\n/g' -e 's/%2F/\//g' -e 's/%2B/\+/g' -e 's/%3A/\:/g' -e 's/%3D/=/g'<<<${post[pubkey]})
#fingerprint=$(gpg --homedir /home/user/lighttpd/gnupg --with-fingerprint<<<"${post[pubkey]}" 2>/dev/null|sed -n '2p'|awk -F '=' '{print $2}'|tr -d ' ')
#
#if [[ ! -z $fingerprint ]];then
#gpg --homedir /home/user/lighttpd/gnupg --import<<<"${post[pubkey]}" &>/dev/null
#gpg --homedir /home/user/lighttpd/gnupg --quick-sign-key ${fingerprint} &>/dev/null
#sqlite3 $database<<<"
#insert into user(username,password,email,pubkey,fingerprint,salt)
#values(
#'${post[username]}',
#'${post[password]}',
#'${post[email]}',
#'${post[pubkey]}',
#'${fingerprint}',
#'$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')'
#);"
#fi

echo "
<!DOCTYPE html><html><head><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'><title>spareProject...</title></head>
<body>
<div class='outer'>
<div class='middle'>
<div class='inner'>

<fieldset><legend>register</legend>
<form action='/register.cgi' method='post' id=register_form>

<table>
<tr><td>username</td><td><input type=text name=username></td></tr>
<tr><td>password</td><td><input type=password name=password></td></tr>
<tr><td>email</td><td><input type=text name=email></td></tr>
<tr><td>pubkey</td><td><textarea name=pubkey cols=64 form=register_form id=pubkey></textarea></td></tr>
<tr><td>captcha</td><td><input type=text name=captcha></td></tr>
<tr><td></td><td><pre class=captcha>$(figlet<<<$(shuf -n 1 /usr/share/dict/british))</pre></td></tr>
<tr><td><a href=/login.cgi>[login]</a></td><td><input class=wstretch type=submit value=register></td></tr>
</table>

<input type=hidden name=action value=session_login></form>
</fieldset>

</div>
</div>
</div>
</body></html>
"
###############################################################################################################################################################################################################
