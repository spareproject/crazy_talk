#!/bin/env bash
#############################################################################################################################################################################################################
. ./session
#############################################################################################################################################################################################################
input
session
#############################################################################################################################################################################################################
echo "
<!DOCTYPE html><html><head><meta charset='utf-8'/><link rel='stylesheet' type='text/css' href='/default.css'><title>spareProject...</title></head>
<body>
<div class='outer'><div class='middle'><div class='inner'>
<fieldset>
<form action='/2fa.cgi' method='post'>
<table>
<tr><td><input class='input_text' type='text' name='username' value='username'></td><td></td></tr>
<tr><td><input type='password' name='password' value='password'></td><td><input type='submit' name='login' value='login'></td></tr>
</table>
</form>
</fieldset>
</div></div></div>
</body></html>
"
#############################################################################################################################################################################################################
