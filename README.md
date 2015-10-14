#READMAH
<br>
new grsec... wont even boot : /<br>
<br>
i know the entire point of a plug and play usb is to plug and play it... but leave it in<br>
someone blatenly switched out the syslinux mbr and dumped all things nasty in it<br>
the stealth was epic considering it spews out garabage all over boot screen<br>
and im pretty sure if your firmwaring keyboards or if its part of the bootloader blob<br>
you should really test the output when you leave a tty open without starting x.... /sigh<br>
<br>
i get owned fucking loads because im clearly so popular but your stealth is terra bad and just starting to piss me off<br>
<br>
so getting slightly bored havent done anything usefull for awhile...<br>
<br>
going to write a script to hide messages against a binary blob<br>
more specifically the binary blob in /dev/sdX3<br>
<br>
./execute - random skip/seek dd takes whatever input you give it and generates a random numeric<br>
remember the skip/seek and keep the numeric <br>
./execute asks for insert point and file then calculate the message...<br>
also going to look at dumping cryptsetup maps to use as salt<br>
<br>
not exactly useful... but i have a giant binary blob and its only holding 100 chars<br>
plus itll be easy to write and the actual 'salt' for the binary blob to store data is pretty much going to have to happen<br>
^ if that even works if luks keyfile doesnt provide different maps ill have to find something else<br>
<br>
if when i got back all this stuff still worked i would have left the tmp key fails but im dumping timestamps in it /shrug<br>
^ and considering every form of authentication ive seen on the net relies on timestamps why people trust setting over the network is beyond me : /<br>
<br>
every default cookie cutter login / auth web based foo i ever learned was based on single user / single device login and single account<br>
every fucking account i own is now apperently expected to have persistent access from a load of different devices  <br>
this is pissing me off enough to actually pull my finger out and do some work : / pfft<br>
<br>
but really need a cookie cutter single user multiple device authentication method and account management<br>
its just pissing me off far to much<br>
<br>
as in single account multiple logins that are actually tracked and give 2 factor auth... 2nd account... or pki access to the control list<br>
someone gets it and all the shiny alarm bells go off <br>
<br>
not a one cookie to rule them all fail <br>
<br>
^ going to start it all in bash its more theory than teh bestest web language out there... and just nest it after the sucky bruteforcable implementation in this repo<br>
<br>
<br>
<br>
<br>
