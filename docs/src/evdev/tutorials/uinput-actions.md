---
order: 5
title: Building UInput Actions
description:
  Build tap, hold, chord, sequence, and macro helpers on top of uinput events.
---

This tutorial shows how to build helper actions (tap, hold, macro, ..) on top of
the low-level `emit` and `sync` primitives.

## Preparation

Initialize the virtual device and allow the kernel time to register the input
node. The ui object created here is used throughout the rest of this tutorial.

```lua
local evdev = require "evdev"

local UInput = evdev.uinput.create
local ecodes = evdev.ecodes

local ui = assert(UInput())

local function delay(ms)
  os.execute(string.format("sleep %.3f", ms / 1000))
end
```

## The basic building blocks

Every action is built from:

- `dev:emit(type, code, value)` — queues one input event
- `dev:sync()` — flushes queued events to the kernel

Each press or release needs its own `sync()` so the input subsystem sees the
state change before the next event:

```lua
dev:emit(ecodes.EV_KEY, code, evdev.events.PRESS) -- [!code error]
dev:sync() -- key is down

dev:emit(ecodes.EV_KEY, code, evdev.events.RELEASE) -- [!code error]
dev:sync() -- key is up
```

## Keyboard Actions

### Press

Send a key-down event.

```lua
local function press(dev, code)
  dev:emit(ecodes.EV_KEY, code, 1)
  dev:sync()
end

press(ui, ecodes.KEY_A)
```

### Release

Send a key-up event.

```lua
local function release(dev, code)
  dev:emit(ecodes.EV_KEY, code, evdev.events.RELEASE)
  dev:sync()
end

release(ui, ecodes.KEY_A)
```

### Tap

Press and release a key.

```lua
local function tap(dev, code)
  press(dev, code)
  release(dev, code)
end

tap(ui, ecodes.KEY_A)
tap(ui, ecodes.KEY_B)
```

### Macro

Tap several keys in order.

```lua
local function macro(dev, codes)
  for _, code in ipairs(codes) do
    dev:emit(ecodes.EV_KEY, code, 1)
    dev:sync()
    dev:emit(ecodes.EV_KEY, code, 0)
    dev:sync()
  end
end

macro(ui, {
  ecodes.KEY_H,
  ecodes.KEY_E,
  ecodes.KEY_L,
  ecodes.KEY_L,
  ecodes.KEY_O,
})
```

## Mouse actions

### Move cursor

Move the mouse pointer by relative pixels.

```lua
local function move(dev, dx, dy)
  if dx ~= 0 then
    dev:emit(ecodes.EV_REL, ecodes.REL_X, dx)
  end
  if dy ~= 0 then
    dev:emit(ecodes.EV_REL, ecodes.REL_Y, dy)
  end
  dev:sync()
end

move(ui, 10, 0) -- 10 pixels right
move(ui, 0, -5) -- 5 pixels up
```

### Scroll wheel

Emit vertical or horizontal scroll notches.

```lua
local function scroll(dev, clicks)
  dev:emit(ecodes.EV_REL, ecodes.REL_WHEEL_HI_RES, clicks * 120)
  dev:sync()
end

local function scroll_h(dev, clicks)
  dev:emit(ecodes.EV_REL, ecodes.REL_HWHEEL_HI_RES, clicks * 120)
  dev:sync()
end

-- Focus a scrollable window (like a web browser or editor) now
-- to see the scrolling effect.
delay(2000)

-- Scroll down 3 notches
scroll(ui, -3)
delay(500)

-- Scroll up 3 notches
scroll(ui, 3)
delay(500)

-- Scroll right 3 notches
scroll_h(ui, 3)
delay(500)

-- Scroll left 3 notches
scroll_h(ui, -3)
```

### Click

Press and release a mouse button.

```lua
tap(ui, ecodes.BTN_LEFT)   -- left click
delay(500)
tap(ui, ecodes.BTN_RIGHT)  -- right click
delay(500)
tap(ui, ecodes.BTN_MIDDLE) -- middle click
```

Because the Linux kernel treats mouse buttons ( [BTN_*] ) as keys (both use the
`EV_KEY` event type under the hood), we can use `tap()` to perform clicks.

[BTN_*]: ../types#evdev-ecodes-btn
