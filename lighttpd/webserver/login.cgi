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

<fieldset><legend>login</legend>
<form action='/login.cgi' method='post'>

<table class=center>

<tr>
<td>username</td>
<td><input type=text name=username value=booob></td>
</tr>

<tr>
<td>password</td>
<td><input type=password name=password value=password></td>
</tr>

<tr>
<td>captcha</td>
<td><input type=text name=captcha></td>
</tr>
<tr>
<td><select class=wstretch name=expire><option value="1800">30m</option><option value="3600">1h</option><option value="86400">1d</option><option value="604800">1w</option></select></td>
<td><input class=wstretch type=submit value=login></td>
</tr>

<tr>
<td><a href=/register.cgi>[register]</a></td>
<td><pre class=captcha>$(figlet<<<$(shuf -n 1 /usr/share/dict/british))</pre></td>
</tr>



</table>

<input type=hidden name=action value=session_login></form>
</fieldset>

</div>
</div>
</div>
</body></html>
"
#############################################################################################################################################################################################################
