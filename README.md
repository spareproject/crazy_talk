#READMAH
desktop<br>
not in anyway stable : /<br>
trying to dump a learning mode run in policy and rbac.service to start on boot<br>
^^ not generating learning mode in a safe environment so still sketchy<br>
/etc/grsec/pw is min length 6 chars... some weird binary hash i cant find anything about<br>
plan is dump policy on at boot gradm.service<br>
have a random max length password dump in pw <br>
no way to turn it off<br>
no passwords means no role auth... so its default only and user roles<br>
<br>
but wifi... short version<br>
iwlist... fucked displays like 3 networks doesnt display my own network<br>
wpa_cli... fucked displays like 3 networks (scan) doesnt display my own network<br>
airodump... works shows everything with loads of sexy output... <br>
even wifi-menu netctl + dhcpcd which works... but keeps telling me the interface is already up even tho output said it was down...<br>
so wifis probably going to be a pain<br>
<br>
erm two users tty1 still has sudo debug / setup <br>
tty2 - anon (probably not anon) i have epic naming skillz but bob was a bit weird <br>
forwards all traffic anon generates through tor transport and tordns<br>
^ had to drop dnscrypt-proxy if etc/resolv is 127.0.0.1 it ignores dns redirect and pulls from dnscrypt so sketchy as f00k dns leaks mode ftw<br>
<br>
/home/watch and /home/torrents used to dump between both accounts ssh is no where near done aiming for none root mount archiso2 symlink<br>
root owned signing key, user owned persistsent key random boot key... but two users... ssh on one both through tor normal<br>
<br>
should really pull a stable template...<br>
everything needed to generate a bios/efi bootable usb with squashfs to tmpfs on boot then gnupg hotplug for internal storage<br>
<br>
everythings getting out of sync and getting annoying <br>
temped to pull it all start fresh so i can recheck everything : / but it works in theory<br>

