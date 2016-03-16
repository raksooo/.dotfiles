---------------------------------------------------------
-- Puts a 1-pixel bar on the edges of first and last screen that moves the cursor to the opposite end.
--
-- In a 3-monitor setup this has the additional benefit of letting you cheat with xrandr to set your physical middle screen as your
-- first screen but have the cursor behave like it's the middle one - good for programs that need to open on 0,0.
-- So: [3][1][2] where the cursor moves between 3 and 1 seamlessly even though they are at opposite ends as far as X is concerned.
-- The only issue is that it does not support dragging clients, so to drag one to 3 you will have to go rightwards through 2 or just use keybindings.
---------------------------------------------------------

if warp_bars then
    local barwidth = 1

    local screenL = 1
    local screenR = 1
    for s = 1, screen.count() do
        if screen[s].geometry.x < screen[screenL].geometry.x then screenL = s end
        if screen[s].geometry.x > screen[screenR].geometry.x then screenR = s end
    end

    warpbarL = awful.wibox({ position = "left", screen = screenL, width = barwidth, bg = "#002b36" })
    warpbarL:connect_signal("mouse::enter", function ()
        local pos = mouse.coords()
        local w = 0
        local h = screen[screenR].geometry.height - 1
        for s = 1, screen.count() do
            w = w + screen[s].geometry.width
        end
        mouse.coords({ x = w - barwidth - 1, y = math.min(pos.y, h) })
    end)

    warpbarR = awful.wibox({ position = "right", screen = screenR, width = barwidth, bg = "#002b36" })
    warpbarR:connect_signal("mouse::enter", function ()
        local pos = mouse.coords()
        local h = screen[screenL].geometry.height - 1
        mouse.coords({ x = barwidth + 1, y = math.min(pos.y, h) })
    end)
end

