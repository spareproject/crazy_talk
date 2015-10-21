#!/bin/bash
#############################################################################################################################################################################################################
. ./session.sh
. ./database.sh
input
database="/home/user/lighttpd/database/webserver.sqlite"
header
#############################################################################################################################################################################################################
if [[ ${post[action]} == "delete_user" ]];then
sqlite3 $database <<< "delete from user where username = '${post[username]}';"
gpg --homedir /home/user/lighttpd/gnupg --delete-key ${post[username]} &>/dev/null

fi
if [[ ${post[action]} == "delete_session" ]];then sqlite3 $database <<< "delete from session where uuid = '${post[uuid]}';";fi

if [[ ${post[action]} == "register" ]];then

post[email]=$(sed 's/%40/@/'<<<${post[email]})
post[password]=$(sha512sum<<<${post[password]})
post[pubkey]=$(sed -e 's/\+/ /g' -e 's/%0D%0A/\r\n/g' -e 's/%2F/\//g' -e 's/%2B/\+/g' -e 's/%3A/\:/g' -e 's/%3D/=/g'<<<${post[pubkey]})
fingerprint=$(gpg --homedir /home/user/lighttpd/gnupg --with-fingerprint<<<"${post[pubkey]}" 2>/dev/null|sed -n '2p'|awk -F '=' '{print $2}'|tr -d ' ')
if [[ ! -z $fingerprint ]];then
gpg --homedir /home/user/lighttpd/gnupg --import<<<"${post[pubkey]}" &>/dev/null
gpg --homedir /home/user/lighttpd/gnupg --quick-sign-key ${fingerprint} &>/dev/null
sqlite3 $database <<< "
insert into user(username,password,email,pubkey,fingerprint,salt)
values(
'${post[username]}',
'${post[password]}',
'${post[email]}',
'${post[pubkey]}',
'${fingerprint}',
'$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')'
);" 2>&1
fi

fi
#############################################################################################################################################################################################################
view_database
delete_fieldset
register_fieldset
footer
#############################################################################################################################################################################################################
#############################################################################################################################################################################################################
