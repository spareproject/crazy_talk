#READMAH
once i can script format a usb it'll make more sense and have no manual parts...<br>
/dev/sda1 - vfat 1G<br>
/dev/sda2 - ext4 1G<br>
/dev/sda3 - ext4 -G #fill the rest<br>
mount /dev/sda3 ./mount<br>
dd if=/dev/random of= ./mount/raw bs=1024 count=5000000 #5G raw dump (liez apperently 977MB is a Gig)<br>
everything expects that partition layout without any constraints on size<br>
gnupg.sh requires /dev/sda3 to be setup properly<br>

i actually have a plan for once instead of winging it but some tard decided it was a good idea to butcher a tree with very loud machinery at 7:30 in the morning<br>
after i went to bed at 6 so my brain literally feels like its falling out my nose and i cant be fucked with doing any work<br>

but next plan... either fix the none working parts in desktop then do learning mode + pw fix(no idea how yet)<br>
or make a better template<br>

./build.sh --airootfs --packages --container --usb<br>
basically dump it so any structural changes can be applied to everything<br>
and then either squashfs or rawfs based containers with either usb bootloader or container bootloader<br>
or both but if im dumping the liveusb on the internet the point in encrypting the squashfs image seems pretty pointless<br>

dropping tor from minimal probably make a vpn bridge and go full on nginx/fcgiwrap as root shiny web interface for everything ive accumulated so far<br>
but thats pretty huge and theres still to much shit to fix but would mean less cli more shiny button idiot mode<br>
lan discovery and some form of remote throw up remote lan style but im tight and skint so...<br>
be hijacking whatever website i find thats stupid enough to let me write and read information<br>
then could just dump the sites auth creds in /dev/archiso2 and pull wan discovery on network enable /shrug<br>
^ random gen make new account per node and voting system headers or whatever i need to keep this up and hide from isps<br>
finding botnets must be a piece of piss unless your literally owning nodes that have come to you and storing data to use as oneshot it just sounds to easy to identify traffic and block<br>
basically its all getting to easy so it must be going well<br>
but seriously my heads going to explode 

