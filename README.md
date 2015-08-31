#READMAH
<br>
apperently i forgot to hash the cookie with incoming ip and used a persistent file fail moa7<br>
<br>
lighttpd cant read /tmp... not annoying at all so now /home/user gets all the directories involving keys and key setup<br>
even tho im only removing the contents of /home/user/persistent it decides to delete the directory and i cant for the life of me reproduce that so wtf?<br>
<br>
i need to trim some fat off the entire thing or atleast document the current setup and what each part effects<br>
its getting to the point i couldnt easily explain it to much crap everywhere and overkill complex dir structures <br>
^ i still blame openssl and do quite generally detest everything about it, overly complex for a piss easy task<br>
<br>
systemd still randomly decides what starts on boot such stable much predict very wow<br>
<br>
every now and again ill boot and combine doesnt copy udev rules over...<br>
<br>
sort of messed up with the ability to use a web interface<br>
going to edit oneshot to take timelimit as an input and edit /home/user/persistent/gpg-agent.sh and the sleep clean up background<br>
plug the stick in refresh container.sh oneshot + submit to enter a pin and cache gnupg directory<br>
having to re authenticate every 60 seconds to actually do anything... seems a tad inconvenient<br>
<br>
i only really enjoy building authentication mechanism and stuff so total lack of motivation to make a gui<br>
dont need a database for containers its live filesystem scrape for a database<br>
fixing the fuck ups of not being able to decrypt rawfs on a remote target over the webserver is going to be a pain<br>
basically ide rather just build up the webserver directory to real world usable dump everything ive learnt into it and keep it stupidly simple<br>
<br>
random notes for me...(things that if fixed would help me sleep at night)<br>
udev symlink...<br>
webpanel unencrypting rawfs remotely...<br>
 -r /any/directory/ - deleting the directory in one use case only...<br>
start some loopage to scatter the 100 char pass over the 5G random image<br>
add trap to firstboot oneshot to clean up if the script is killed... to hard and annoying to debug<br>
<br>
should dump lan ssh and sshd first < - could blag persistent gnupg cache mount local call browser... nah basically no point in remote <br>

