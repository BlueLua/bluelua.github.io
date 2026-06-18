---
title: "selector"
description: "Monitor and read events from multiple input devices."
---

Monitor and read events from multiple input devices.

## Usage

```lua
local evdev = require "evdev"

local Device = evdev.device.open
local Selector = evdev.selector.new

local dev1 = assert(Device("/dev/input/eventX"))
local dev2 = assert(Device("/dev/input/eventY"))
local sel = Selector({ dev1, dev2 })

for dev, ev in sel:events() do
  print(dev.name, ev.code, ev.value)
end
```

## Functions

| Function           | Description                                                    |
| ------------------ | -------------------------------------------------------------- |
| [`new(devices?)`]  | Create a selector from an optional list of devices.            |
| [`add(device)`]    | Add a device to this selector.                                 |
| [`clear()`]        | Remove all devices from this selector.                         |
| [`events()`]       | Return an iterator that yields events from registered devices. |
| [`poll()`]         | Wait until at least one registered device has input available. |
| [`remove(device)`] | Remove a device from this selector.                            |

### `new(devices?)` {#new}

Create a selector from an optional list of devices.

**Parameters**:

- `devices?` ([`evdev.Device`]`[]`)

**Returns**:

- **value** ([`evdev.Selector`])

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })
```

---

### `add(device)` {#add}

Add a device to this selector.

**Parameters**:

- `device` ([`evdev.Device`])

**Returns**:

- **value** (`self`)

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1 })

sel:add(kb2)
```

---

### `clear()` {#clear}

Remove all devices from this selector.

**Returns**:

- **value** (`self`)

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

sel:clear()
```

---

### `events()` {#events}

Return an iterator that yields events from registered devices.

**Returns**:

- **value** (`fun(): (dev?: `[`evdev.Device`]`, ev?: `[`evdev.event`]`)`)

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

for dev, e in sel:events() do
  print(dev.name, e.code, e.value)
end
```

---

### `poll()` {#poll}

Wait until at least one registered device has input available.

**Returns**:

- `devs?` ([`evdev.Device`]`[]`)
- `err?` (`string`)

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

for _, dev in ipairs(assert(sel:poll())) do
  print(dev)
end
```

---

### `remove(device)` {#remove}

Remove a device from this selector.

**Parameters**:

- `device` ([`evdev.Device`])

**Returns**:

- **value** (`self`)

**Example**:

```lua
local kb1 = assert(Device("/dev/input/event5"))
local kb2 = assert(Device("/dev/input/event10"))
local sel = Selector({ kb1, kb2 })

sel:remove(kb2)
```

<!-- markdownlint-disable MD053 -->
<!-- prettier-ignore-start -->
[`add(device)`]: #add
[`clear()`]: #clear
[`evdev.Device`]: /evdev/api/device
[`evdev.Selector`]: /evdev/api/selector
[`evdev.event`]: /evdev/types#evdev-event
[`events()`]: #events
[`new(devices?)`]: #new
[`poll()`]: #poll
[`remove(device)`]: #remove
<!-- prettier-ignore-end -->
<!-- markdownlint-enable MD053 -->
