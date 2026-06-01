# Grabbing Devices and Configuring Repeat

This tutorial covers exclusive device access and auto-repeat settings.

## Grabbing a device

When you `grab()` a device, your process gets exclusive access — input events
are delivered only to you, not to other applications (like X11 or Wayland
compositors).

```lua
local evdev = require "evdev"
local dev = assert(evdev.device("/dev/input/event3"))

local ok, err = dev:grab()
if not ok then
  error("grab failed: " .. err)
end

-- Now only we receive events from this device
for event in dev:events() do
  if event.type == evdev.ecodes.EV_KEY and event.value == 1 then
    print("key pressed:", event.code)
  end
end

dev:ungrab()   -- release the grab
```

## Checking if a device is open

```lua
if dev:is_open() then
  print("device is still connected")
end
```

If the device gets unplugged and you try to read it, `read()` returns
`nil, err`.

## Device info after opening

```lua
print(dev.name)
```

## Auto-repeat settings

Linux input devices have built-in key repeat (initial delay and repeat rate).
You can read and write these:

```lua
-- Read current settings
local delay, period = assert(dev:get_repeat())
print("repeat delay:",  delay)   -- milliseconds before repeat starts
print("repeat period:", period)  -- milliseconds between repeats

-- Set both at once
assert(dev:set_repeat(300, 40))

-- Verify
print(assert(dev:get_repeat()))
```

These are backed by the `EVIOCGREP` / `EVIOCSREP` ioctls and are live changes to
the kernel's repeat parameters for that device.

## Flushing buffered events

Clear any pending events from the kernel buffer:

```lua
dev:flush()
```

Useful before starting a grab so stale buffered events don't interfere.

## Complete grab example

```lua
local evdev = require "evdev"
local dev = assert(evdev.device("/dev/input/event3"))

assert(dev:grab())
dev:flush()

local last_key
local press_count = 0

for event in dev:events() do
  if event.type == evdev.ecodes.EV_KEY then
    if event.value == 1 then
      press_count = press_count + 1
      last_key = event.code
      print(string.format("[%d] %s pressed", press_count, last_key))
    elseif event.value == 2 then
      print(last_key, "repeat")
    end
  end
end
```

Remember to `ungrab()` when done, though `close()` also releases the grab
automatically.
