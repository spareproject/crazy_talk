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

<fieldset>"
 echo "Location:${SCRIPT_FILENAME##/home/user/lighttpd/webserver}"
if [[ ! ${#cookie[@]} -eq 0 ]];then echo "cookie: "; for i in ${!cookie[@]};do echo "$i:${cookie[$i]}";done;fi

echo "
<form action='/login.cgi' method='post'>
<table class=center><tr>
<td><a href=/index.cgi>[challenge]</url></td>
<td><input type='text' name='response'></td>
<td><select name=expire><option value="3600">1h</option><option value="86400">1d</option><option value="604800">1w</option><option value="2629743">1m</option><option value="31556926">1y</option></select></td>
<td><input type='submit' name='submit' value='login'></td>
</tr></table>
<input type=hidden name=action value=login></form>
</fieldset>

</div></div></div>
</body></html>
"
#############################################################################################################################################################################################################
