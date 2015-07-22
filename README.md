so this was pretty short lived...
i cant maintain this in git without some huge irritating script to set chmod && chown on every directory and file in airootfs
currently just .gitignore rootfs and mount with terrabad none root user group read and write : / 

if i could edit archiso to do this i would but the bootloader foo still baffles me
i want to eject the usb after boot to play around with hotplugging gpg && gpg-agent cache

currently takes path to /dev/sdXYZ 
sdXYZ - being a vfat -F32 partition (efi + bios support)
could dump any other partition + filesystem next to it fill it with rootfs images and make a better bootloader menu or interactive menu in initramfs
basically if i actually had a use case other than general play could make it do whatever you want

still planning on dumping a root signing key
boot the usb random generates user + gnupg/ssh/sshd
plug and play root sign + a lan network discovery
either boot tmp with no networking or boot tmp sign the rng user and then network discovery
everythings pretty much dev mode as in its all going to be root while i play with it 
i want to just dump everything i had in archiso but going to build it up from scratch and recheck everything
^ want to dump a template config for all things systemd i like it /shrug and /careface if you dont
would do a minimal setup with grsec but im to much of an update whore and only ever seen grsec upgrade the kernel before core once in however many years ive been no-lifing this shit

overall goals...
boot sign and network discovery
lab setup with header node... (no use case but sounds fun) boot it multiple times toggle switch client / server node as a gateway with lan admin panel
crypted internal storage raw images + couple of wrapper scripts to ez mode systemd-nspawn + my minimal archiso setup as in what im used to /shrug

i dont really have any decent usecase or requirements its all based around whatever fits best for whatever i can get my hands on
^ once i loose my last bios mobo probably shrink it to efi only bootctl is amazing the first ever efi install i did was fucking horrible now its one cli command cant complain

but yeh need copious amounts of drugs and a week locked in a dark room to finish it or insert slow drawn out randomly updated proccess here

