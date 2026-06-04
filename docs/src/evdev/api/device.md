---
description: "One Linux input event returned by `Device:read()`."
---

# `device`

One Linux input event returned by `Device:read()`.

## Functions

| Function                                      | Description                                                           |
| --------------------------------------------- | --------------------------------------------------------------------- |
| [`close()`](#fn-close)                        | Close the device.                                                     |
| [`events()`](#fn-events)                      | Return an iterator that waits for and yields input events one by one. |
| [`fd()`](#fn-fd)                              | Return the underlying Linux file descriptor.                          |
| [`flush()`](#fn-flush)                        | Drain queued events and return how many were discarded.               |
| [`get_repeat()`](#fn-get-repeat)              | Return the current auto-repeat delay and period in milliseconds.      |
| [`grab()`](#fn-grab)                          | Take exclusive control of the input device.                           |
| [`is_device(value)`](#fn-is-device)           | Return whether a value is an `evdev.Device` instance.                 |
| [`is_open()`](#fn-is-open)                    | Return whether this device handle still has an open file descriptor.  |
| [`open(path)`](#fn-open)                      | Open an input device by path.                                         |
| [`poll()`](#fn-poll)                          | Wait in the kernel until this device has input available.             |
| [`read()`](#fn-read)                          | Read one input event. Returns `nil` when no event is queued.          |
| [`set_repeat(delay, period)`](#fn-set-repeat) | Set the auto-repeat delay and period in milliseconds.                 |
| [`ungrab()`](#fn-ungrab)                      | Release exclusive control of the input device.                        |

<a id="fn-close"></a>

### `close()`

Close the device.

**Return**:

- `ok` (`boolean`): `true` when the device closes successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

print(dev:is_open()) --> true
dev:close()
print(dev:is_open()) --> false
```

<a id="fn-events"></a>

### `events()`

Return an iterator that waits for and yields input events one by one.

**Return**:

- `evdev.event?` (`fun():`)

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

for e in dev:events() do
  if e.type == ecodes.EV_KEY then
    print(e.code, e.value)
  end
end
```

<a id="fn-fd"></a>

### `fd()`

Return the underlying Linux file descriptor.

**Return**:

- `fd` (`evdev.fd?`): Linux file descriptor.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

local fd = dev:fd()
print(fd)
```

<a id="fn-flush"></a>

### `flush()`

Drain queued events and return how many were discarded.

This is useful after grabbing a device when you want to ignore any stale events
that were already queued.

**Return**:

- `count` (`integer?`): Number of discarded events.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

assert(dev:grab())
-- Move the mouse or press keys during the sleep.

local dropped = assert(dev:flush())
print("discarded", dropped, "stale events")
```

<a id="fn-get-repeat"></a>

### `get_repeat()`

Return the current auto-repeat delay and period in milliseconds.

**Return**:

- `delay` (`integer?`): Initial delay before repeating (milliseconds).
- `period` (`integer?`): Interval between repeats (milliseconds).
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

local delay, period, err = dev:get_repeat()
assert(delay, err)
print(delay, period)
```

<a id="fn-grab"></a>

### `grab()`

Take exclusive control of the input device.

**Return**:

- `ok` (`true?`): `true` when the device is grabbed successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))
assert(dev:grab())
```

<a id="fn-is-device"></a>

### `is_device(value)`

Return whether a value is an `evdev.Device` instance.

**Parameters**:

- `value` (`any`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local Device = evdev.device.open
local is_device = evdev.device.is_device

local dev = assert(Device("/dev/input/eventX"))
print(is_device(dev)) --> true
print(is_device({}))  --> false
```

<a id="fn-is-open"></a>

### `is_open()`

Return whether this device handle still has an open file descriptor.

**Return**:

- `isOpen` (`boolean`): `true` when the device is still open.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

if dev:is_open()
  then dev:close()
end
```

<a id="fn-open"></a>

### `open(path)`

Open an input device by path.

**Parameters**:

- `path` (`evdev.path`)

**Return**:

- `dev` (`evdev.Device?`): Open input device.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))
```

<a id="fn-poll"></a>

### `poll()`

Wait in the kernel until this device has input available.

This does not spin the CPU. It returns when `read()` can fetch at least one
queued event.

**Return**:

- `ready` (`boolean?`): `true` when input is ready to read.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
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

<a id="fn-read"></a>

### `read()`

Read one input event. Returns `nil` when no event is queued.

**Return**:

- `event` (`evdev.event?`): Next queued input event.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
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

<a id="fn-set-repeat"></a>

### `set_repeat(delay, period)`

Set the auto-repeat delay and period in milliseconds.

**Parameters**:

- `delay` (`integer`): Initial delay before repeating (milliseconds).
- `period` (`integer`): Interval between repeats (milliseconds).

**Return**:

- `ok` (`true?`): `true` when the repeat settings are updated successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))

local delay, period, err = dev:get_repeat()
assert(delay, err)
print(delay, period)

assert(dev:set_repeat(300, 40))
print(dev:get_repeat())
```

<a id="fn-ungrab"></a>

### `ungrab()`

Release exclusive control of the input device.

**Return**:

- `ok` (`true?`): `true` when the grab is released successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local Device = evdev.device.open
local dev = assert(Device("/dev/input/eventX"))
assert(dev:grab())
assert(dev:ungrab())
```
