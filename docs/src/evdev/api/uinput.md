---
description: "Configuration used to create a `/dev/uinput` virtual device."
---

# `uinput`

Configuration used to create a `/dev/uinput` virtual device.

## Functions

| Function                                      | Description                                                   |
| --------------------------------------------- | ------------------------------------------------------------- |
| [`close()`](#fn-close)                        | Destroy and close the virtual device.                         |
| [`create(spec?)`](#fn-create)                 | Create a virtual input device.                                |
| [`emit(type, code, value)`](#fn-emit)         | Emit one raw input event.                                     |
| [`fd()`](#fn-fd)                              | Get the file descriptor of the virtual device.                |
| [`get_repeat()`](#fn-get-repeat)              | Get the current keyboard repeat rate from the virtual device. |
| [`is_open()`](#fn-is-open)                    | Return whether the virtual device is still open.              |
| [`set_repeat(delay, period)`](#fn-set-repeat) | Set the keyboard repeat rate on the virtual device.           |
| [`sync()`](#fn-sync)                          | Emit a `SYN_REPORT` event.                                    |

<a id="fn-close"></a>

### `close()`

Destroy and close the virtual device.

**Return**:

- `ok` (`boolean`): `true` when the virtual device closes successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())
ui:close()
```

<a id="fn-create"></a>

### `create(spec?)`

Create a virtual input device.

**Parameters**:

- `spec?` (`evdev.uinputSpec`): Virtual device configuration.

**Return**:

- `dev` (`evdev.UInput?`): Open virtual device.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())

ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 1)
ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_A, 0)
ui:sync()

print(ui.path)
```

<a id="fn-emit"></a>

### `emit(type, code, value)`

Emit one raw input event.

**Parameters**:

- `type` (`evdev.ecodes.ev`): Event type to emit.
- `code` (`evdev.ecodes.key|evdev.ecodes.btn|evdev.ecodes.rel`): Event code
  within the selected type.
- `value` (`evdev.eventValue`): Event value to send.

**Return**:

- `ok` (`true?`): `true` when the event is emitted successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
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

<a id="fn-fd"></a>

### `fd()`

Get the file descriptor of the virtual device.

**Return**:

- `fd` (`evdev.fd?`): Linux file descriptor.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())
print(ui:fd())
```

<a id="fn-get-repeat"></a>

### `get_repeat()`

Get the current keyboard repeat rate from the virtual device.

**Return**:

- `delay` (`integer?`): Repeat delay in milliseconds.
- `period` (`integer?`): Repeat period in milliseconds.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())

local delay, period, err = ui:get_repeat()
assert(delay, err)
print(delay, period)
```

<a id="fn-is-open"></a>

### `is_open()`

Return whether the virtual device is still open.

**Return**:

- `is_open` (`boolean`): `true` when the virtual device is still open.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())

if ui:is_open() then
  ui:close()
end
```

<a id="fn-set-repeat"></a>

### `set_repeat(delay, period)`

Set the keyboard repeat rate on the virtual device.

**Parameters**:

- `delay` (`integer`): Delay in milliseconds before key repeat starts.
- `period` (`integer`): Period in milliseconds between repeated key events.

**Return**:

- `ok` (`true?`): `true` when the repeat rate is set successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())

-- Set repeat delay to 500ms, repeat period to 50ms
ui:set_repeat(500, 50)
```

<a id="fn-sync"></a>

### `sync()`

Emit a `SYN_REPORT` event.

Flush queued input events as one frame.

**Return**:

- `ok` (`true?`): `true` when `SYN_REPORT` is emitted successfully.
- `err` (`string?`): Error message on failure.

**Example**:

```lua
local UInput = evdev.uinput.create
local ui = assert(UInput())

ui:emit(evdev.ecodes.EV_KEY, evdev.ecodes.KEY_LEFTSHIFT, 0)
ui:sync()
```
