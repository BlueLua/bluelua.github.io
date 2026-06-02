---
order: 2
title: Grabbing and Repeat
description:
  Grab input devices exclusively and configure keyboard repeat behavior.
---

# Grabbing Devices and Configuring Repeat

This tutorial covers exclusive device access and auto-repeat settings.

## Grabbing a device

When you `grab()` a device, your process gets exclusive access — input events
are delivered only to you, not to other applications (like X11 or Wayland
compositors).

```lua
local evdev = require "evdev"
local Device = evdev.device.open

local path = "/dev/input/event3"
local dev = assert(Device(path))

assert(dev:grab())

-- After grab, events are delivered here and blocked from other programs
for e in dev:events() do
  print("key pressed:", e.code)
end
```

> [!TIP]
>
> Call `dev:flush()` before grabbing to discard stale buffered events.

## Auto-repeat settings

Linux input devices have built-in key repeat with two parameters: **delay** (ms)
and the repeat **period** (ms between repeats).

```lua
-- Read current kernel repeat settings
local delay, period = assert(dev:get_repeat())
print("repeat delay:",  delay)  -- ms before repeat starts
print("repeat period:", period) -- ms between repeats

-- Set both at once (200 ms delay, 20 ms between repeats)
assert(dev:set_repeat(200, 20))

delay, period = assert(dev:get_repeat())
print("new delay:", delay)
print("new period:", period)
```
