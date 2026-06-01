---
description: "Event value constants and event predicates."
---

# `events`

Event value constants and event predicates.

```lua
local e = {
  type = evdev.ecodes.EV_KEY,
  value = evdev.events.RELEASE
}

print(evdev.events.is_release(e)) --> true
print(evdev.events.is_press(e))   --> false
print(evdev.events.is_repeat(e))  --> false
```

## Functions

| Function                              | Description                                      |
| ------------------------------------- | ------------------------------------------------ |
| [`is_abs(event)`](#fn-is-abs)         | Return whether an event has type `EV_ABS`.       |
| [`is_key(event)`](#fn-is-key)         | Return whether an event has type `EV_KEY`.       |
| [`is_press(event)`](#fn-is-press)     | Return whether an event is a key/button press.   |
| [`is_rel(event)`](#fn-is-rel)         | Return whether an event has type `EV_REL`.       |
| [`is_release(event)`](#fn-is-release) | Return whether an event is a key/button release. |
| [`is_repeat(event)`](#fn-is-repeat)   | Return whether an event is a key repeat.         |
| [`is_syn(event)`](#fn-is-syn)         | Return whether an event has type `EV_SYN`.       |

<a id="fn-is-abs"></a>

### `is_abs(event)`

Return whether an event has type `EV_ABS`.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_ABS }
print(evdev.events.is_abs(e)) --> true
```

<a id="fn-is-key"></a>

### `is_key(event)`

Return whether an event has type `EV_KEY`.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY }
print(evdev.events.is_key(e)) --> true
```

<a id="fn-is-press"></a>

### `is_press(event)`

Return whether an event is a key/button press.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.PRESS }
print(evdev.events.is_press(e)) --> true
```

<a id="fn-is-rel"></a>

### `is_rel(event)`

Return whether an event has type `EV_REL`.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_REL }
print(evdev.events.is_rel(e)) --> true
```

<a id="fn-is-release"></a>

### `is_release(event)`

Return whether an event is a key/button release.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.RELEASE }
print(evdev.events.is_release(e)) --> true
```

<a id="fn-is-repeat"></a>

### `is_repeat(event)`

Return whether an event is a key repeat.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.REPEAT }
print(evdev.events.is_repeat(e)) --> true
```

<a id="fn-is-syn"></a>

### `is_syn(event)`

Return whether an event has type `EV_SYN`.

**Parameters**:

- `event` (`evdev.event`)

**Return**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_SYN }
print(evdev.events.is_syn(e)) --> true
```
