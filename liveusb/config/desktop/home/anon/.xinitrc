setxkbmap gb
(conky -c /home/anon/.config/conkyrc|while read -r;do xsetroot -name "$REPLY";done &)&
exec dwm
