#!/bin/sh

# Caps as escape
setxkbmap se -option 'lv3:caps_switch'
xcape -e 'ISO_Level3_Shift=Escape'

# No dead keys
setxkbmap se -variant nodeadkeys

# Xmodmap
[[ -f ~/.dotfiles/Xmodmap ]] && xmodmap ~/.dotfiles/Xmodmap

# Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f $DOTFILES/Xresources/Xresources_rofi ]] && xrdb -merge -I$HOME $DOTFILES/Xresources/Xresources_rofi
[[ -f $DOTFILES/Xresources/Xresources_theme ]] && xrdb -merge -I$HOME $DOTFILES/Xresources/Xresources_theme

# Autostart
xss-lock -l -- lock &
unclutter -keystroke -idle 1 &
redshift 57.716015:11.871436 &
compton -b --no-fading-openclose -c -t-0 -l-0 -o.0
sxhkd &

# Autostart applications
termite &
termite &
firefox &

# Start awesome
exec awesome

