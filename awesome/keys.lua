local awful = require("awful")
local gears = require("gears")
local poppin = require("poppin")

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
    local tag = awful.screen.focused().tags[i]
    if move then client.focus:move_to_tag(tag) end
    if tag then tag:view_only() end
end

function navigate(direction, move)
    local rows = 3
    local columns = 2

    local i = awful.screen.focused().selected_tag.index - 1
    action = {
        ["down"] = (i + columns) % (rows * columns) + 1,
        ["up"] = (i - columns) % (rows * columns) + 1,
        ["left"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i - 1) % columns) + 1,
        ["right"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i + 1) % columns) + 1,
    }
    local j = action[direction]

    if (j == 4 or j == 6) then
      j = j - 1
    end

    gotoTag(j, move)
end

--[[
function navigate(direction, move)
    local i = awful.screen.focused().selected_tag.index - 1
    action = {
        ["down"] = (i == 0 or i == 1) and 2 or (i + 1) % 4,
        ["up"] = (i - columns) % (rows * columns) + 1,
        ["left"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i - 1) % columns) + 1,
        ["right"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i + 1) % columns) + 1,
    }
    local j = action[direction]
end
--]]

globalkeys = gears.table.join(globalkeys,
    awful.key({ super }, "j", curry(navigate, "down", false),
              {description = "view tag below current", group = "tag"}),
    awful.key({ super }, "k", curry(navigate, "up", false),
              {description = "view tag above current", group = "tag"}),
    awful.key({ super }, "h", curry(navigate, "left", false),
              {description = "view tag left of current", group = "tag"}),
    awful.key({ super }, "l", curry(navigate, "right", false),
              {description = "view tag right of current", group = "tag"}),
    awful.key({ alt, shift }, "j", curry(navigate, "down", true),
              {description = "move client to the tag below", group = "client"}),
    awful.key({ alt, shift }, "k", curry(navigate, "up", true),
              {description = "move client to the tag above", group = "client"}),
    awful.key({ alt, shift }, "h", curry(navigate, "left", true),
              {description = "move client to the tag to the left", group = "client"}),
    awful.key({ alt, shift }, "l", curry(navigate, "right", true),
              {description = "move client to the tag to the right", group = "client"}),

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

    -- Standard program
    awful.key({ super, control }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ super, control }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Poppin
    awful.key({ super }, "t", function ()
        poppin.pop("terminal_top", terminal, "top", 800, { border_width = 8 })
    end, {description = "Opens a poppin' terminal at top", group = "poppin"}),
    awful.key({ super, shift }, "t", function ()
        poppin.pop("terminal_bottom", terminal, "bottom", 800, { border_width = 8 })
    end, {description = "Opens a poppin' terminal at bottom", group = "poppin"}),
    awful.key({ alt }, "t", function ()
        poppin.pop("terminal_center", terminal, "center",
        { border_width = 8, width = 1400, height = 700 })
    end, {description = "Opens a poppin' terminal in center", group = "poppin"}),

    awful.key({ super }, "p", function ()
      if awful.screen.focused().selected_tag.name == tagnames[7] then
        awful.tag.history.restore()
      else
        awful.tag.find_by_name(nil, tagnames[7]):view_only()
      end
    end, {description = "Show/hide messaging tag", group = "tag"}),

    awful.key({ super }, "s", function ()
      if awful.screen.focused().selected_tag.name == tagnames[8] then
        awful.tag.history.restore()
      else
        awful.tag.find_by_name(nil, tagnames[8]):view_only()
        local spotifyOpen = false
        for _, c in ipairs(client.get()) do
          if c.class == "Spotify" then
            spotifyOpen = true
          end
        end
        if not spotifyOpen then
          awful.spawn("spotify --force-device-scale-factor=1.7")
        end
      end
    end, {description = "Show/hide Spotify tag", group = "tag"}),

    awful.key({ super, shift }, "l", curry(awful.tag.incmwfact, 0.05),
              {description = "increase master width factor", group = "layout"}),
    awful.key({ super, shift }, "h", curry(awful.tag.incmwfact, -0.05),
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ super }, ",", curry(awful.tag.incnmaster, 1, nil, true),
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ super }, ".",     curry(awful.tag.incnmaster, -1, nil, true),
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ super, shift }, ",", curry(awful.tag.incncol, 1, nil, true),
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ super, shift }, ".", curry(awful.tag.incncol, -1, nil, true),
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ super, shift }, "space", curry(awful.layout.inc, 1),
              {description = "cycle layout", group = "layout"}),
    awful.key({ super }, "m",
        function (c)
            local tag = awful.screen.focused().selected_tag
            if tag.gap == beautiful.useless_gap then
                tag.gap = beautiful.less_useless_gap
            else
                tag.gap = beautiful.useless_gap
            end
        end ,
        {description = "remove useless gap", group = "layout"}),

    awful.key({ super, shift }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"})
)

clientkeys = gears.table.join(
    awful.key({ super }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ super, shift }, "c", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ control }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ super }, "o", function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ super }, "n", function (c) c.minimized = true end,
        {description = "minimize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
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

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ super }, 1, awful.mouse.client.move),
    awful.button({ super }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
