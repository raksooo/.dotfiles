#!/bin/sh

DOTFILES=$HOME/.dotfiles

function link {
	ln -sf $DOTFILES/config/$1 ~/$2
}

sudo -v

link zshrc .zshrc
link tmux.conf .tmux.conf
link xinitrc .xinitrc
link Xmodmap .Xmodmap
link Xresources/Xresources .Xresources
link Xresources/Xresources_rofi .Xresources_rofi
link Xresources/Xresources_quantum .Xresources_theme
link gitconfig .gitconfig

link awesome .config/
link liquidpromptrc .config/
link liquidprompt .config/
link qutebrowser .config/
link sxhkd .config/
link pacaur .config/
link gtk/* .config/
link user-dirs.dirs .config/

mkdir ~/.config/nvim
link nvim .config/nvim/init.vim

sudo ln -sf $DOTFILES/config/gtk/gtk-2.0/gtkrc /etc/gtk-2.0/
sudo ln -sf $DOTFILES/config/gtk/gtk-3.0/settings.ini /etc/gtk-3.0/

git clone git@oskarnyberg.com:dotfiles/wallpapers.git ~/.wallpapers
git clone git@oskarnyberg.com:dotfiles/share.git ~/.local/share/oskar
git clone git@oskarnyberg.com:dotfiles/bin.git ~/.local/bin
sudo ln -sf ~/.local/bin /usr/local/

git clone git@oskarnyberg.com:dotfiles/moredotfiles.git ~/.moredotfiles
if [ -f ~/.moredotfiles/setup.sh ]; then
  cd ~/.moredotfiles/setup.sh
fi

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xresources_rofi
xrdb -merge ~/.Xresources_theme

