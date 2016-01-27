local vicious = require("vicious")
local awful = require("awful")
awful.rules = require("awful.rules")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

local rascal = {}

local terminal
local alsawidget

function rascal.newSeperator(text)
    seperator = wibox.widget.textbox()
    seperator:set_markup("<span color=\"#333333\">" .. text .. "</span>")
    return seperator
end
rascal.spacing = rascal.newSeperator("  ")
rascal.mediumspacing = rascal.newSeperator("   ")
rascal.bigspacing = rascal.newSeperator("    ")
rascal.seperator = rascal.newSeperator("   |   ")

function debug.notify(text)
    local preset = {
        height = 60,
        width = 140,
        font = alsawidget.notifications.font,
        title = "Debug",
        text = text
    }
    alsawidget._notify = naughty.notify ({ preset = preset })
end

function rascal.init(_terminal)
    terminal = _terminal
end

function rascal.volumewidget()
    alsawidget = {
        channel = "Master",
        step = "5%",
        colors = {
            unmute = "#AECF96",
            mute = "#FF5656"
        },
        mixer = terminal .. " -e alsamixer", -- or whatever your preferred sound mixer is
        notifications = {
            icons = {
                -- the first item is the 'muted' icon
                "/usr/share/icons/gnome/48x48/status/audio-volume-muted.png",
                -- the rest of the items correspond to intermediate volume levels - you can have as many as you want (but must be >= 1)
                "/usr/share/icons/gnome/48x48/status/audio-volume-low.png",
                "/usr/share/icons/gnome/48x48/status/audio-volume-medium.png",
                "/usr/share/icons/gnome/48x48/status/audio-volume-high.png"
            },
            font = "Monospace 10", -- must be a monospace font for the bar to be sized consistently
            icon_size = 48,
            bar_size = 11 -- adjust to fit your font if the bar doesn't fit
        }
    }
    -- widget
    alsawidget.bar = awful.widget.progressbar ()
    alsawidget.bar:set_width (8)
    alsawidget.bar:set_vertical (true)
    alsawidget.bar:set_background_color ("#494B4F")
    alsawidget.bar:set_color (alsawidget.colors.unmute)
    alsawidget.bar:buttons (awful.util.table.join (
        awful.button ({}, 1, function()
            awful.util.spawn (alsawidget.mixer)
        end),
        awful.button ({}, 3, function()
                    -- You may need to specify a card number if you're not using your main set of speakers.
                    -- You'll have to apply this to every call to 'amixer sset'.
                    -- awful.util.spawn ("amixer sset -c " .. yourcardnumber .. " " .. alsawidget.channel .. " toggle")
            awful.util.spawn ("amixer sset " .. alsawidget.channel .. " toggle")
            vicious.force ({ alsawidget.bar })
        end),
        awful.button ({}, 4, function()
            awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
            vicious.force ({ alsawidget.bar })
        end),
        awful.button ({}, 5, function()
            awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
            vicious.force ({ alsawidget.bar })
        end)
    ))
    -- tooltip
    alsawidget.tooltip = awful.tooltip ({ objects = { alsawidget.bar } })
    -- naughty notifications
    alsawidget._current_level = 0
    alsawidget._muted = false
    function alsawidget:notify ()
        local preset = {
            height = 60,
            width = 140,
            font = alsawidget.notifications.font,
            bar_character = "═"
        }
        local i = 1;
        while alsawidget.notifications.icons[i + 1] ~= nil
        do
            i = i + 1
        end
        if i >= 2
        then
            preset.icon_size = alsawidget.notifications.icon_size
            if alsawidget._muted or alsawidget._current_level == 0
            then
                preset.icon = alsawidget.notifications.icons[1]
            elseif alsawidget._current_level == 100
            then
                preset.icon = alsawidget.notifications.icons[i]
            else
                local int = math.modf (alsawidget._current_level / 100 * (i - 1))
                preset.icon = alsawidget.notifications.icons[int + 2]
            end
        end
        if alsawidget._muted
        then
            preset.title = alsawidget.channel .. " - Muted"
        elseif alsawidget._current_level == 0
        then
            preset.title = alsawidget.channel .. " - 0%"
            preset.text = "[" .. string.rep (" ", alsawidget.notifications.bar_size) .. "]"
        elseif alsawidget._current_level == 100
        then
            preset.title = alsawidget.channel .. " - 100%"
            preset.text = "[" .. string.rep (preset.bar_character, alsawidget.notifications.bar_size) .. "]"
        else
            local int = round (alsawidget._current_level / 100 * alsawidget.notifications.bar_size)
            preset.title = alsawidget.channel .. " - " .. alsawidget._current_level .. "%"
            preset.text = "[" .. string.rep (preset.bar_character, int) .. string.rep (" ", alsawidget.notifications.bar_size - int) .. "]"
        end
        preset.title = " " .. preset.title
        if preset.text ~= nil then
            preset.text = " " .. preset.text
        end
        if alsawidget._notify ~= nil
        then
            alsawidget._notify = naughty.notify ({
                replaces_id = alsawidget._notify.id,
                preset = preset
            })
        else
            alsawidget._notify = naughty.notify ({ preset = preset })
        end
    end
    -- register the widget through vicious
    vicious.register (alsawidget.bar, vicious.widgets.volume, function (widget, args)
        alsawidget._current_level = args[1]
        if args[2] == "♩"
        then
            alsawidget._muted = true
            alsawidget.tooltip:set_text (" [Muted] ")
            widget:set_color (alsawidget.colors.mute)
            return 100
        end
        alsawidget._muted = false
        alsawidget.tooltip:set_text (" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
        widget:set_color (alsawidget.colors.unmute)
        return args[1]
    end, 5, alsawidget.channel) -- relatively high update time, use of keys/mouse will force update

    return alsawidget.bar
end

function rascal.keys(globalkeys)
    globalkeys = volumekeys(globalkeys)
    globalkeys = mediakeys(globalkeys)
    globalkeys = brightnesskeys(globalkeys)
    return globalkeys
end

function mediakeys(globalkeys)
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioPlay", function()
        os.execute("playerctl play-pause &")
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioPrev", function()
        os.execute("playerctl previous &")
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioNext", function()
        os.execute("playerctl next &")
    end))
    return globalkeys
end

function volumekeys(globalkeys)
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioRaiseVolume", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
        vicious.force({ alsawidget.bar })
        alsawidget.notify()
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioLowerVolume", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
        vicious.force({ alsawidget.bar })
        alsawidget.notify()
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86AudioMute", function()
        awful.util.spawn("amixer sset " .. alsawidget.channel .. " toggle")
        -- The 2 following lines were needed at least on my configuration, otherwise it would get stuck muted
        -- However, if the channel you're using is "Speaker" or "Headpphone"
        -- instead of "Master", you'll have to comment out their corresponding line below.
        awful.util.spawn("amixer sset " .. "Speaker" .. " unmute")
        awful.util.spawn("amixer sset " .. "Headphone" .. " unmute")
        vicious.force({ alsawidget.bar })
        alsawidget.notify()
    end))

    return globalkeys
end

function brightnesskeys(globalkeys)
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86MonBrightnessDown", function()
        adjustBrightness(-5000)
    end))
    globalkeys = awful.util.table.join(globalkeys, awful.key({ }, "XF86MonBrightnessUp", function()
        adjustBrightness(5000)
    end))
    return globalkeys
end

function adjustBrightness(delta)
    current_fh = io.popen("cat /sys/class/backlight/gmux_backlight/actual_brightness")
    current = tonumber(current_fh:read("*a"))
    current_fh:close()
    max_fh = io.popen("cat /sys/class/backlight/gmux_backlight/max_brightness")
    max = tonumber(max_fh:read("*a"))
    max_fh:close()
    current = math.floor(current + delta)
    current = math.min(current, max)
    current = math.max(current, 0)
    os.execute("sudo tee /sys/class/backlight/gmux_backlight/brightness <<< " .. current)
end

function rascal.wifiwidget()
    -- Wifi signal
    wifi_signal_widget = wibox.widget.textbox("?%")
    -- wifi_icon = wibox.widget.imagebox()
    function wifiInfo()
        local wifiStrength = awful.util.pread("awk 'NR==3 {printf \"%.1f\\n\",($3/70)*100}' /proc/net/wireless")
        if wifiStrength == "" then
            -- wifi_icon:set_image(beautiful.wireless_down)
            wifi_signal_widget:set_text("W:0")
        else
            -- wifi_icon:set_image(beautiful.wireless)
            wifi_signal_widget:set_text("W:" .. math.floor(wifiStrength) .. "%")
        end
    end
    wifiInfo()

    wifi_timer = timer({timeout=2})
    wifi_timer:connect_signal("timeout",wifiInfo)
    wifi_timer:start()

    return wifi_signal_widget
end

function rascal.pacmanupdatewidget()
    pacwidget = wibox.widget.textbox()
    pacwidgettimer = timer({ timeout = 600 })
    pacwidgettimer:connect_signal("timeout", function()
        fh = io.popen("pacman -Qqu | wc -l")
        pacwidget:set_text("P:" .. fh:read("*a"))
        fh:close()
    end)
    pacwidgettimer:emit_signal("timeout")
    pacwidgettimer:start()
    return pacwidget
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(math.floor(num * mult + 0.5) / mult)
end

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function rascal.run_once(cmd)
    nm_status = io.popen("pidof " .. cmd)
    nm_status_length = nm_status:read("*a"):len()
    nm_status:close()
    if nm_status_length == 0 then
        awful.util.spawn(cmd .. " &")
    end
end

function rascal.restart(cmd)
    os.execute("pkill " .. cmd .. " && sleep 1s && " .. cmd .. " &")
end


return rascal

