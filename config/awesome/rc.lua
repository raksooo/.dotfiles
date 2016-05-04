-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
wibox = require("wibox")

-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
vicious = require("vicious")

tools = require("tools")
asyncshell = require("asyncshell")
drop  = require("scratchdrop")

require("layouts")
require("keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/oskar/.config/awesome/theme.lua")

--naughty.config.defaults.height       = beautiful.naughty_height
--naughty.config.defaults.width        = beautiful.naughty_width
naughty.config.defaults.icon_size    = beautiful.naughty_icon_size
naughty.config.defaults.margin       = beautiful.naughty_margin
naughty.config.defaults.border_width = beautiful.naughty_border_width
naughty.config.defaults.border_color = beautiful.naughty_border_color

function awful.tag.getgap(t)
    t = t or awful.tag.selected()
    return awful.tag.getproperty(t, "useless_gap") or beautiful.useless_gap or 0
end

-- This is used later as the default terminal and editor to run.
terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
webbrowser = "qutebrowser"
messenger  = "messenger"
-- }}}

local possibleProgs = {
    urxvt     = "URxvt",
    messenger = "http___messenger_com"
}
tools.setTimeout(function()
    dropinit(possibleProgs)
end, 0.1)

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Statusbar
require("statusbar/statusbar")
-- }}}

-- {{{ Key bindings
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
function mpvStart(c)
    local tag = c:tags()[1]
    if (tag == tags[1][1] or tag == tags[1][4]) and client.focus then
        c:tags({ tags[1][1], tags[1][4] })
        if awful.tag.getnmaster(tags[1][1]) == 1 then
            awful.tag.incnmaster(1, tags[1][1])
            c:connect_signal("unmanage", function()
                awful.tag.incnmaster(-1, tags[1][1])
            end)
        end
    end
end

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_color,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     raise = true,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[1][9] } },
    { rule = { class = "qutebrowser" },
      properties = { tag = tags[1][4] },
      callback = awful.client.setslave },
    { rule = { class = "chromium" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "mpv" },
      callback = mpvStart },
}
-- }}}

tag.connect_signal("property::selected", function(t)
    local n = tonumber(t.name)
    if t.selected then
        if n == 1 then
            os.execute("toggleTrackpad 0")
        elseif n == 2 then
            os.execute("toggleTrackpad 1")
        end
    else
        if n == 2 then
            os.execute("toggleTrackpad 0")
        end
    end
end)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if c.class == "mpv" then
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end

    if not startup and not c.size_hints.user_position
            and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c)
    if c.class == "URxvt" then
        c.opacity = 0.96
    else
        c.opacity = beautiful.opacity_focus
    end
    c.border_color = beautiful.border_focus

    if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = "0"
    else
            c.border_width = beautiful.border_width
    end
end)
client.connect_signal("unfocus", function(c)
    if c.class ~= "mpv" then
        c.opacity = beautiful.opacity_normal
    end
    c.border_color = beautiful.border_normal
    c.border_width = beautiful.border_width
end)
-- }}}

