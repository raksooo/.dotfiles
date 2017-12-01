local awful = require("awful")
local naughty = require("naughty")

local lock = {
  locked = false
}

function lock.lock()
  if not lock.locked then
    lock.locked = true

    awful.tag.viewnone()
    awful.screen.focused():emit_signal('tag::history::update')

    lock.notification = naughty.notify({
      title = 'Locked',
      text = 'Enter password to unlock',
      timeout = 0,
      icon = '/home/oskar/.local/share/oskar/lock.ico'
    })

    statusbar.textclock._private.textclock_update_cb()
    awful.spawn.easy_async("lock", lock.unlock)
  end
end

function lock.unlock()
  lock.locked = false
  naughty.destroy(lock.notification)
  awful.tag.history.restore()
  statusbar.textclock._private.textclock_update_cb()
end

return lock

