#READMAH
and it doesnt work anymore...<br>
so apperently systemd-networkd doesnt like me any more...<br>
<br>
dont really want llmnr or lldp<br>
loads of sucky bash scripts with netcat and gnupg...<br>
totally kills the validity of this as been usable<br>
but can template all the server/client setups i need<br>
wont be that complex or big , easy to explain demo and show some simple shit<br>
but systemd-networkd apperently hates me now and wont do shit : / <br>
careface<br>
basically its db in /mnt/container with ip addr on boot time because wtf?<br>
im pretty sure i posted yesterday im not investing any time in this because it breaks everytime i do anything and its already fucked so gg<br>
dont even know what updated systemd-networkds the same version that it worked for so /shrug who knows<br>
<br>
plan was debug and build it in containers but can still host to host the entire protocol with bash nc/gpg<br>
^ still be pretty easy to do the network signed checks throw up a revoke check etc etc...<br>
top level needs a root and revoke key all lower levels can use meta data... provided you can hop up a level to revoke<br>
<br>
so wtf pointless upload that actually breaks everything gratz<br>
<br>
Could not create runtime directory 'lldp': No such file or directory<br>
: host0: Failed to save link data to /run/systemd/netif/links/2: No such file or directory<br>
: host0: Could not start IPv6 router discovery: Address family not supported by protocol<br>
: Could not add new link: Address family not supported by protocol<br>
: lo: Failed to save link data to /run/systemd/netif/links/1: No such file or directory<br>
: lo: Failed to save link data to /run/systemd/netif/links/1: No such file or directory<br>
: lo: Failed to save link data to /run/systemd/netif/links/1: No such file or directory<br>
: Enumeration completed<br>
: Started Network Service.<br>
: host0: Failed to save link data to /run/systemd/netif/links/2: No such file or directory<br>
<br>
