---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font = "sans 7.5"
theme.wallpaper = "/home/rascal/.local/share/rascal/wallpaper.jpg"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal


theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#28496b"
theme.border_marked = "#91231c"

theme.taglist_bg_focus = "#C057A9"
theme.taglist_bg_occupied = "#714469"
theme.taglist_fg_focus = "#ffffff"
theme.taglist_fg_occupied = "#ffffff"
theme.taglist_fg_empty = theme.taglist_fg_occupied

theme.systray_icon_spacing = 5
theme.useless_gap = 15
theme.less_useless_gap = 2

theme.layout_tile = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_floating = "/usr/share/awesome/themes/zenburn/layouts/floating.png"
theme.layout_max = "/usr/share/awesome/themes/zenburn/layouts/max.png"

theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
