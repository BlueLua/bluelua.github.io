---
order: 1
title: Quick Start
description: Discover Linux input devices and read your first evdev events.
---

This tutorial walks through discovering input devices and reading events.

## Discover input devices

First, find available input devices on your system:

```lua
local evdev = require "evdev"

local devs = assert(evdev.devices.list_devices())
for _, dev in ipairs(devs) do
  print(dev.path, dev.name)
end
```

`list_devices()` scans `/dev/input/event*` and reads each device's metadata. It
also resolves symlinks from `/dev/input/by-id/` and `/dev/input/by-path/` and
attaches them as `id_aliases` and `path_aliases` fields.

## Inspect a device

If you know the path, inspect one device directly:

```lua
local path = "/dev/input/event1"
local dev = assert(evdev.devices.device_info(path))
print(dev.name)
```

::: details Device info

<!-- @include: ../reference/device-info.md -->

:::

## Find devices by `name` or `path`

Search for a device by its name or `/dev/input/` path:

::: code-group

```lua [by-name.lua]
local name = "AT Translated Set 2 keyboard"
local kb = evdev.devices.find(name)
local devs = evdev.devices.find_all(name)
```

```lua [by-event-path.lua]
local path = "/dev/input/event0"
local dev = evdev.devices.find(path)
local devs = evdev.devices.find_all(path)
```

```lua [by-path.lua]
local path = "/dev/input/by-path/pci-example-00:00.0-event-kbd"
local kb = evdev.devices.find(path)
local devs = evdev.devices.find_all(path)
```

```lua [by-id.lua]
local path = "/dev/input/by-id/usb-Example_Vendor_1234-event-mouse"
local mouse = evdev.devices.find(path)
local devs = evdev.devices.find_all(path)
```

:::

> [!NOTE]
>
> `find()` returns the first match or `nil`. `find_all()` returns a list of all
> matching devices.

## Open a device and read events

Once you know which device you want, open it and read events using the
`events()` iterator:

```lua
local path = "/dev/input/event3"
local Device = evdev.device.open

local dev = assert(Device(path))
print("Opened:", dev.name)

for e in dev:events() do
  print(e.code, e.value)
end
```

The iterator polls and reads in a loop, yielding each event as it arrives. It
runs until the device is closed or an error occurs.

::: details Event fields

<!-- @include: ../reference/event-fields.md -->

:::
