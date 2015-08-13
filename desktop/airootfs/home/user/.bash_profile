
umask 077
gpg --homedir /home/user/gnupg --batch --gen-key /etc/gnupg/batch.user
gpg --homedir /home/user/gnupg --output /home/user/user.public --export user
ssh-keygen -t rsa -b 4096 -f "/home/user/ssh/id_rsa" -N ""
ssh-keygen -t rsa -b 4096 -f "/home/user/sshd/ssh_host_rsa_key" -N ""
gpg --homedir /home/user/gnupg -e /home/user/ssh/id_rsa;rm /home/user/ssh/id_rsa
gpg --homedir /home/user/gnupg -e /home/user/sshd/ssh_host_rsa_key;rm /home/user/sshd/ssh_host_rsa_key
pkill gpg-agent

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

