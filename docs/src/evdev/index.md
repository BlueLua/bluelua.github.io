# evdev

[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/bluelua-evdev?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/bluelua-evdev)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/evdev/blob/main/LICENSE)

Lua bindings for Linux `evdev` input devices and `/dev/uinput` virtual devices
(keyboards, mice, and relative pointers).

## ✨ Features

- **Device Discovery**: List and search for connected input devices by name,
  path, or physical location.
- **Event Stream**: Easily read kernel input events with high-resolution
  timestamps.
- **Virtual Devices (uinput)**: Emulate any hardware input device (mouse,
  keyboard, gamepad) programmatically.
- **Event Selector**: Poll multiple input devices concurrently in a single
  non-blocking event loop.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.

## 📦 Installation

Install the library via LuaRocks:

```bash
luarocks install bluelua-evdev
```

## 🚀 Usage

### Listening to Key Presses

```lua
local evdev = require "evdev"

-- Find and open the primary keyboard
local dev = assert(evdev.device.open("/dev/input/event0"))
print("Opened device: " .. dev.name)

-- Process events in a loop
for event in dev:events() do
  if evdev.events.is_press(event) then
    print("Key Pressed! Code: " .. event.code)
  end
end
```

### Creating a Virtual Keyboard

```lua
local evdev = require "evdev"
local ecodes = evdev.ecodes

-- Create the virtual keyboard
local ui = assert(evdev.uinput.create())

-- Press Shift + A
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 1)
ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 1)
ui:sync()

-- Release Shift + A
ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 0)
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 0)
ui:sync()

ui:close()
```
