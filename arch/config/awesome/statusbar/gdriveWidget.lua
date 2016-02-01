local wibox = require("wibox")

function gdriveWidget()
    gdriveWidget = wibox.layout.fixed.horizontal()
    image = wibox.widget.imagebox()
    padding = wibox.widget.textbox()
    gdriveWidget:add(padding)
    gdriveWidget:add(image)
    gdriveWidget:add(padding)

    gdriveWidgetTimer = timer({ timeout = 30 })
    gdriveWidgetTimer:connect_signal("timeout",
      function()
        fh = io.popen("pidof grive")
        data = fh:read("*a")
        fh:close()

        if data == "" then
            image:set_image("/home/rascal/.config/awesome/statusbar/transparent.png")
            padding:set_text("")
        else
            image:set_image("/home/rascal/.config/awesome/statusbar/gdrive.png")
            padding:set_text("   ")
        end
      end
    )
    gdriveWidgetTimer:emit_signal("timeout")
    gdriveWidgetTimer:start()
    return gdriveWidget
end

