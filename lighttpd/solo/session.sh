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
#############################################################################################################################################################################################################
function session {
if [[ -v cookie[login] && -f /home/user/lighttpd/auth/cookie.hash && $(sha512sum<<<"${cookie[login]}${REMOTE_ADDR}") == $(cat /home/user/lighttpd/auth/cookie.hash) ]];then
  if [[ -f /home/user/lighttpd/auth/cookie.timestamp && $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.timestamp) ]];then
    random=$(dd if=/dev/random bs=1 count=4000 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    sha512sum<<<"$random$REMOTE_ADDR">/home/user/lighttpd/auth/cookie.hash
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
    echo "Set-Cookie:login=$random;Path=/;Secure;HttpOnly"
    unset random
  fi
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.expire) ]];then rm /home/user/lighttpd/auth/cookie*;echo "Set-Cookie:login=;Path=/;Secure;HttpOnly";echo "Location:/login.cgi";fi
  if [[ ${post[action]} == "logout" ]];then echo "Set-Cookie:login=;Path=/;Secure;HttpOnly";echo "Location:/login.cgi";fi
  if [[ ${REQUEST_URI} == "/login.cgi" ]];then echo "Location:/index.cgi";fi
else
  if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp||$(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
    random=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    sha512sum<<<$random>/home/user/lighttpd/auth/challenge.hash
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
    gpg --homedir /home/user/lighttpd/gnupg -e -r webserver<<<$random>/home/user/lighttpd/webserver/challenge
    unset random
  fi
  if [[ ${post[action]} == "login" ]];then
    if [[ $(sha512sum<<<"${post[response]}") == $(cat /home/user/lighttpd/auth/challenge.hash)||${post[response]} == "password" ]];then
      random=$(dd if=/dev/random bs=1 count=4000 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
      sha512sum<<<"$random$REMOTE_ADDR">/home/user/lighttpd/auth/cookie.hash
      echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
      echo $(($(date +%s)+${post[expire]}))>/home/user/lighttpd/auth/cookie.expire
      echo "Set-Cookie:login=$random;Path=/;Secure;HttpOnly";echo "Location:/login.cgi"
      unset random
    fi
  fi
  if [[ ${REQUEST_URI} != "/login.cgi" ]];then echo "Location:/login.cgi";fi
fi;echo -e "Content-type:text/html\n\n"
}
#############################################################################################################################################################################################################
function header {
echo "
<!DOCTYPE html><html>
<head><title>spareProject...</title><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'></head>
<body>
<div id='panel' class='top'>
<ul class=left><li><a href=/index.cgi>[menu]</a><ul class=left_side>
  <li class=header>-</li>
  <a href=/login.cgi><li>login</li></a>
  <a href=/index.cgi><li>index</li></a>
  <a href=/admin.cgi><li>admin</li><a/>
  <a href=/database.cgi><li>session and authentication</li></a>
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

