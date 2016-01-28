local wibox = require("wibox")
local naughty = require("naughty")

local rascal = {}

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
        title = "Debug",
        text = text
    }
    naughty.notify ({ preset = preset })
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

return rascal

