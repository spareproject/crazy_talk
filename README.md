#READMAH
<br>
all round general fail and literally no updates if anything more unmanagable shit code and complexity<br>
<br>
<br>
i wanted to quickly throw an insecure gui up... demo mode<br>
lighttpd just outright doesnt want me to<br>
ive been staring at it for 2 days wondering why nothing works<br>
plan was just sudo the parts that need root perms demo a working version<br>
tidy it find ways around the lulz of it all after the fact<br>
i cant get sudo pipes to work mount to work tmp access to work and ive only done oneshot,open,close and create none of which actually work<br>
its like someone said o you can execute a bash script... but that person was an evil lying fuck tard<br>
it can be done but i want this working and atleast to a state i wouldnt be embarrassed to stick my name next to and webservers going to take to long<br>
<br>
so basically its get this stable trimmed checked tidy to the point my ocd lets me sleep at night<br>
get a stupidly easy to multi boot cluster set up <br>
find a way to blag i have the usb on this node so i can unlock on any network attached node (not throwing this up needs to be secure)<br>
<br>
drop the .bash_profile and go firstboot after loading (more entropy)<br>
most of the scripts i have where thrown up as quickly as possible its tidy up time because i can actually boot containers :D<br>
systemd-nspawn: CAP_SETGID CAP_SETUID CAP_CHOWN if you drop these it doesnt boot... i dont really get the logic with that but im assuming it was /dev/pts/ and pt_chown related? /shrug<br>
<br>
either way its getting bloated with stuff im adding when i havent hardened what was already there<br>
if i take two days to play with a web server come back to it and cant figure out where im at its to complex i still blame openssl<br>
how much easier this would be if i just dropped lighttpd and openssl<br>
and stuck with openssh + gnupg for a cli based home cluster setup<br>
<br>
openssl and lighttpd was pretty much a distraction because nspawn wouldnt even boot...<br>
aslong as nothing gets updated by monday im going to dump the actual iso<br>
with working easy to use scripts a default nspawn install then be done with this working snapshot checkpoint and get a real job<br>
<br>
i only ever dumped any of this online because i was using other peoples stuff i mean this entire thing is a blatent rip of archiso<br>
i loved archiso in terms of how much i managed to learn and what i got to play with so on the off chance this helps someone else <br>
have as much fun learning playing making building anything then its not a total loss <br>
as for the quality stablity of anything in this git repo well lulz <br>
^ seriously tho if its left stale for like 3 days the rate stuff changes in arch its going to be dead to the world an ugly mess of code that isnt documented and outright doesnt work<br>
but its been fun anyway<br>
