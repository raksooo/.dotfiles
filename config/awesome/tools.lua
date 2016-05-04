local tools = {}

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

function tools.notify(title, text)
    if title and not text then
        text = title
        title = nil
    end

    local preset = {
        title = title or "Debug",
        text = text or "Debug notification"
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

    if needsInternet then
        tools.connected(function()
            tools.setInterval(f, interval)
            tools.setTimeout(f, first)
        end, function()
            tools.setTimeout(function()
                tools.initInterval(f, interval, first, needsInternet)
            end, 15)
        end)
    else
        tools.setInterval(f, interval)
        tools.setTimeout(f, first)
    end
end

function curry(f, a, b, c, d, e, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
    return function()
        f(a, b, c, d, e, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u)
    end
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(math.floor(num * mult + 0.5) / mult)
end

function split(inputstr, sep)
        if inputstr == nil then
            return nil
        end
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

function join(delimiter, list)
    local len = #list
    if len == 0 then
        return ""
    end
    local string = list[1]
    for i = 2, len do
        string = string .. delimiter .. list[i]
    end
    return string
end

function trim(s)
    local n = s:find"%S"
    return n and s:match(".*%S", n) or ""
end

return tools

