local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local super = "Mod4"
local alt = "Mod1"
local control = "Control"
local shift = "Shift"

function curry(f, a, b, c, d, e)
    return function () return f(a, b, c, d, e) end
end

function bind(obj, f, a, b, c, d, e)
    return function () return obj:f(a, b, c, d, e) end
end

function gotoTag(i, move)
    if move then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        awful.client.movetotag(tag)
    end

    local tag = awful.screen.focused().tags[i]
    if tag then tag:view_only() end
end

function grid(direction, move)
    local rows = 2
    local columns = 3

    local i = awful.screen.focused().selected_tag.index - 1
    action = {
        ["down"] = (i + columns) % (rows * columns) + 1,
        ["up"] = (i - columns) % (rows * columns) + 1,
        ["left"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i - 1) % columns) + 1,
        ["right"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i + 1) % columns) + 1,
    }
    local j = action[direction]

    gotoTag(j, move)
end

globalkeys = awful.util.table.join(
    awful.key({ control }, "+", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ super }, "j", curry(grid, "down", false),
              {description = "view tag below current", group = "tag"}),
    awful.key({ super }, "k", curry(grid, "up", false),
              {description = "view tag above current", group = "tag"}),
    awful.key({ super }, "h", curry(grid, "left", false),
              {description = "view tag left of current", group = "tag"}),
    awful.key({ super }, "l", curry(grid, "right", false),
              {description = "view tag right of current", group = "tag"}),
    awful.key({ alt }, "j", curry(grid, "down", true),
              {description = "move client to the tag below", group = "client"}),
    awful.key({ alt }, "k", curry(grid, "up", true),
              {description = "move client to the tag above", group = "client"}),
    awful.key({ alt }, "h", curry(grid, "left", true),
              {description = "move client to the tag to the left", group = "client"}),
    awful.key({ alt }, "l", curry(grid, "right", true),
              {description = "move client to the tag to the right", group = "client"}),

    awful.key({ super }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ super, shift }, "j", curry(awful.client.focus.byidx, 1),
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ super, shift }, "k", curry(awful.client.focus.byidx, -1),
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ control }, "j", curry(awful.client.swap.byidx, 1),
              {description = "swap with next client by index", group = "client"}),
    awful.key({ control }, "k", curry(awful.client.swap.byidx, -1),
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ control, shift }, "j", curry(awful.screen.focus_relative, 1),
              {description = "focus the next screen", group = "screen"}),
    awful.key({ control, shift }, "k", curry(awful.screen.focus_relative, -1),
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ super }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ super, control }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ super, control }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Poppin
    awful.key({ super }, "z", function ()
        poppin.pop("terminal", terminal, "top", 800, { border_width = 0 })
    end, {description = "Opens a poppin' terminal", group = "poppin"}),
    awful.key({ super }, "x", function ()
        poppin.pop("messenger", "messengerfordesktop", "right", 1000)
    end, {description = "Opens a poppin' messenger window", group = "poppin"}),

    awful.key({ super, shift }, "l", curry(awful.tag.incmwfact, 0.05),
              {description = "increase master width factor", group = "layout"}),
    awful.key({ super, shift }, "h", curry(awful.tag.incmwfact, -0.05),
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ control, shift }, "h", curry(awful.tag.incnmaster, 1, nil, true),
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ control, shift }, "l",     curry(awful.tag.incnmaster, -1, nil, true),
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ super }, ",", curry(awful.tag.incncol, 1, nil, true),
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ super }, ".", curry(awful.tag.incncol, -1, nil, true),
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ super, shift }, "space", curry(awful.layout.inc, 1),
              {description = "cycle layout", group = "layout"}),
    awful.key({ super, control }, "space", curry(awful.layout.inc, -1),
              {description = "cycle layout in reverse", group = "layout"}),

    awful.key({ super, shift }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"})
)

clientkeys = awful.util.table.join(
    awful.key({ super }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ super, shift }, "c", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ control }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ control }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ super }, "o", function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ super }, "n", function (c) c.minimized = true end ,
        {description = "minimize", group = "client"}),
    awful.key({ super }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ super }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "switch to tag #" .. i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ super, control }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ alt }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
                  {description = "move client to tag #" .. i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ control }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ super }, 1, awful.mouse.client.move),
    awful.button({ super }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
