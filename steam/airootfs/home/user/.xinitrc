pulseaudio --kill
pulseaudio --start
setxkbmap gb
xrdb ~/.Xresources
conky | while read -r; do xsetroot -name "$REPLY"; done &
exec dwm
