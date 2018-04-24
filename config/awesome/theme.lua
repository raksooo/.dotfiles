local naughty = require("naughty")

local theme = {}
local font = "DejaVu Sans"

theme.transparent   = "#00000000"
theme.base_font     = font
theme.font          = font .. " 9"
theme.wallpaper     = os.getenv("HOME") .. "/.wallpapers/active.png"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_statusbar  = "#00000000"

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#444444"
theme.border_focus  = "#333333"
theme.border_marked = "#333333"
-- theme.border_width_floating = 8
-- theme.border_color_floating = "#da8c68"

theme.opacity_normal    = 0.85
theme.opacity_focus     = 1
theme.statusbar_opacity = 1

theme.taglist_bg_focus = "#ffffff48"
theme.taglist_bg_occupied = "#ffffff2a"
theme.taglist_bg_urgent = theme.taglist_bg_occupied
theme.taglist_fg_focus = theme.fg_statusbar
theme.taglist_fg_occupied = theme.taglist_fg_focus
theme.taglist_fg_empty = theme.taglist_fg_focus

theme.notification_width        = 600
theme.notification_height       = 130 + 20
theme.notification_border_width = 0
theme.notification_bg           = "#000000e5"
theme.notification_margin       = 20
theme.notification_opacity      = 0
theme.notification_font         = font .. " 12"

theme.systray_icon_spacing = 2
theme.useless_gap = 20
theme.less_useless_gap = 0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
