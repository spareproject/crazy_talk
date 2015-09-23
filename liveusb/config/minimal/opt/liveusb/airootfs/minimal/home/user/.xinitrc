setxkbmap gb
(conky -c /home/user/.config/conkyrc|while read -r;do xsetroot -name "$REPLY";done)&
exec dwm
