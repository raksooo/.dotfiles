local gears = require("gears")
local awful = require("awful")
local poppin = require("poppin")

local session = {
    running = false,
    counter = 0,
    total = 0,
    file = os.getenv("HOME") .. "/.awesome-session"
}

function kill()
    for _, c in ipairs(client.get()) do
        c:kill()
    end
end

function session.close()
    session.save(kill)
end

function _save(code, name, callback)
    if code == 0 then
        file = io.open(session.file, "a")
        file:write(name .. "\n")
        file:close()
    end
    session.counter = session.counter + 1

    if session.counter == session.total then
        session.running = false
        callback()
    end
end

function session.save(callback)
    session.running = true
    local clients = client.get()
    session.total = #clients
    session.counter = 0

    os.remove(session.file)
    for _, c in ipairs(clients) do
        if not poppin.isPoppin(c) then
            local name = c.class:lower()
            awful.spawn.with_line_callback("which " .. name, { exit = function(_, code)
                _save(code, name, callback)
            end })
        end
    end
end

function session.restore()
    awful.spawn.with_line_callback("cat " .. session.file, { stdout = awful.spawn })
    os.remove(session.file)
end

return session

