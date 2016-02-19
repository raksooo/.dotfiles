local wibox = require("wibox")

function gdriveWidget()
    gdriveWidget = wibox.layout.fixed.horizontal()
    image = wibox.widget.imagebox()
    padding = wibox.widget.textbox()
    gdriveWidget:add(padding)
    gdriveWidget:add(image)
    gdriveWidget:add(padding)

    setInterval(function() updateGDriveWidget(image, padding) end, 30)

    return gdriveWidget
end

function updateGDriveWidget(image, padding)
    fh = io.popen("pidof grive")
    data = fh:read("*a")
    fh:close()

    if data == "" then
        image:set_image("/home/rascal/.config/awesome/resources/transparent.png")
        padding:set_text("")
    else
        image:set_image("/home/rascal/.config/awesome/resources/gdrive.png")
        padding:set_text("   ")
    end
end

