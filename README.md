#READMAH
<br>
dont really know who jamie nguyen is but he clearly needs +1000 internetz<br>
no where near finished dont even know if i can blag this on a rebooted liveusb yet <br>
but ive wasted enough reading about openssl to questiion my own sanity its outright horrible<br>
i got pub/priv pki in about 5 minutes and wouldnt think twice about setting up gnupg to do exactly the same thing<br>
but openssl is just outright horrible and should be killed with fire lots and lots of fire <br>
but out of fear of having to re read all that shit again this is being backed up now<br>
will bend it to work on a rebootable usb tomorrow in thoery or slaughter thousands of cute puppys and kittens to make up for the rage of going through all that for no reason<br>
im pretty sure its not going to work unless i root sign on stick rng on tmpfs that hosts its own stuff but then serial collisions all signed the same meh heads battered<br>
<br>
erm...<br>
once makepkg works again... please? haha<br>
recompile dwm [home][0][1][2][3]... etc rule match surf to home tag<br>
mapping path home to surf -c /home/user/lighttpd/cookiez -i -n -p -s http://localhost:8080<br>
dumping ssl on once its bigger / moar stable<br>
input=$(cat /dev/stdin | tr -cd 'a-zA-Z0-9=[:space:]')<br>
it was nearly perfect but had to whitelist equals so using it for input kills variable assignment...<br>
would fail form commit checks bar create borked naming scheme but who call a container my=container anyway? stupid logic<br>
everything used to work now more and more things dont work...<br>
pacman spits out error codes ive never heard of and cant init alpm (tried grep error message on the entire source dir to find function name then grep the name + error to find where its being called but got nothing<br>
systemd-networkd randomly decides not to start... booting a static image rng dice roll... if it doesnt start systemctl restart systemd-networkd<br>
^ this is all with testing off now so :( someone decided to shit all over tmpfs<br>
worse case two usbs dd an ext4 image to one on every boot /shrug nothing more fun than burning through usbs<br>
<br>
but nothing works... so going to finish off a login system for a website + gnupg crypted relay / sort of want to blag my own mail server<br>
literally can container anything<br>
<br>
todoish - desktop<br>
udev symlink on boot not borked after boot...<br>
none root wifi<br>
none root default sound card<br>
strip desktop<br>
rbac<br>
<br>
todoish - minimal<br>
anything if makepkg worked ide call it an install stick with containers for testing...<br>
but it doesnt so currently it doesnt really do alot<br>
change terminal... well liez to lazy to manually compile dwm so cant change hotkeys :(<br>
fix the raw partition to ext4 raw blob and none root firstboot/oneshot<br>
<br>
todoish<br>
script creating the actual usb partition layout boot/keys/random seperate scripts incase pre existing...<br>
<br>
seriously going to just start blitzing usbs and dd the image / rootfs to a second stick on boot ext4<br>
only way i can actually test anything<br>
<br>
