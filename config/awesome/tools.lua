local wibox = require("wibox")
local naughty = require("naughty")
local asyncshell = require("../asyncshell")

local tools = {}

function tools.newSeperator(text)
    seperator = wibox.widget.textbox()
    seperator:set_markup("<span color=\"#333333\">" .. text .. "</span>")
    return seperator
end
tools.spacing = tools.newSeperator("  ")
tools.mediumspacing = tools.newSeperator("   ")
tools.bigspacing = tools.newSeperator("    ")
tools.seperator = tools.newSeperator("    |    ")

function debug.notify(text)
    local preset = {
        height = 60,
        width = 140,
        title = "Debug",
        text = text
    }
    naughty.notify ({ preset = preset })
end

function setInterval(f, interval)
    t = timer({ timeout = interval })
    t:connect_signal("timeout", f)
    t:start()
    return t
end

function setTimeout(f, timeout)
    if timeout then
        local startTimer = timer({ timeout = timeout })
        startTimer:connect_signal("timeout", function()
                startTimer:stop()
                f()
            end)
        startTimer:start()
    else
        f()
    end
end

function initInterval(f, interval, first)
    local t = setInterval(f, interval)
    setTimeout(f, first)
    return t
end

function margin(widget, margin)
    if margin == nil then
        margin = 4
    end
    margin = wibox.layout.margin(widget, 0, 0, margin + 1, margin)
    return margin
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

function trim(s)
    local n = s:find"%S"
    return n and s:match(".*%S", n) or ""
end

return tools

