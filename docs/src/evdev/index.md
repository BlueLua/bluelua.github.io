# evdev

<p style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1.5rem;">
  <a href="https://luarocks.org/modules/BlueLua/bluelua-evdev">
    <img src="https://img.shields.io/luarocks/v/BlueLua/bluelua-evdev?color=blue&style=flat-square" alt="LuaRocks">
  </a>
  <a href="https://github.com/BlueLua/evdev/actions/workflows/test.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/BlueLua/evdev/test.yml?style=flat-square" alt="Test Status">
  </a>
  <img src="https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square" alt="Lua Versions">
  <img src="https://img.shields.io/badge/platform-linux-blue?style=flat-square" alt="Platform">
  <a href="https://github.com/BlueLua/evdev/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  </a>
</p>

`evdev` is a C-backed Lua module for working with Linux input devices through
the [evdev] interface.

## ✨ Features

- **Device Discovery**: List and search for connected input devices by name,
  path, or physical location.
- **Event Stream**: Easily read kernel input events with high-resolution
  timestamps.
- **Exclusive Grabbing**: Grab a device to prevent its events from reaching
  other applications (like desktop environments).
- **Virtual Devices ([uinput])**: Emulate any hardware input device (mouse,
  keyboard, gamepad) programmatically.
- **Event Selector**: Poll multiple input devices concurrently in a single
  non-blocking event loop.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.

## 📦 Installation

::: code-group

```sh [LuaRocks]
luarocks install bluelua-evdev
```

:::

## 🚀 Usage

::: code-group

```lua [list-devices.lua]
local evdev = require "evdev"

-- Discover and list all connected devices
local devs = assert(evdev.devices.list_devices())
for _, dev in ipairs(devs) do
  print(dev.path, dev.name)
end
```

```lua [read-events.lua]
local evdev = require "evdev"

-- Open a specific input device
local dev = assert(evdev.device.open("/dev/input/event3"))
print("Opened device: " .. dev.name)

-- Read event stream
for e in dev:events() do
  if e.events.is_press(e) then
    print("Key Pressed! Code: " .. e.code)
  end
end
```

```lua [virtual-keyboard.lua]
local evdev = require "evdev"
local ecodes = evdev.ecodes

-- Create a virtual keyboard device
local ui = assert(evdev.uinput.create())

-- Press and release Shift + A
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 1)
ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 1)
ui:sync()

ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 0)
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 0)
ui:sync()

ui:close()
```

:::

[evdev]: https://www.freedesktop.org/wiki/Software/libevdev/
[uinput]: https://en.wikipedia.org/wiki/Uinput
