---
order: 4
title: Multi Device Polling
description:
  Poll and consume events from multiple input devices without blocking on one
  device.
---

When you need to handle input from multiple devices (e.g., two keyboards or a
keyboard and a mouse), you can't block on one device's `poll()` — the other
device's events would be delayed.

## Polling multiple devices manually

Create a `selector` to manage multiple devices:

```lua
local evdev = require "evdev"
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb  = assert(Device("/dev/input/event1"))
local mouse = assert(Device("/dev/input/event3"))
local sel = Selector({ kb, mouse })

while true do
  local ready = assert(sel:poll())
  for _, dev in ipairs(ready) do
    local e = dev:read()
    if e then
      local source = (dev == kb) and "keyboard" or "mouse"
      print(source, e.type, e.code, e.value)
    end
  end
end
```

`sel:poll()` waits until at least one registered device has data and returns the
subset that are ready.

## The `events()` iterator

For convenience, `sel:events()` yields `(device, event)` pairs:

```lua
for dev, e in sel:events() do
  if evdev.events.is_key(e) then
    print(dev.name, "key:", e.code)
  end

  if evdev.events.is_rel(e) then
    print(dev.name, "mouse moved")
  end
end
```

The iterator polls all devices until at least one has data, reads from each
ready device, and repeats when drained.
