###############################################################################################################################################################################################################
things that still take a massive dump all over ramfs...
.
.
.
^ then better mount size 

sections...
rootfs / bootfs
cant bootctl without a partition
cant syslinux without rootfs ( got installed / rootfs new conflicts at one point + means it lags with updates cant pull new on first build)
^ to lazy to pacman -W

can recover old rootfs... < - dumping gpg into initramfs totally wrong place
signing shit with root key in boot
gpg keyring in initramfs needs pub ah fucking socket lulz gpg into tmpfs 

init sign vs boot sign

toggle 
like the point in booting unplugging and replugging to sign is fail...
initramfs all the things + interactive prompt
sshd sign gnupg sign
^ need revoke / timeout / multiple checks... single node per key gen if key moves to another node while up revoke it 
key lost fuck off and die mode arent any work arounds or dos, owned enough to steal key + network access kill it
means persistent access to proxy through the node or gtfo off the network...


###############################################################################################################################################################################################################
