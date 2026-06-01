---
description: "Configuration used to create a `/dev/uinput` virtual device."
---

# `uinput`

Configuration used to create a `/dev/uinput` virtual device.

## Functions

| Function                              | Description                                      |
| ------------------------------------- | ------------------------------------------------ |
| [`close()`](#fn-close)                | Destroy and close the virtual device.            |
| [`create(spec?)`](#fn-create)         | Create a virtual input device.                   |
| [`emit(type, code, value)`](#fn-emit) | Emit one raw input event.                        |
| [`is_open()`](#fn-is-open)            | Return whether the virtual device is still open. |
| [`sync()`](#fn-sync)                  | Emit a `SYN_REPORT` event.                       |

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

-- Give the system a moment to notice the new virtual device.
-- Replace this with your preferred sleep helper.
os.execute("sleep 0.5")

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

-- Give the system a moment to notice the new virtual device.
-- Replace this with your preferred sleep helper.
os.execute("sleep 0.5")

local EV_KEY = evdev.ecodes.EV_KEY
ui:emit(EV_KEY, evdev.ecodes.KEY_A, 1)
ui:emit(EV_KEY, evdev.ecodes.KEY_A, 0)
ui:sync()

local EV_REL = evdev.ecodes.EV_REL
ui:emit(EV_REL, evdev.ecodes.REL_X, 20)
ui:emit(EV_REL, evdev.ecodes.REL_Y, 10)
ui:sync()
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
