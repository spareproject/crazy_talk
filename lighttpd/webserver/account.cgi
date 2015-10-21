#!/bin/env bash
. ./session.sh
. ./debug.sh
. ./sysinfo.sh
#############################################################################################################################################################################################################
input
session
header
#############################################################################################################################################################################################################
if [[ -v cookie[priv] && $(sqlite3 $database<<<"select exists(select * from session where username='${cookie[username]}' and priv='$(sha512sum<<<${cookie[priv]})' and priv_expire>'$(date +%s)');") == 1 ]];then
echo "
<fieldset><legend>account.cgi</legend>
time_left:$(($(sqlite3 /home/user/lighttpd/database/webserver.sqlite<<<"select priv_expire from session where priv='$(sha512sum<<<${cookie[priv]})';")-$(date +%s)))
<br>
you only get 5 minutes then you fuck off

<form action=account.cgi method=post>
<input type=submit value=revoke>
<input type=hidden name=action value=revoke>
</form>

</fieldset>
"
else
echo "
<fieldset><legend>priv_escalate</legend>
<form action=account.cgi method=post>
<table>
<tr><td><pre class=center>
$(sqlite3 /home/user/lighttpd/database/webserver.sqlite<<<"select challenge from session where username='${cookie[username]}';")
</tr></td></pre>
<tr><td class=center>
<input type=text name=response>
<input type='submit'>
</td></tr>
</table>
<input type=hidden name=action value=priv_login>
</form>
</fieldset>
"
fi
#############################################################################################################################################################################################################
footer
#############################################################################################################################################################################################################
