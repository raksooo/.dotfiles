#!/bin/sh

function link {
	ln -sf $DOTFILES/config/$1 ~/$2
}

sudo -v

link bash_profile .bashprofile
link vimrc .vimrc
link xinitrc .xinitrc
link Xresources .Xresources
link Xresources_rofi .Xresources_rofi

link awesome .config/awesome
link liquidpromptrc .config/liquidpromptrc
link qutebrowser .config/qutebrowser
link user-dirs.dirs .config/user-dirs.dirs

link ssh .ssh/config

sudo ln -sf $DOTFILES/bin /usr/local/bin
ln -sf $DOTFILES/share ~/.local/share/rascal

