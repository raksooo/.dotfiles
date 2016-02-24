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

tools.lastConnected = 0
function tools.connected(online, offline)
    if tools.lastConnected > os.time() - 15 then
        online()
    else
        command = "ping -q -w 1 -c 1 www.google.com &> /dev/null && echo true || echo false"
        asyncshell.request(command, function(status)
            status = trim(status) == "true"
            if status then
                online()
            elseif offline then
                offline()
            end
            tools.lastConnected = os.time()
        end)
    end
end

function tools.notify(text)
    local preset = {
        height = 60,
        width = 140,
        title = "Debug",
        text = text
    }
    naughty.notify({ preset = preset })
end

function tools.setInterval(f, interval)
    t = timer({ timeout = interval })
    t:connect_signal("timeout", f)
    t:start()
    return t
end

function tools.setTimeout(f, timeout)
    if timeout and timeout > 0 then
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

function tools.initInterval(f, interval, first, needsInternet)
    if first == true or first == false then
        needsInternet = first
        first = nil
    end

    tools.connected(function()
        local t = tools.setInterval(f, interval)
        tools.setTimeout(f, first)
        return t
    end, function()
        tools.setTimeout(function()
            tools.initInterval(f, interval, first, needsInternet)
        end, 15)
    end)
end

function tools.margin(widget, margin)
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

