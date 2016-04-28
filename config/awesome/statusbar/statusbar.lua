local battery = require("statusbar/batteryWidget")
local pacman = require("statusbar/pacmanWidget")
require("statusbar/volumeWidget")
local gdrive = require("statusbar/gdriveWidget")

function spacing(n)
    local text = ""
    for i=1, n do
        text = text .. " "
    end
    return seperator(text)
end

function seperator(text)
    local seperator = wibox.widget.textbox()
    seperator:set_markup("<span color=\"#333333\">" .. text .. "</span>")
    return seperator
end

function margin(widget, margin)
    if margin == nil then
        margin = 4
    end
    margin = wibox.layout.margin(widget, 0, 0, margin + 1, margin)
    return margin
end

-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 " }, s, layouts[1])
end

statusbar = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

local pacmanwidget = margin(pacman.widget(), 3)
local volumewidget = margin(volumeWidget(terminal), 6)
local batterywidget = margin(battery.widget(), 6)
local clockwidget = awful.widget.textclock()
local gdrivewidget = margin(gdrive.widget(), 2)

clockwidget:set_font("sans 9")

for s = 1, screen.count() do
    statusbar[s] = awful.wibox({ position = "bottom", screen = s, height = 38, opacity = beautiful.statusbar_opacity })

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(pacmanwidget)

        right_layout:add(spacing(9))
    right_layout:add(volumewidget)

        right_layout:add(spacing(9))
    right_layout:add(batterywidget)
        right_layout:add(spacing(8))

        right_layout:add(spacing(0))
    right_layout:add(gdrivewidget)

    if s == 1 then
        right_layout:add(wibox.widget.systray())
        right_layout:add(spacing(7))
    end

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_expand("none")

    layout:set_left(left_layout)
    layout:set_middle(clockwidget)
    layout:set_right(right_layout)

    statusbar[s]:set_widget(layout)
end

