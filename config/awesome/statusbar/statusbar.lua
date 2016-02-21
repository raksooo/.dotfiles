local awful = require("awful")
local wibox = require("wibox")
local tools = require("../tools")

require("statusbar/batteryWidget")
require("statusbar/pacmanWidget")
require("statusbar/volumeWidget")
require("statusbar/gdriveWidget")
require("statusbar/weatherWidget")
require("statusbar/etherWidget")

-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 " }, s, layouts[1])
end

statusbar = {}
mypromptbox = {}
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

local pacmanwidget = margin(pacmanWidget(), 2)
local weatherwidget = weatherWidget()
local volumewidget = volumeWidget(terminal)
local batterywidget = margin(batteryWidget())
local clockwidget = awful.widget.textclock()
local gdrivewidget = margin(gdriveWidget(), 2)
local etherwidget = etherWidget()

for s = 1, screen.count() do
    statusbar[s] = awful.wibox({ position = "bottom", screen = s, height = 20, opacity = 0.85 })

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(tools.bigspacing)
    left_layout:add(mypromptbox[s])
    left_layout:add(tools.spacing)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(pacmanwidget)

        right_layout:add(tools.seperator)
    right_layout:add(etherwidget)

        right_layout:add(tools.seperator)
    right_layout:add(weatherwidget)

        right_layout:add(tools.seperator)
    right_layout:add(volumewidget)

        right_layout:add(tools.seperator)
    right_layout:add(batterywidget)

        right_layout:add(tools.seperator)
    right_layout:add(clockwidget)

        right_layout:add(tools.newSeperator("   |"))
    right_layout:add(gdrivewidget)

    if s == 1 then
        right_layout:add(wibox.widget.systray())
        right_layout:add(tools.bigspacing)
    end

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    -- layout:set_middle(mytextclock)
    layout:set_right(right_layout)

    statusbar[s]:set_widget(layout)
end
