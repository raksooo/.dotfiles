local awful = require("awful")
local menubar = require("menubar")
require("layouts")

modkey = "Mod4"

function gotoTag(i)
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

    if move then
        awful.client.movetotag(tags[client.focus.screen][j])
    end
    gotoTag(j)
end

function moveFocus(n)
    awful.client.focus.byidx(n)
    if client.focus then
        client.focus:raise()
    end
end

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "j", function() navigate("j") end),
    awful.key({ modkey,           }, "k", function() navigate("k") end),
    awful.key({ modkey,           }, "h", function() navigate("h") end),
    awful.key({ modkey,           }, "l", function() navigate("l") end),
	awful.key({ "Mod1", 		  }, "j", function () navigate("j", true) end),
    awful.key({ "Mod1",           }, "k", function () navigate("k", true) end),
	awful.key({ "Mod1", 		  }, "h", function () navigate("h", true) end),
    awful.key({ "Mod1",           }, "l", function () navigate("l", true) end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey, "Shift"   }, "j", function () moveFocus(1) end),
    awful.key({ modkey, "Shift"   }, "k", function () moveFocus(-1) end),
    awful.key({ "Control",        }, "j", function () awful.client.swap.byidx(1) end),
    awful.key({ "Control",        }, "k", function () awful.client.swap.byidx(-1) end),

    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift"   }, ".", function () awful.tag.incnmaster( 1) end),
    awful.key({ modkey, "Shift"   }, ",", function () awful.tag.incnmaster(-1) end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(webbrowser) end),
    awful.key({ modkey,           }, "space", function () awful.util.spawn(launcher) end),
    awful.key({ "Mod1",           }, "space", function () awful.util.spawn("slock") end),
    awful.key({ modkey,           }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore)

    --[[
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    -- Prompt
    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
    --]]
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n", function (c) c.minimized = true end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ "Mod1",           }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end