---
order: 3
title: Creating Virtual Input Devices
description:
  Create virtual keyboards, pointer devices, and synthetic input events with
  uinput.
---

# Creating Virtual Input Devices with UInput

This tutorial covers creating virtual keyboards, relative pointer devices, and
synthetic input events.

## Prerequisites

`/dev/uinput` must exist and be writable. See
[UInput Access Setup](./uinput-access) for configuring permissions properly.

## Creating a virtual keyboard

The simplest way to create a virtual keyboard:

```lua
local evdev = require "evdev"
local UInput = evdev.uinput.create
local ui = assert(UInput({ name = "Lua Virtual Keyboard" }))

-- Give the kernel time to register the device
os.execute("sleep 0.5") -- Replace with your preferred sleep helper
print(ui.path)
```

::: details UInput options

<!-- @include: ../reference/uinput-spec.md -->

:::

When `keys` option is omitted, evdev enables all real [KEY_*] and [BTN_*] codes.
The `name` is what tools like `evtest` will display.

> [!WARNING]
>
> Without the delay, accessing device info right after creation may fail.

## Emitting key presses

Use `emit()` to queue an event and `sync()` to flush it:

```lua
ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 1)
ui:sync()
ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 0)
ui:sync()
```

## Custom key set

Instead of enabling all keys, specify exactly which keys your virtual device
supports:

```lua
local gamepad = assert(evdev.uinput.create {
  name = "Lua Gamepad",
  keys = {
    evdev.ecodes.BTN_SOUTH,
    evdev.ecodes.BTN_EAST,
    evdev.ecodes.BTN_NORTH,
    evdev.ecodes.BTN_WEST,
    evdev.ecodes.BTN_TL,
    evdev.ecodes.BTN_TR,
    evdev.ecodes.BTN_START,
    evdev.ecodes.BTN_SELECT,
  },
  event_types = {
    evdev.ecodes.EV_KEY,
    evdev.ecodes.EV_SYN,
  },
})
```

## Mouse / relative axis device

```lua
local mouse = assert(UInput({
  name = "Lua Mouse",
  keys = {
    evdev.ecodes.BTN_LEFT,
    evdev.ecodes.BTN_RIGHT,
    evdev.ecodes.BTN_MIDDLE,
  },
  rels = {
    evdev.ecodes.REL_X,
    evdev.ecodes.REL_Y,
    evdev.ecodes.REL_WHEEL,
  },
}))

-- Give the kernel time to register the device
os.execute("sleep 0.5") -- Replace with your preferred sleep helper

-- Move right and down in one input frame.
mouse:emit(evdev.ecodes.EV_REL, evdev.ecodes.REL_X, 50)
mouse:emit(evdev.ecodes.EV_REL, evdev.ecodes.REL_Y, 25)
mouse:sync()

-- Click right.
mouse:emit(evdev.ecodes.EV_KEY, evdev.ecodes.BTN_RIGHT, 1)
mouse:sync()
mouse:emit(evdev.ecodes.EV_KEY, evdev.ecodes.BTN_RIGHT, 0)
mouse:sync()
```

[KEY_*]: ../api/ecodes#key
[BTN_*]: ../api/ecodes#btn
