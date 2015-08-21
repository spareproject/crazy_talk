#!/bin/env bash
. ./session
#############################################################################################################################################################################################################
input
session
header
#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>input</b></h3></legend>"
echo "$input<br>"
if [[ ! ${#post[@]} -eq 0 ]];then echo -n "post: ";for i in ${!post[@]};do echo "[${i}:${post[${i}]}]";done;fi
if [[ ! ${#get[@]}  -eq 0 ]];then echo -n "post: ";for i in ${!get[@]};do  echo "[${i}:${get[${i}]}]";done;fi
echo "</fieldset>"
#############################################################################################################################################################################################################
echo "<fieldset><legend><h3><b>cookiez</b></h3></legend>"
echo "${HTTP_COOKIE}<br>"
if [[ ! ${#cookie[@]} -eq 0 ]];then echo -n "cookie: ";for i in ${!cookie[@]};do echo "[${i}:${cookie[${i}]}]";done;fi
echo "</fieldset>"
#############################################################################################################################################################################################################
echo "
<fieldset>
<legend><h3><b>offs</b></h3></legend>
<form action=/index.cgi method=post enctype='application/x-www-form-urlencoded'>
<input type=text value='application/x-www-form-urlencoded' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</form>
<form action=/index.cgi method=post enctype='multipart/form-data'>
<input type=text value='multipart/form-data' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</form>
<form action=/index.cgi method=post enctype='text/plain'>
<input type=text value='text/plain' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</form>
<form action=/index.cgi method=get>
<input type=text value='get' name='test'>
<input type=text value='second' name='second'>
<input type=text value='third' name='third'>
<input type=submit value=submit>
</fieldset>
"
#############################################################################################################################################################################################################
footer
#############################################################################################################################################################################################################
