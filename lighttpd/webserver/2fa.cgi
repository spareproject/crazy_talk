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
<div class='outer'>
<div class='middle'>
<div class='inner'>

<fieldset><legend>2fa</legend>
<form action='/2fa.cgi' method='post'>
<table class=center>

<tr><td><pre class=center>
$(sqlite3 /home/user/lighttpd/database/webserver.sqlite<<<"select challenge from session where username='${cookie[username]}' and session='$(sha512sum<<<${cookie[session]})';")
</pre></td></tr>

<tr>
<td><input type=text name=response>
<select name=expire><option value="1800">30m</option><option value="3600">1h</option><option value="7200">2h</option><option value="14400">4h</option></select>
<input type='submit'>
</td>
</tr>
</table>

<input type=hidden name=action value=auth_login></form>
</fieldset>

</div>
</div>
</div>
</body></html>
"
#############################################################################################################################################################################################################
