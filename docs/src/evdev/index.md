# evdev

[![Test](https://img.shields.io/github/actions/workflow/status/BlueLua/evdev/test.yml?branch=main&label=test&style=flat-square)](https://github.com/BlueLua/evdev/actions/workflows/test.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/bluelua-evdev?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/bluelua-evdev)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/evdev/blob/main/LICENSE)

Lua bindings for Linux evdev input devices and /dev/uinput virtual devices.

Check out the [documentation] for guides and examples.

## ✨ Features

- **Device Discovery**: List and search for connected input devices by name,
  path, or physical location.
- **Event Stream**: Read kernel input events with high-resolution timestamps.
- **Virtual Devices**: Emulate any hardware input device (mouse, keyboard,
  gamepad) programmatically via uinput.
- **Event Selector**: Poll multiple devices concurrently in a single
  non-blocking event loop.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.

## 📦 Installation

```sh
luarocks install bluelua-evdev
```

## 🚀 Usage

```lua
local evdev = require "evdev"

local dev = assert(evdev.device.open("/dev/input/event0"))

for event in dev:events() do
  if evdev.events.is_press(event) then
    print("Key pressed: " .. event. code)
  end
end
```

[documentation]: https://bluelua.github.io/evdev
