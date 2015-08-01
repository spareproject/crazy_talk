###############################################################################################################################################################################################################

erm so yeh...

its pretty much a cheap throw up with little to no proof reading or testing

and these docs are crazy detailed 

just going to run it and patch updates as things fall off

pushing for internal storage but not saving shit till i get atleast a month of stable use out of it

firstboot takes pin dumps public keys (all of them) signs random generated, auto tidy up and pull

oneshot takes pin dumps user gnupg into /tmp with 60 second gpg-agent and 63 second auto delete

^ its root only mostly because i cant nspawn without root can fstab none root and block root sign with perms...

did have some stupidly long script that checked a load of user input...
gutting it and leaving boot, unionfs, create, map  
probably need a delete but... not writing any scripts that delete things therefore when you format or dd the wrong /dev/sd... tab tab shit mode its all on you :)

basically...<br />
gdisk /dev/sdX <br />
1G ef00 partition vfat -F32<br />
1G 8300 partition ext4<br />
+G 8300 partition dd if=/dev/random (literally takes hours 64G usb stick would not be a good idea)<br />
persistent partitions even a overlay mount to persist packages / setup is terrabad on usb/sdcard ro or gtfo was always my way of thinking<br />

will install nvidia to steam if someone buys a nvidia gpu else nope cant test blind

###############################################################################################################################################################################################################
