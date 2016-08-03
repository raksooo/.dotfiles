require("statusbar/volumeWidget")

beautiful.init("/home/rascal/.config/awesome/theme.lua")

modkey = "Mod4"

function gotoTag(i, move)
    if move then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        awful.client.movetotag(tag)
    end

    local screen = mouse.screen
    local tag = awful.tag.gettags(screen)[i]
    if tag then
        awful.tag.viewonly(tag)
    end
end

function navigate(key, move)
    local i = awful.tag.getidx() - 1
    action = {
        ["j"] = (i + 3) % 6 + 1,
        ["k"] = (i - 3) % 6 + 1,
        ["h"] = (math.ceil((i + 1) / 3) - 1) * 3 + ((i - 1) % 3) + 1,
        ["l"] = (math.ceil((i + 1) / 3) - 1) * 3 + ((i + 1) % 3) + 1,
    }
    local j = action[key]

    gotoTag(j, move)
end

function moveFocus(n)
    awful.client.focus.byidx(n)
    if client.focus then
        client.focus:raise()
    end
end

function toggleGap()
    if awful.tag.getgap() == beautiful.useless_gap then
        awful.tag.setgap(beautiful.less_useless_gap)
    else
        awful.tag.setgap(beautiful.useless_gap)
    end
end

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "j", curry(navigate, "j")),
    awful.key({ modkey,           }, "k", curry(navigate, "k")),
    awful.key({ modkey,           }, "h", curry(navigate, "h")),
    awful.key({ modkey,           }, "l", curry(navigate, "l")),
	awful.key({ "Mod1", 		  }, "j", curry(navigate, "j", true)),
    awful.key({ "Mod1",           }, "k", curry(navigate, "k", true)),
	awful.key({ "Mod1", 		  }, "h", curry(navigate, "h", true)),
    awful.key({ "Mod1",           }, "l", curry(navigate, "l", true)),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey, "Shift"   }, "j", curry(moveFocus, 1)),
    awful.key({ modkey, "Shift"   }, "k", curry(moveFocus, -1)),
    awful.key({ "Control",        }, "j", curry(awful.client.swap.byidx, 1)),
    awful.key({ "Control",        }, "k", curry(awful.client.swap.byidx, -1)),

    awful.key({ modkey, "Shift"   }, "l", curry(awful.tag.incmwfact,  0.05)),
    awful.key({ modkey, "Shift"   }, "h", curry(awful.tag.incmwfact, -0.05)),
    awful.key({ modkey, "Shift"   }, ".", curry(awful.tag.incnmaster,  1)),
    awful.key({ modkey, "Shift"   }, ",", curry(awful.tag.incnmaster, -1)),

    awful.key({ modkey, "Control" }, "j", curry(awful.screen.focus_relative,  1)),
    awful.key({ modkey,           }, "o", curry(awful.screen.focus_relative,  1)),
    awful.key({ modkey, "Control" }, "k", curry(awful.screen.focus_relative, -1)),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,	          }, "z", function()
            drop(terminal, "top", "center", 1, 0.35)
        end),
    awful.key({ modkey,	          }, "x", function()
            drop(messenger, "top", "right", 0.25, 1)
        end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "space", curry(awful.layout.inc, layouts, 1)),
    awful.key({ modkey, "Shift"   }, "n", awful.client.restore),
    awful.key({ modkey, "Shift"   }, "m", toggleGap)
)

clientkeys = awful.util.table.join(
    awful.key({ "Mod1",           }, "o",  function (c) c:move_to_screen() end),
    awful.key({ modkey,           }, "f", function(c)
            c.fullscreen = not c.fullscreen
        end),
    awful.key({ modkey, "Shift"   }, "c", function(c) c:kill() end),
    awful.key({ modkey,           }, "w", function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end),
    awful.key({ modkey,           }, "n", function(c) c.minimized = true end),
    awful.key({ modkey,           }, "m", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Control" }, "h", function(c)
            awful.client.movetoscreen(c, c.screen - 1)
        end),
    awful.key({ modkey, "Control" }, "l", function(c)
            awful.client.movetoscreen(c, c.screen + 1)
        end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, curry(gotoTag, i)),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
        end),
        -- Move client to tag.
        awful.key({ "Mod1",           }, "#" .. i + 9, curry(gotoTag, i, true)),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = awful.tag.gettags(client.focus.screen)[i]
                if tag then
                    awful.client.toggletag(tag)
                end
            end
        end))
end

root.keys(globalkeys)

