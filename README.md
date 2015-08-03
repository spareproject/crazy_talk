
todo<br>
fix the build script... still ignores mounts rng<br>
fix combine.sh<br>
create,map,boot,close - tidy up checkpoint<br>
container install script - defult checkpoint<br>
<br>
unionfs,killall,close-mkII - deal with the headache of input checking<br>
container install script unionfs - add stackable config dir & package list maybe multiple unionfs mounts<br>
<br>
fix tmpfs size in initramfs ( trim it and then anything that trys to edit the rootfs gets flagged going to work on getting full list of files + last edited to flag everything )<br>
sign everything in /boot with keys<br>
<br>
but probably wont be updated for a while <br>

right so....

macchanger was legacy stop bridges from setting the same mac address foo...
blank machine-id fixed it...
booted on a laptop for the first time in a million years
and the entire macchanger / add wifi to forwarding so containers work doesnt work... 
still leaving macchanger in because i gief zero fauks about mac addresses,
but i cant get containers to work so that needs fixing...

^ not eactly hard to fix but i dont leave the house enough to laptop derp

container install script mimic iso install as much as possible...

normal install still doesnt want to work... which is ironic because ive ran the exact same commands in order for every install ive ever done

that and the fact its worked everytime ive made an iso till i upload it then try it again epic




