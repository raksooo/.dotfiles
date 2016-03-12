#!/bin/sh

function link {
	ln -sf $DOTFILES/config/$1 ~/$2
}

sudo -v

link bash_profile .bash_profile
link vimrc .vimrc
link xinitrc .xinitrc
link Xmodmap .Xmodmap
link Xresources/Xresources .Xresources
link Xresources/Xresources_rofi .Xresources_rofi
link Xresources/Xresources_solarized .Xresources_theme
link gitconfig .gitconfig

link awesome .config/
link liquidpromptrc .config/
link qutebrowser .config/
link sxhkd .config/
link pacaur .config/
link gtk/* .config/
link user-dirs.dirs .config/

link ssh .ssh/config

sudo ln -sf $DOTFILES/bin /usr/local/
if [ ! -s ~/.local/share/rascal ]; then
    ln -s $DOTFILES/share ~/.local/share/rascal
fi

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xresources_rofi
xrdb -merge ~/.Xresources_theme

