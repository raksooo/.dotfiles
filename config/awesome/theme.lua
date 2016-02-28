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

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#28496b"
theme.border_marked = "#91231c"

theme.opacity_normal    = 0.85
theme.opacity_focus     = 1
theme.statusbar_opacity = 0.95

theme.taglist_bg_focus = "#d33682"
theme.taglist_bg_occupied = "#268bd2"
theme.taglist_bg_urgent = "#dc322f"
theme.taglist_fg_focus = "#ffffff"
theme.taglist_fg_occupied = "#ffffff"
theme.taglist_fg_empty = theme.taglist_fg_occupied

theme.naughty_width        = 250
theme.naughty_height       = 60
theme.naughty_margin       = 10
theme.naughty_border_width = 1
theme.naughty_border_color = "#268bd2"

theme.systray_icon_spacing = 2
theme.useless_gap = 15
theme.less_useless_gap = 2

theme.layout_tile = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_floating = "/usr/share/awesome/themes/zenburn/layouts/floating.png"
theme.layout_max = "/usr/share/awesome/themes/zenburn/layouts/max.png"

theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/zenburn/titlebar/close_normal.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_inactive.png"

theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
