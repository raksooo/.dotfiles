#!/bin/sh

function link {
	ln -sf $DOTFILES/config/$1 ~/$2
}

sudo -v

link bash_profile .bash_profile
link vimrc .vimrc
link xinitrc .xinitrc
link Xresources .Xresources
link Xresources_rofi .Xresources_rofi

link awesome .config/
link liquidpromptrc .config/
link qutebrowser .config/
link user-dirs.dirs .config/

link ssh .ssh/config

sudo ln -sf $DOTFILES/bin /usr/local/
ln -s $DOTFILES/share ~/.local/share/rascal

