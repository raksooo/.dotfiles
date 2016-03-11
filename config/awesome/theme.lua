---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font = "sans 7.5"
theme.wallpaper = "/home/rascal/.local/share/rascal/wallpaper.png"

theme.bg_normal     = "#002b36"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#93a1a1"
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#28496b"
theme.border_marked = "#91231c"

theme.opacity_normal    = 0.85
theme.opacity_focus     = 1
theme.statusbar_opacity = 1

theme.taglist_bg_focus = "#268bd2"
theme.taglist_bg_occupied = "#d33682"
theme.taglist_bg_urgent = "#dc322f"
theme.taglist_fg_focus = "#eee8d5"
theme.taglist_fg_occupied = theme.taglist_fg_focus
theme.taglist_fg_empty = theme.taglist_fg_focus

theme.naughty_width        = 250
theme.naughty_height       = 60
theme.naughty_icon_size    = 60
theme.naughty_margin       = 10
theme.naughty_border_width = 1
theme.naughty_border_color = "#268bd2"

theme.systray_icon_spacing = 2
theme.useless_gap = 15
theme.less_useless_gap = 1

theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
