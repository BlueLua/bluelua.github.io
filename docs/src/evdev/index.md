# What is evdev?

`evdev` is a Lua module for working with Linux input devices through the evdev
interface.

Compatible with Lua 5.1, 5.2, 5.3, 5.4, 5.5, and LuaJIT.

Use `evdev` to read events from keyboards, mice, gamepads, and other
`/dev/input` devices, grab a device while handling input yourself, or create
virtual keyboards, mice, and controllers through `/dev/uinput`.

## Install

::: code-group

```sh [LuaRocks]
luarocks install bluelua-evdev
```

:::

## Quick Start

::: code-group

```lua [lis-devices.lua]
local evdev = require "evdev"

for _, info in ipairs(devices) do
  print(info.path, info.name)
end
```

```lua [open-device.lua]
local evdev = require "evdev"

local dev = assert(evdev.device("/dev/input/event3"))
print("opened:", dev.name)
```

```lua [read-events.lua]
local evdev = require "evdev"
local dev = assert(evdev.device("/dev/input/event3"))

for event in dev:events() do
  print(event.type, event.code, event.value)
end
```

:::
