#!/bin/bash
#############################################################################################################################################################################################################
. ./session.sh;. ./database.sh;input
database="/home/user/lighttpd/database/webserver.sqlite"
#############################################################################################################################################################################################################
sqlite3 $database<<<"delete from session where session_expire<'$(date +%s)';"&>/dev/null
#############################################################################################################################################################################################################

if [[ -v cookie[session] && $(sqlite3 $database<<<"select count(session) from session where session='$(sha512sum<<<${cookie[session]})' and session_expire>'$(date +%s)';") -gt 0 ]];then
if [[ -v cookie[auth] && $(sqlite3 $database<<<"select count(auth) from session where session='$(sha512sum<<<${cookie[session]})' and auth='$(sha512sum<<<${cookie[auth]})';") -gt 0 ]];then

if [[ ${post[action]} == "auth_logout" ]];then
sqlite3 $database<<<"update session set auth='' where auth='$(sha512sum<<<${cookie[auth]})';"
echo "Set-Cookie:auth=;Path=/database.cgi;Secure;HttpOnly";echo "Location:/database.cgi"
fi

if [[ ${post[action]} == "priv_escalate" ]];then
if [[ $(sqlite3 $database<<<"select count(response) from session where response='$(sha512sum<<<${post[response]})';") -gt 0 ]];then

priv=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=256 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
username=$(sqlite3 $database<<<"select username from session where response='$(sha512sum<<<${post[response]})';")
challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r $username -e<<<"$randum")

sqlite3 $database<<<"
update session set
priv='$(sha512sum<<<${priv})',
priv_expire='$(($(date +%s)+300))',
last_seen='$(date +%s)',
challenge='$challenge',
response='$(sha512sum<<<$randum)'
where response='$(sha512sum<<<${post[response]})';"

echo "Set-Cookie:priv=${priv};Path=/database.cgi;Secure;HttpOnly";echo "Location:/database.cgi"

fi;fi

header

echo "
<fieldset><legend>logged_in</legend>

</fieldset>
"

auth_logout_fieldset

if [[ $(sqlite3 $database<<<"select count(priv) from session where priv='$(sha512sum<<<${cookie[priv]})' and priv_expire>'$(date +%s)';") -gt 0 ]];then
echo "in your kitchen eatin your bisquites :D"
fi

priv_escalate_fieldset
footer
exit
#############################################################################################################################################################################################################
else

if [[ ${post[action]} == "session_logout" ]];then
sqlite3 $database<<<"delete from session where session='$(sha512sum<<<${cookie[session]})';"
echo "Set-Cookie:session=;Path=/database.cgi;Secure;HttpOnly";echo "Location:/database.cgi"
fi

if [[ "${post[action]}" == "auth_login" ]];then
if [[ $(sqlite3 $database<<<"select count(response) from session where response='$(sha512sum<<<${post[response]})';") -gt 0 ]];then

auth=$(dd if=/dev/random bs=1 count=1024|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=256|tr -c 'a-zA-Z0-9' '.')
username=$(sqlite3 $database<<<"select username from session where response='$(sha512sum<<<${post[response]})';")
challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r $username -e<<<"$randum")

sqlite3 $database<<<"
update session set
auth='$(sha512sum<<<${auth})',
auth_expire='$(($(date +%s)+${post[expire]}))',
last_seen='$(date +%s)',
challenge='$challenge',
response='$(sha512sum<<<$randum)'
where response='$(sha512sum<<<${post[response]})';"

echo "Set-Cookie:auth=${auth};Path=/database.cgi;Secure;HttpOnly";echo "Location:/database.cgi"
fi;fi

header

auth_login_fieldset
session_logout_fieldset
footer
exit

fi
#############################################################################################################################################################################################################
else

if [[ "${post[action]}" == "session_login" ]];then
if [[ $(sqlite3 $database<<<"select count(username) from user where username = '${post[username]}' and password = '$(sha512sum<<<${post[password]})';") -gt 0 ]];then

session=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=256 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r "${post[username]}" -e <<<"$randum")

sqlite3 $database<<<"
insert into session(username,session,session_expire,ip,created,last_seen,challenge,response)
values(
'${post[username]}',
'$(sha512sum<<<${session})',
'$(($(date +%s)+${post[expire]}))',
'${REMOTE_ADDR}',
'$(date +%s)',
'$(date +%s)',
'$challenge',
'$(sha512sum<<<$randum)'
);"

echo "Set-Cookie:session=${session};Path=/database.cgi;Secure;HttpOnly";echo "Location:/database.cgi"
fi;fi

header
session_login_fieldset
footer

fi
#############################################################################################################################################################################################################
