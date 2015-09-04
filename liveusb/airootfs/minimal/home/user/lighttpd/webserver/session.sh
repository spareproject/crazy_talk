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
  input=$(echo "$QUERY_STRING" | tr -cd 'a-zA-Z0-9=&%')
  OLDIFS=$IFS;IFS="&"
  for i in ${input};do get[${i%%=*}]=${i##*=};done
  IFS=$OLDIFS
  unset input
fi
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "application/x-www-form-urlencoded" ]];then
  input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=&%.')
  OLDIFS=$IFS;IFS="&"
  for i in ${input};do post[${i%%=*}]=${i##*=};done
  IFS=$OLDIFS
  unset input
fi
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "text/plain" ]];then
  input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=[:space:]')
  for i in ${input};do post[${i%%=*}]=${i##*=};done
  unset input
fi
if [[ ${REQUEST_METHOD} == "POST" && $(grep "multipart/form-data" <<< ${CONTENT_TYPE}) ]];then input=$(cat /dev/stdin);unset input;fi
}
###############################################################################################################################################################################################################
function session {
if [[ -f /home/user/lighttpd/auth/cookie.hash && $(echo ${cookie[session]}${REMOTE_ADDR}|sha512sum|sed 's/\W//g') == $(cat /home/user/lighttpd/auth/cookie.hash) ]];then
  if [[ ${post[action]} == "logout" ]];then echo -e "Set-Cookie:session=;Path=/;Secure;HttpOnly";echo -e "Location:/login.cgi";fi
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.timestamp) ]];then
    random=$(dd if=/dev/random bs=1 count=4096 2>/dev/null|tr -c 'a-zA-Z0-9' '.');
    echo "$random$REMOTE_ADDR"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/cookie.hash
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
    echo -e "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
    echo -e "Location:${SCRIPT_FILENAME##/home/user/lighttpd/webserver}"
    unset random
  fi
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.expire) ]];then rm /home/user/lighttpd/auth/cookie*;echo -e "Location:/login.cgi";fi
  if [[ ${REQUEST_URI} == "/login.cgi" ]];then echo "Location:/index.cgi";fi
else
  if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp || $(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
    random=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    salt=$RANDOM
    echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/challenge.hash
    echo $salt > /home/user/lighttpd/auth/challenge.salt
    gpg --homedir /home/user/gnupg -e -r persistent <<<$random>/home/user/lighttpd/webserver/challenge
    unset random;unset salt
  fi
  if [[ ${post[action]} == "login" ]];then
    if [[ $(echo ${post[response]}$(cat /home/user/lighttpd/auth/challenge.salt)|sha512sum|sed 's/\W//g') == $(cat /home/user/lighttpd/auth/challenge.hash) ]];then
      random=$(dd if=/dev/random bs=1 count=4096 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
      echo "$random$REMOTE_ADDR"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/cookie.hash
      echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
      echo $(($(date +%s)+${post[expire]}))>/home/user/lighttpd/auth/cookie.expire
      echo -e "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
      echo -e "Location:/login.cgi"
    fi
  fi
  if [[ ${REQUEST_URI} != "/login.cgi" ]];then echo -e "Location:/login.cgi";fi
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
<a class='menu left' href='/index.cgi'><h3><b>[index]</b></h3></a>
<a class='menu left' href='/container.cgi'><h3><b>[container]</b></h3></a>
<a class='menu left' href='/test.cgi'><h3><b>[test]</b></h3></a>
<a class='menu right' href=#><h3><b>[$(date)]</b></h3></a>
</div>
<div id='spacer'>a</div>
"
}
function footer { echo "<div id='spacer'>a</div><div id='panel' class='bottom'>Footer</div></body></html>"; }
###############################################################################################################################################################################################################
