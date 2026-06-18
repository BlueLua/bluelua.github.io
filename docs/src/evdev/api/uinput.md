---
title: "uinput"
description: "Create and control virtual input devices using `/dev/uinput`."
---

Create and control virtual input devices using `/dev/uinput`.

## Usage

```lua
local evdev = require "evdev"

local ecodes = evdev.ecodes
local UInput = evdev.uinput.create

-- Create a virtual keyboard device
local ui = assert(UInput())
print("Virtual device created at: " .. ui.path)

-- Simulate typing Shift + A
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 1)
ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 1)
ui:sync()

ui:emit(ecodes.EV_KEY, ecodes.KEY_A, 0)
ui:emit(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 0)
ui:sync()

ui:close()
```

## Functions

| Function                      | Description                                                   |
| ----------------------------- | ------------------------------------------------------------- |
| [`close()`]                   | Destroy and close the virtual device.                         |
| [`create(spec?)`]             | Create a virtual input device.                                |
| [`emit(type, code, value)`]   | Emit one raw input event.                                     |
| [`fd()`]                      | Get the file descriptor of the virtual device.                |
| [`get_repeat()`]              | Get the current keyboard repeat rate from the virtual device. |
| [`is_open()`]                 | Return whether the virtual device is still open.              |
| [`set_repeat(delay, period)`] | Set the keyboard repeat rate on the virtual device.           |
| [`sync()`]                    | Emit a `SYN_REPORT` event.                                    |

### `close()` {#close}

Destroy and close the virtual device.

**Returns**:

- `ok` (`boolean`): `true` when the virtual device closes successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())
ui:close()
```

---

### `create(spec?)` {#create}

Create a virtual input device.

**Parameters**:

- `spec?` ([`evdev.uinputSpec`]): Virtual device configuration.

**Returns**:

- `dev?` ([`evdev.UInput`]): Open virtual device.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())

ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 1)
ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 0)
ui:sync()

print(ui.path)
```

---

### `emit(type, code, value)` {#emit}

Emit one raw input event.

**Parameters**:

- `type` ([`evdev.ecodes.ev`]): Event type to emit.
- `code` ([`evdev.ecodes.key`] | [`evdev.ecodes.btn`] | [`evdev.ecodes.rel`]):
  Event code within the selected type.
- `value` ([`evdev.eventValue`]): Event value to send.

**Returns**:

- `ok?` (`true`): `true` when the event is emitted successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())

local EV_KEY = evdev.ecodes.EV_KEY
ui:emit(EV_KEY, evdev.ecodes.KEY_A, 1)
ui:emit(EV_KEY, evdev.ecodes.KEY_A, 0)
ui:sync()

local EV_REL = evdev.ecodes.EV_REL
ui:emit(EV_REL, evdev.ecodes.REL_X, 20)
ui:emit(EV_REL, evdev.ecodes.REL_Y, 10)
ui:sync()
```

---

### `fd()` {#fd}

Get the file descriptor of the virtual device.

**Returns**:

- `fd?` ([`evdev.fd`]): Linux file descriptor.

**Example**:

```lua
local ui = assert(UInput())
print(ui:fd())
```

---

### `get_repeat()` {#get-repeat}

Get the current keyboard repeat rate from the virtual device.

**Returns**:

- `delay?` (`integer`): Repeat delay in milliseconds.
- `period?` (`integer`): Repeat period in milliseconds.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())
local delay, period, err = ui:get_repeat()
assert(delay, err)
print(delay, period)
```

---

### `is_open()` {#is-open}

Return whether the virtual device is still open.

**Returns**:

- `is_open` (`boolean`): `true` when the virtual device is still open.

**Example**:

```lua
local ui = assert(UInput())
if ui:is_open() then
  ui:close()
end
```

---

### `set_repeat(delay, period)` {#set-repeat}

Set the keyboard repeat rate on the virtual device.

**Parameters**:

- `delay` (`integer`): Delay in milliseconds before key repeat starts.
- `period` (`integer`): Period in milliseconds between repeated key events.

**Returns**:

- `ok?` (`true`): `true` when the repeat rate is set successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())
-- Set repeat delay to 500ms, repeat period to 50ms
ui:set_repeat(500, 50)
```

---

### `sync()` {#sync}

Emit a `SYN_REPORT` event.

Flush queued input events as one frame.

**Returns**:

- `ok?` (`true`): `true` when `SYN_REPORT` is emitted successfully.
- `err?` (`string`): Error message on failure.

**Example**:

```lua
local ui = assert(UInput())
ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_LEFTSHIFT, 0)
ui:sync()
```

<!-- markdownlint-disable MD053 -->
<!-- prettier-ignore-start -->
[`close()`]: #close
[`create(spec?)`]: #create
[`emit(type, code, value)`]: #emit
[`evdev.UInput`]: /evdev/api/uinput
[`evdev.ecodes.btn`]: /evdev/api/ecodes
[`evdev.ecodes.ev`]: /evdev/api/ecodes
[`evdev.ecodes.key`]: /evdev/api/ecodes
[`evdev.ecodes.rel`]: /evdev/api/ecodes
[`evdev.eventValue`]: /evdev/types#evdev-eventvalue
[`evdev.fd`]: /evdev/types#evdev-fd
[`evdev.uinputSpec`]: /evdev/types#evdev-uinputspec
[`fd()`]: #fd
[`get_repeat()`]: #get-repeat
[`is_open()`]: #is-open
[`set_repeat(delay, period)`]: #set-repeat
[`sync()`]: #sync
<!-- prettier-ignore-end -->
<!-- markdownlint-enable MD053 -->
