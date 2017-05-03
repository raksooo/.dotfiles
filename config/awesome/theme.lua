local naughty = require("naughty")

local theme = {}

theme.font          = "DejaVu Sans 9"
theme.wallpaper     = function(t)
    return "/home/oskar/.wallpapers/active/" ..t .. ".png"
end

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_statusbar  = "#00000000"

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 20
theme.border_width  = 0
theme.border_normal = "#444444"
theme.border_focus  = "#333333"
theme.border_marked = "#333333"
theme.border_width_floating = 8
theme.border_color_floating = "#da8c68"

theme.opacity_normal    = 0.85
theme.opacity_focus     = 1
theme.statusbar_opacity = 1

theme.taglist_bg_focus = "#ffffff50"
theme.taglist_bg_occupied = "#ffffff30"
theme.taglist_bg_urgent = "#ff000030"
theme.taglist_fg_focus = theme.fg_statusbar
theme.taglist_fg_occupied = theme.taglist_fg_focus
theme.taglist_fg_empty = theme.taglist_fg_focus

theme.naughty_width        = 250
theme.naughty_height       = 60
theme.naughty_icon_size    = 100
theme.naughty_margin       = 10
theme.naughty_border_width = 1
theme.naughty_border_color = "#268bd2"

theme.systray_icon_spacing = 2
theme.useless_gap = 19
theme.less_useless_gap = 0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
