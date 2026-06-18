---
title: "device"
description: "Query and monitor physical Linux input devices."
---

Query and monitor physical Linux input devices.

## Usage

```lua
local evdev = require "evdev"
local Device = evdev.device.open

-- Open an input device (e.g., event0)
local dev = assert(Device("/dev/input/event0"))
print("Opened device: " .. dev.name)

-- Process events in a loop
for ev in dev:events() do
  if evdev.events.is_press(ev) then
    print("Key Pressed! Code: " .. ev.code)
  end
end
```

## Functions

| Function                      | Description                                                           |
| ----------------------------- | --------------------------------------------------------------------- |
| [`close()`]                   | Close the device.                                                     |
| [`events()`]                  | Return an iterator that waits for and yields input events one by one. |
| [`fd()`]                      | Return the underlying Linux file descriptor.                          |
| [`flush()`]                   | Drain queued events and return how many were discarded.               |
| [`get_repeat()`]              | Return the current auto-repeat delay and period in milliseconds.      |
| [`grab()`]                    | Take exclusive control of the input device.                           |
| [`is_device(value)`]          | Return whether a value is an [`evdev.Device`] instance.               |
| [`is_open()`]                 | Return whether this device handle still has an open file descriptor.  |
| [`open(path)`]                | Open an input device by path.                                         |
| [`poll()`]                    | Wait in the kernel until this device has input available.             |
| [`read()`]                    | Read one input event. Returns `nil` when no event is queued.          |
| [`set_repeat(delay, period)`] | Set the auto-repeat delay and period in milliseconds.                 |
| [`ungrab()`]                  | Release exclusive control of the input device.                        |

### `close()` {#close}

Close the device.

**Returns**:

- `ok` (`boolean`): `true` when the device closes successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
print(dev:is_open()) --> true
dev:close()
print(dev:is_open()) --> false
```

---

### `events()` {#events}

Return an iterator that waits for and yields input events one by one.

**Returns**:

- **value** (`fun():(ev?: `[`evdev.event`]`)`)

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
for e in dev:events() do
  if e.type == ecodes.EV_KEY then
    print(e.code, e.value)
  end
end
```

---

### `fd()` {#fd}

Return the underlying Linux file descriptor.

**Returns**:

- `fd?` ([`evdev.fd`]): Linux file descriptor.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
local fd = dev:fd()
print(fd)
```

---

### `flush()` {#flush}

Drain queued events and return how many were discarded.

This is useful after grabbing a device when you want to ignore any stale events
that were already queued.

**Returns**:

- `count?` (`integer`): Number of discarded events.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
assert(dev:grab())
-- Move the mouse or press keys during the sleep.

local dropped = assert(dev:flush())
print("discarded", dropped, "stale events")
```

---

### `get_repeat()` {#get-repeat}

Return the current auto-repeat delay and period in milliseconds.

**Returns**:

- `delay?` (`integer`): Initial delay before repeating (milliseconds).
- `period?` (`integer`): Interval between repeats (milliseconds).
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
local delay, period, err = dev:get_repeat()
assert(delay, err)
print(delay, period)
```

---

### `grab()` {#grab}

Take exclusive control of the input device.

**Returns**:

- `ok?` (`true`): `true` when the device is grabbed successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
assert(dev:grab())
```

---

### `is_device(value)` {#is-device}

Return whether a value is an [`evdev.Device`] instance.

**Parameters**:

- `value` (`any`)

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local Device = evdev.device.open
local is_device = evdev.device.is_device

local dev = assert(Device("/dev/input/eventX"))
print(is_device(dev)) --> true
print(is_device({}))  --> false
```

---

### `is_open()` {#is-open}

Return whether this device handle still has an open file descriptor.

**Returns**:

- `isOpen` (`boolean`): `true` when the device is still open.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
if dev:is_open()
  then dev:close()
end
```

---

### `open(path)` {#open}

Open an input device by path.

**Parameters**:

- `path` ([`evdev.path`])

**Returns**:

- `dev?` ([`evdev.Device`]): Open input device.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(evdev.device.open("/dev/input/eventX"))
```

---

### `poll()` {#poll}

Wait in the kernel until this device has input available.

This does not spin the CPU. It returns when [`evdev.device.read()`] can fetch at
least one queued event.

**Returns**:

- `ready?` (`boolean`): `true` when input is ready to read.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ecodes = evdev.ecodes
local dev = assert(Device("/dev/input/eventX"))

-- This is the manual form of `dev:events()`.
while true do
  if assert(dev:poll()) then
    local e = assert(dev:read())
    if e.type == ecodes.EV_KEY then
      print(e.code, e.value)
    end
  end
end
```

---

### `read()` {#read}

Read one input event. Returns `nil` when no event is queued.

**Returns**:

- `event?` ([`evdev.event`]): Next queued input event.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
-- This is the manual form of `dev:events()`.
while true do
  if assert(dev:poll()) then
    local e = assert(dev:read())
    if e.type == ecodes.EV_KEY then
      print(e.code, e.value)
    end
  end
end
```

---

### `set_repeat(delay, period)` {#set-repeat}

Set the auto-repeat delay and period in milliseconds.

**Parameters**:

- `delay` (`integer`): Initial delay before repeating (milliseconds).
- `period` (`integer`): Interval between repeats (milliseconds).

**Returns**:

- `ok?` (`true`): `true` when the repeat settings are updated successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
local delay, period, err = dev:get_repeat()

assert(delay, err)
print(delay, period)

assert(dev:set_repeat(300, 40))
print(dev:get_repeat())
```

---

### `ungrab()` {#ungrab}

Release exclusive control of the input device.

**Returns**:

- `ok?` (`true`): `true` when the grab is released successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local dev = assert(Device("/dev/input/eventX"))
assert(dev:grab())
assert(dev:ungrab())
```

<!-- markdownlint-disable MD053 -->
<!-- prettier-ignore-start -->
[`close()`]: #close
[`evdev.Device`]: /evdev/api/device
[`evdev.device.read()`]: /evdev/api/device#read
[`evdev.event`]: /evdev/types#evdev-event
[`evdev.fd`]: /evdev/types#evdev-fd
[`evdev.path`]: /evdev/types#evdev-path
[`events()`]: #events
[`fd()`]: #fd
[`flush()`]: #flush
[`get_repeat()`]: #get-repeat
[`grab()`]: #grab
[`is_device(value)`]: #is-device
[`is_open()`]: #is-open
[`open(path)`]: #open
[`poll()`]: #poll
[`read()`]: #read
[`set_repeat(delay, period)`]: #set-repeat
[`ungrab()`]: #ungrab
<!-- prettier-ignore-end -->
<!-- markdownlint-enable MD053 -->
