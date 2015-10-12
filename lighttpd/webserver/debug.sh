#!/bin/env bash
#############################################################################################################################################################################################################

function debug {
echo "<fieldset><legend><h1><b>debug</b></h1></legend>"
echo "cookie_rotate:$(($(cat /home/user/lighttpd/auth/cookie.timestamp )-$(date +%s)))<br>"
echo "cookie_expire:$(date -d @$(cat /home/user/lighttpd/auth/cookie.expire))<br>"
if [[ ! ${#cookie[@]} -eq 0 ]];then echo "cookie: "; for i in ${!cookie[@]};do echo "$i:${cookie[$i]}";done;fi
if [[ ! ${#get[@]} -eq 0 ]];then echo "get: ";for i in ${!get[@]};do echo "$i:${get[$i]}";done;fi
if [[ ! ${#post[@]} -eq 0 ]];then echo "post: "; for i in ${!post[@]};do echo "$i:${post[$i]}";done;fi
echo "</fieldset>"
}
function form {
echo "<fieldset><legend><h1><b>form</b></h1></legend>"
echo "<table>
<form action=/index.cgi method=get><tr><td>get:  </td><td><input type=text name=get  value=text></td><td><input type=submit></td></tr></form>
<form action=/index.cgi method=post><tr><td>post:</td><td><input type=text name=post value=text></td><td><input type=submit></td></tr></form>
</table>"
echo "</fieldset>"
}


#############################################################################################################################################################################################################
#############################################################################################################################################################################################################
#############################################################################################################################################################################################################
#############################################################################################################################################################################################################
