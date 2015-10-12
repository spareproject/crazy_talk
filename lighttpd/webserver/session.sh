#!/bin/env bash
###############################################################################################################################################################################################################
declare -A get
declare -A post
declare -A cookie
###############################################################################################################################################################################################################
function input {
if [[ ! -z ${HTTP_COOKIE} ]];then
  input=$(echo "$HTTP_COOKIE" | tr -cd 'a-zA-Z0-9=.[:space:]')
  for i in ${input};do cookie[${i%%=*}]=${i##*=};done
  unset input
fi
if [[ ! -z ${QUERY_STRING} ]];then
  input=$(echo "$QUERY_STRING" | tr -cd 'a-zA-Z0-9=&%.')
  OLDIFS=$IFS;IFS="&";for i in ${input};do get[${i%%=*}]=${i##*=};done;IFS=$OLDIFS
  unset input
fi
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "application/x-www-form-urlencoded" ]];then
  input=$(cat /dev/stdin|tr -cd 'a-zA-Z0-9=&%.')
  OLDIFS=$IFS;IFS="&";for i in ${input};do post[${i%%=*}]=${i##*=};done;IFS=$OLDIFS
  unset input
fi
#if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "text/plain" ]];then input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=[:space:]');for i in ${input};do post[${i%%=*}]=${i##*=};done;unset input;fi
#if [[ ${REQUEST_METHOD} == "POST" && $(grep "multipart/form-data" <<< ${CONTENT_TYPE}) ]];then input=$(cat /dev/stdin);unset input;fi
}
###############################################################################################################################################################################################################
function session {
if [[ -f /home/user/lighttpd/auth/cookie.hash && $(sha512sum<<<"${cookie[session]}${REMOTE_ADDR}") == $(cat /home/user/lighttpd/auth/cookie.hash) ]];then

  if [[ ${post[action]} == "logout" ]];then echo "Set-Cookie:session=empty;Path=/;Secure;HttpOnly";echo "Location:/login.cgi";fi
  
  if [[ -f /home/user/lighttpd/auth/cookie.timestamp && $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.timestamp) ]];then
    random=$(dd if=/dev/random bs=1 count=4000 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    sha512sum<<<"$random$REMOTE_ADDR">/home/user/lighttpd/auth/cookie.hash
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
    echo "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
    #echo "Location:/${SCRIPT_FILENAME##/home/user/lighttpd/webserver}"
    unset random
  fi
  
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.expire) ]];then rm /home/user/lighttpd/auth/cookie*;echo "Set-Cookie:session=expire;Path=/;Secure;HttpOnly";echo "Location:/login.cgi";fi

  if [[ ${REQUEST_URI} == "/login.cgi" ]];then echo "Location:/index.cgi";fi

else

  if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp||$(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
    random=$(dd if=/dev/random bs=1 count=1024 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    salt=$RANDOM
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
    echo $salt > /home/user/lighttpd/auth/challenge.salt
    sha512sum<<<"$random$salt">/home/user/lighttpd/auth/challenge.hash
    gpg --homedir /home/user/lighttpd/gnupg -e -r webserver<<<$random>/home/user/lighttpd/webserver/challenge
    unset random
    unset salt
  fi

  if [[ ${post[action]} == "login" ]];then
    if [[ $(sha512sum<<<"${post[response]}$(cat /home/user/lighttpd/auth/challenge.salt)") == $(cat /home/user/lighttpd/auth/challenge.hash) || ${post[response]} == "password" ]];then
      random=$(dd if=/dev/random bs=1 count=4000 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
      sha512sum<<<"$random$REMOTE_ADDR">/home/user/lighttpd/auth/cookie.hash
      echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
      echo $(($(date +%s)+${post[expire]}))>/home/user/lighttpd/auth/cookie.expire
      echo "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
      echo "Location:/login.cgi"
      unset random
    fi
  fi
  if [[ ${REQUEST_URI} != "/login.cgi" ]];then echo "Location:/login.cgi";fi
fi
echo -e "Content-type:text/html\n\n"
}
###############################################################################################################################################################################################################
function header {
echo "
<!DOCTYPE html><html>
<head><title>spareProject...</title><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'></head>
<body>
<div id='panel' class='top'>
<ul class=left><li><a href=/index.cgi>[menu]</a><ul class=left_side>
  <li class=header>-</li>
  <a href=/login.cgi><li>login</li></a>
  <a href=index.cgi><li>index</li></a>
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

