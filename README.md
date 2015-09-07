#READMAH
<br>
well it looks like it works...<br>
<br>
havent actually tested everything some random parts that dont make much sense<br>
so close only takes a rawfs name cant close a unionfs boot<br>
prompts to kill all the unionfs booted rawfs instances or does nothing<br>
<br>
can stop a unionfs image<br>
manually umount i suppose<br>
<br>
i need to actually use it more to edit functionality and ease of use<br>
<br>
need a path usable ./build.sh for containers but no idea cant use install<br>
<br>
but it all works pretty easily<br>
boot run firstboot sign all the things etc<br>
oneshot open a load of rawfs my_unionfs < - dat name doe<br>
can boot the same default multiple times (need it to test software really but unionfs is terra insecure and all round sketchy as fuck)<br>
start on host container or proxy (probably drop tor and setup a vpn ? /shrug tors free )<br>

but totally gutting iptables and checking it if i do an nftables switch<br>
^ mostly want a filter table for input / output at the host level for the nat range<br>
so can still firewall the container but hard enforce rules from host regardless<br>
at the minute its a total cluster fuck that works but doesnt really do much<br>

rdp 10.0.0.2 13 - probably should check you arent running it as root....<br>
boots xephyr screen is set to my 1920x1080 default... custom dwm with windows key instead of alt (takes getting used to i keep trying to close a window and hard killing it : /)<br>
<br>
erm its still a total terrabad mess but bit tlc and its pretty usefull<br>
im pretty sure i had this at just over 350mb on archiso and its currently htting 430mb squash so erm<br>
<br>
i havent got portknocks setup could easily set up first boot to netcat a timestamped rotate with the persistent key...<br>
but may as well go nftables (doesnt have knocks) wouldnt host anything wan facing without a knock<br>
<br>
i need to adapt pretty much every firewall i have to handle massscan lulz but it isnt that hard with a portknock<br>
^ nothing would hit the recent hitcount or soft stacking block without a key<br>
<br>
if anyones actually interested in making a ham pi 5 mile public wifi proxy msg me sounds ez<br>
^ sending crypted packets is like totally illegal an shit<br>
and the first time i ever searched radio google only gave me a wiki page with <br>
every nation reseres the right to defend its airwaves with military force so should be pretty funny anyway<br>
currently easy at < £100 with stuff you can probably pick up cash in hand or atleast can in my target area<br>
<br>
ive been looking at making a return flight path for drones that are rfjammed turns out it would be ez to guesstimate<br>
as in theortically possible within a degree of accuracy with about 5 minutes worth of caring about it<br>
pretty much already know how to do it more down to the resources needed to calculate it and something 3d printed to measure windspeed<br>
break it down into smaller parts and it gets pretty viable pretty quick<br>
^ that way no one can steal your murder drone as it slaughters anything with a heat signature :D<br>
<br>
dont really know what to do next : / <br>
i keep saying ill tidy this or finish it but itll never be finished everything changes to quickly and im pretty sure im just pushing a boulder up a hill <br>
probably tidy it dump a last version then care less and do other things like your mom<br>
<br>
sleep and stuff... clearly need it i seriously never proof read any of this and normally just talk loads of shit stop being so serious<br>
<br>
<br>
