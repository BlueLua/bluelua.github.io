---
title: "selector"
description: "Selector for polling and reading from multiple devices."
---

Selector for polling and reading from multiple devices.

## Functions

| Function                       | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| [`add(device)`](#fn-add)       | Add a device to this selector.                                 |
| [`clear()`](#fn-clear)         | Remove all devices from this selector.                         |
| [`events()`](#fn-events)       | Return an iterator that yields events from registered devices. |
| [`new(devices?)`](#fn-new)     | Create a selector from an optional list of devices.            |
| [`poll()`](#fn-poll)           | Wait until at least one registered device has input available. |
| [`remove(device)`](#fn-remove) | Remove a device from this selector.                            |

<a id="fn-add"></a>

### `add(device)`

Add a device to this selector.

**Parameters**:

- `device` (`evdev.Device`)

**Return**:

- **value** (`self`)

**Example**:

```lua
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1 })

sel:add(kb2)
```

<a id="fn-clear"></a>

### `clear()`

Remove all devices from this selector.

**Return**:

- **value** (`self`)

**Example**:

```lua
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

sel:clear()
```

<a id="fn-events"></a>

### `events()`

Return an iterator that yields events from registered devices.

**Return**:

- `evdev.Device?,` (`fun():`): evdev.event?

**Example**:

```lua
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

for dev, e in sel:events() do
  print(dev.name, e.code, e.value)
end
```

<a id="fn-new"></a>

### `new(devices?)`

Create a selector from an optional list of devices.

**Parameters**:

- `devices?` (`evdev.Device[]`)

**Return**:

- **value** (`evdev.Selector`)

**Example**:

```lua
local evdev = require "evdev"
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })
```

<a id="fn-poll"></a>

### `poll()`

Wait until at least one registered device has input available.

**Return**:

- `devs` (`evdev.Device[]?`)
- `err` (`string?`)

**Example**:

```lua
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

for _, dev in ipairs(assert(sel:poll())) do
  print(dev)
end
```

<a id="fn-remove"></a>

### `remove(device)`

Remove a device from this selector.

**Parameters**:

- `device` (`evdev.Device`)

**Return**:

- **value** (`self`)

**Example**:

```lua
local Device = evdev.device.open
local Selector = evdev.selector.new

local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

sel:remove(kb2)
```
