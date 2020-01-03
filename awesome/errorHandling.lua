local naughty = require("naughty")

function log(text)
    file = io.open(os.getenv("HOME") .. "/.cache/awesome-config.log", "a")
    file:write("\n\n" .. text)
    file:close()
end

if awesome.startup_errors then
    log("Startup error:\n" .. awesome.startup_errors)
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        log("Error:\n" .. tostring(err))
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = "Have a look in the log file!" })
        in_error = false
    end)
end

awesome.connect_signal("debug::deprecation", function (hint)
    log("Deprecation warning:\n" .. hint)
    naughty.notify({ title = "Deprecation warning!",
                     text = "Have a look in the log file!" })
end)
