local naughty = require("naughty")

local theme = {}
local font = "FiraCode Light"

theme.transparent   = "#00000000"
theme.base_font     = font
theme.font          = font .. " 9"
theme.wallpaper     = os.getenv("HOME") .. "/.config/wallpaper.png"

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
theme.border_normal = "#282828"

--theme.opacity_normal    = 0.85
--theme.opacity_focus     = 1
theme.statusbar_opacity = 1

theme.taglist_bg_focus = "#ffffff48"
theme.taglist_bg_occupied = "#ffffff2a"
theme.taglist_bg_urgent = theme.taglist_bg_occupied
theme.taglist_fg_focus = theme.fg_statusbar
theme.taglist_fg_occupied = theme.taglist_fg_focus
theme.taglist_fg_empty = theme.taglist_fg_focus

theme.notification_opacity = 0
theme.notification_width = 1

theme.systray_icon_spacing = 2
theme.useless_gap = 0
theme.less_useless_gap = 0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
