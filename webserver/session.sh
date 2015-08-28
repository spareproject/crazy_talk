#!/bin/env bash
###############################################################################################################################################################################################################
declare -A get
declare -A post
declare -A cookie
###############################################################################################################################################################################################################
function input {
# if cookie contains a space or an equals sign this all goes to shit...
if [[ ! -z ${HTTP_COOKIE} ]];then
  input=$(echo "$HTTP_COOKIE" | tr -cd 'a-zA-Z0-9=[:space:]')
  for i in ${input};do
    cookie[${i%%=*}]=${i##*=}
  done
  unset input
fi
# not planning on using it
if [[ ! -z ${QUERY_STRING} ]];then
  input=$(echo "$QUERY_STRING" | tr -cd 'a-zA-Z0-9=&%')
  OLDIFS=$IFS;IFS="&"
  for i in ${input};do
    get[${i%%=*}]=${i##*=}
  done
  IFS=$OLDIFS
  unset input
fi
# default works doing sed -i -e 's/%00/i/' whitelist for given fields
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "application/x-www-form-urlencoded" ]];then
  input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=&%.')
  OLDIFS=$IFS;IFS="&"
  for i in ${input};do
    post[${i%%=*}]=${i##*=}
  done
  IFS=$OLDIFS
  unset input
fi
# same as cookie doesnt work yet
if [[ ${REQUEST_METHOD} == "POST" && ${CONTENT_TYPE} == "text/plain" ]];then
  input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=[:space:]')
  for i in ${input};do
    post[${i%%=*}]=${i##*=}
  done
fi
# will do upload after... will containe xss if its a mime type extension but tr -cd 'a-zA-Z0-9' on input field for filename probably doable anyway but not high priority
if [[ ${REQUEST_METHOD} == "POST" && $(grep "multipart/form-data" <<< ${CONTENT_TYPE}) ]];then
  input=$(cat /dev/stdin)
fi
}
###############################################################################################################################################################################################################
function session {
# clicking the download button doesnt re trigger timestamp check so its a clock down from 60 after you hit the page
# it checks timestamp before reading response so it will update before doing the login mechanism
# means if you scrape the challenge download when you hit this page it still checks its age
# scripted curl login... would need to pull login.cgi to trigger challenge update before pulling challenge
# check the cookie[session]$salt != cookie.hash
##########################################################
#if [[ -z ${cookie[session]} ]];then
#  if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp || $(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
#    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
#    random=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
#    salt=$RANDOM
#    echo $salt > /home/user/lighttpd/auth/challenge.salt
#    # using rng for debug means no remote needs persistent public key for actual use
#    gpg --homedir /home/user/gnupg -e <<<$random>/home/user/lighttpd/webserver/challenge
#    #gpg --homedir /home/user/gnupg -e -r persistent <<<$random>/home/user/lighttpd/webserver/challenge
#    echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/challenge.hash
#    unset random;unset salt
#  fi
#fi
##########################################################
# if logged in - minus checking files exist
if [[ -f /home/user/lighttpd/auth/cookie.salt && -f /home/user/lighttpd/auth/cookie.hash && $(echo ${cookie[session]}$(cat /home/user/lighttpd/auth/cookie.salt)|sha512sum|sed 's/\W//g') == $(cat /home/user/lighttpd/auth/cookie.hash) ]];then

  if [[ ${post[action]} == "logout" ]];then echo -e "Set-Cookie:session=\Path=/;Secure;HttpOnly";echo -e "Location:/login.cgi";fi
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.timestamp) ]];then
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
    random=$(dd if=/dev/random bs=1 count=4096 2>/dev/null|tr -c 'a-zA-Z0-9' 'a')
    salt=${REMOTE_ADDR}
    echo $salt > /home/user/lighttpd/auth/cookie.salt
    echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/cookie.hash
    echo -e "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
    #echo -e "Location:/${SCRIPT_FILENAME##/home/user/lighttpd/webserver}"
    echo -e "Location:${SCRIPT_FILENAME##/home/user/lighttpd/webserver}"
  fi
  if [[ $(date +%s) -gt $(cat /home/user/lighttpd/auth/cookie.expire) ]];then
    rm /home/user/lighttpd/auth/cookie*
    echo -e "Location:/login.cgi"
  fi
  if [[ ${REQUEST_URI} == "/login.cgi" ]];then
        echo "Location:/index.cgi"
  fi

else

  if [[ ! -f /home/user/lighttpd/auth/challenge.timestamp || $(date +%s) -gt $(cat /home/user/lighttpd/auth/challenge.timestamp) ]];then
    echo $(($(date +%s)+60))>/home/user/lighttpd/auth/challenge.timestamp
    random=$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')
    salt=$RANDOM
    echo $salt > /home/user/lighttpd/auth/challenge.salt
    # using rng for debug means no remote needs persistent public key for actual use
    #gpg --homedir /home/user/gnupg -e <<<$random>/home/user/lighttpd/webserver/challenge
    gpg --homedir /home/user/gnupg -e -r persistent <<<$random>/home/user/lighttpd/webserver/challenge
    echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/challenge.hash
    unset random;unset salt
  fi
  if [[ ${post[action]} == "login" ]];then
    if [[ $(echo ${post[response]}$(cat /home/user/lighttpd/auth/challenge.salt)|sha512sum|sed 's/\W//g') == $(cat /home/user/lighttpd/auth/challenge.hash) ]];then
      echo $(($(date +%s)+60))>/home/user/lighttpd/auth/cookie.timestamp
      echo $(($(date +%s)+${post[expire]}))>/home/user/lighttpd/auth/cookie.expire
      random=$(dd if=/dev/random bs=1 count=4096 2>/dev/null|tr -c 'a-zA-Z0-9' 'a')
      salt=${REMOTE_ADDR}
      echo $salt > /home/user/lighttpd/auth/cookie.salt
      echo "$random$salt"|sha512sum|sed 's/\W//g' > /home/user/lighttpd/auth/cookie.hash
      echo -e "Set-Cookie:session=$random;Path=/;Secure;HttpOnly"
      echo -e "Location:/login.cgi"
    fi
  fi
  if [[ ${REQUEST_URI} != "/login.cgi" ]];then echo -e "Location:/login.cgi";fi
fi
#echo -e "path=/\r"
#echo -e "secure\r"
echo -e "Content-type:text/html\n\n"
}
###############################################################################################################################################################################################################
function header {
echo "
<!DOCTYPE html><html><head>
<title>spareProject...</title>
<meta charset='utf-8'/>
<link rel='stylesheet' type='text/css' href='/default.css'>
</head>
<body>
<div id='panel' class='top'>
<a class='menu left' href='/index.cgi'><h3><b>[index]</b></h3></a>
<a class='menu left' href='/started.cgi'><h3><b>[started]</b></h3></a>
<a class='menu left' href='/database.cgi'><h3><b>[database]</b></h3></a>
<a class='menu right' href=#><h3><b>[$(date)]</b></h3></a>
<a class='menu right' href=/login.cgi><h3><b>[login]</b></h3></a>
</div>
<div id='spacer'>a</div>
"
}
function footer { echo "<div id='spacer'>a</div><div id='panel' class='bottom'>Footer</div></body></html>"; }
###############################################################################################################################################################################################################
