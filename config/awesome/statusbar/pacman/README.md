# Awesome pacman widget
A widget for awesome wm which shows the numer of pacman updates as dots in front of a pacman icon.
<img src="screenshot.png" />

## Download
```bash
git clone https://github.com/raksooo/pacmanwidget.git ~/.config/awesome/pacman
```

## Usage
```lua
pacman = require("statusbar.pacman")
local widget = pacman.create(<opacity>)
```
And then add the widget to your wibar.

## Pacman hook
```bash
sed -i "s/<user>/$USER/" pacmanWidget.hook
cp pacmanWidget.hook /etc/pacman.d/hooks/
```

