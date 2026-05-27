# What is evdev?

`evdev` is a Lua module for working with Linux input devices through the evdev
interface.

It lets Lua discover Linux input devices, read raw events, grab devices, and
create virtual input devices with uinput.

## Compatibility

`evdev` supports:

- Lua 5.1
- Lua 5.2
- Lua 5.3
- Lua 5.4
- Lua 5.5
- LuaJIT

## Use Cases

- Build input automation tools.
- Read keyboard, mouse, gamepad, and other Linux input events from Lua.
- Inspect devices under `/dev/input`.
- Grab a device while handling input yourself.
- Create virtual keyboards, mice, or controllers for tests and tooling.
