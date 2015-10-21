#!/bin/env bash
#############################################################################################################################################################################################################
declare -A get
declare -A post
declare -A cookie
#############################################################################################################################################################################################################
function input { # http_cookie needs fixing
if [[ ! -z ${HTTP_COOKIE} ]];then
  input=$(tr -cd 'a-zA-Z0-9=.[:space:]'<<<$HTTP_COOKIE)
  for i in ${input};do cookie[${i%%=*}]=${i##*=};done
  unset input
fi
if [[ ! -z ${QUERY_STRING} ]];then
  input=$(tr -cd 'a-zA-Z0-9=&%.'<<<$QUERY_STRING)
  OLDIFS=$IFS;IFS="&";for i in ${input};do get[${i%%=*}]=${i##*=};done;IFS=$OLDIFS
  unset input
fi
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "application/x-www-form-urlencoded" ]];then
  input=$(tr -cd 'a-zA-Z0-9=&%.\-\+_'</dev/stdin)
  OLDIFS=$IFS;IFS="&";for i in ${input};do post[${i%%=*}]=${i##*=};done;IFS=$OLDIFS
  unset input
fi
}
###############################################################################################################################################################################################################



###############################################################################################################################################################################################################
function session {
database=/home/user/lighttpd/database/webserver.sqlite
sqlite3 $database<<<"delete from session where session_expire<'$(date +%s)';"&>/dev/null
if [[ -v cookie[session] && $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and session='$(sha512sum<<<${cookie[session]})' and session_expire>'$(date +%s)');") == 1 ]];then
if [[ -v cookie[auth] && $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and auth='$(sha512sum<<<${cookie[auth]})' and auth_expire>'$(date +%s)');") == 1 ]];then
###############################################################################################################################################################################################################
#if [[ -v cookie[priv] && $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and priv='$(sha512sum<<<${cookie[priv]})' and priv_expire>'$(date +%s)');") == 0 ]];then
#if [[ ${REQUEST_URI} == "/account.cgi" ]];then echo "Location:/index.cgi";fi
#fi
###############################################################################################################################################################################################################

if [[ "${REQUEST_URI}" == "/2fa.cgi" || "${REQUEST_URI}" == "/login.cgi" || "${REQUEST_URI}" == "/register.cgi" ]];then echo "Location:/index.cgi";fi

if [[ ${post[action]} == "priv_logout" ]];then echo stub >/dev/null;fi
if [[ ${post[action]} == "auth_logout" ]];then echo stub >/dev/null;fi

if [[ ${post[action]} == "priv_login" ]];then
if [[ $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and response='$(sha512sum<<<${post[response]})');") == 1 ]];then

priv=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r "${cookie[username]}" -e<<<"$randum")

sqlite3 $database<<<"
update session set
priv='$(sha512sum<<<${priv})',
priv_expire='$(($(date +%s)+300))',
last_seen='$(date +%s)',
challenge='$challenge',
response='$(sha512sum<<<$randum)'
where response='$(sha512sum<<<${post[response]})';"

echo "Set-Cookie:priv=$priv;Path=/;Secure;HttpOnly";echo "Location:/account.cgi"

fi;fi
###############################################################################################################################################################################################################

else
if [[ "${REQUEST_URI}" != "/2fa.cgi" ]];then echo "Location:/2fa.cgi";fi
if [[ ${post[action]} == "session_logout" ]];then echo stub>/dev/null;fi

if [[ ${post[action]} == "auth_login" ]];then
if [[ $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and response='$(sha512sum<<<${post[response]})');") == 1 ]];then
auth=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r "${cookie[username]}" -e<<<"$randum")
sqlite3 $database<<<"
update session set
auth='$(sha512sum<<<$auth)',
auth_expire='$(($(date +%s)+${post[expire]}))',
last_seen='$(date +%s)',
challenge='$challenge',
response='$(sha512sum<<<$randum)'
where response='$(sha512sum<<<${post[response]})';"

echo "Set-Cookie:auth=$auth;Path=/;Secure;HttpOnly";echo "Location:/2fa.cgi"
fi;fi
###############################################################################################################################################################################################################
fi;else
#
if [[ "${REQUEST_URI}" != "/login.cgi" && "${REQUEST_URI}" != "/register.cgi" ]];then echo "Location:/login.cgi";fi
#
if [[ ${post[action]} == "session_login" ]];then
if [[ $(sqlite3 $database<<<"select exists(select * from user where username='${post[username]}' and password='$(sha512sum<<<${post[password]})');") == 1 ]];then
session=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
randum=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')

fingerprint=$(sqlite3 $database<<<"select fingerprint from user where username='${post[username]}';")

challenge=$(gpg --homedir /home/user/lighttpd/gnupg -r "${post[username]}" -e<<<"$randum")


sqlite3 $database<<<"
insert into session(username,session,session_expire,ip,created,last_seen,challenge,response)
values(
'${post[username]}',
'$(sha512sum<<<${session})',
'$(($(date +%s)+${post[expire]}))',
'$REMOTE_ADDR',
'$(date +%s)',
'$(date +%s)',
'$challenge',
'$(sha512sum<<<$randum)'
);"
echo "Set-Cookie:session=${session};Path=/;Secure:HttpOnly";
echo "Set-Cookie:username=${post[username]};Path=/;Secure;HttpOnly";
echo "Set-Cookie:fingerprint=$fingerprint;Path=/;Secure;HttpOnly";
echo "Location:/login.cgi"
fi;fi
#
if [[ ${post[action]} == "session_logout" ]];then
sqlite3 $database<<<"delete from session where username='${cookie[username]}' and session='$(sha512sum<<<${cookie[session]})';"
echo "Set-Cookie:session=;Path=/;Secure;HttpOnly";echo "Location:/login.cgi"
fi
#
fi

echo -e "Content-type:text/html\n\n";}
#############################################################################################################################################################################################################



#############################################################################################################################################################################################################
function header {
echo "
<!DOCTYPE html><html>
<head><title>spareProject...</title><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'></head>
<body>
<div id='panel' class='top'>
<ul class=left><li><a href=/index.cgi>[menu]</a><ul class=left_side>
  <li class=header>-</li>
  <a href=/register.cgi><li>register</li></a>
  <a href=/login.cgi><li>login</li></a>
  <a href=/index.cgi><li>index</li></a>
  <a href=/database.cgi><li>database</li></a>
  <a href=/account.cgi><li>account</li></a>
  <div id='spacer' class=center>-</div>
</ul></li></ul>
<ul class=right><li>[$(date)]<ul class=right_side>
  <li class=header>-</li>
  <li><form action=/index.cgi method=post><input type=hidden name=action value=logout><input type=submit value=logout></form></li>
  <div id='spacer'>-</div>
</ul></li></ul>
</div>
<div id='spacer'>a</div>
"
}
function footer { echo "<div id='spacer'>a</div><div id='panel' class='bottom'>Fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooter</div></body></html>"; }
#############################################################################################################################################################################################################

