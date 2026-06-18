---
title: "events"
description: "Event value constants and event predicates."
---

Event value constants and event predicates.

## Usage

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

| Function              | Description                                      |
| --------------------- | ------------------------------------------------ |
| [`is_abs(event)`]     | Return whether an event has type `EV_ABS`.       |
| [`is_key(event)`]     | Return whether an event has type `EV_KEY`.       |
| [`is_press(event)`]   | Return whether an event is a key/button press.   |
| [`is_rel(event)`]     | Return whether an event has type `EV_REL`.       |
| [`is_release(event)`] | Return whether an event is a key/button release. |
| [`is_repeat(event)`]  | Return whether an event is a key repeat.         |
| [`is_syn(event)`]     | Return whether an event has type `EV_SYN`.       |

### `is_abs(event)` {#is-abs}

Return whether an event has type `EV_ABS`.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_ABS }
print(evdev.events.is_abs(e)) --> true
```

---

### `is_key(event)` {#is-key}

Return whether an event has type `EV_KEY`.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY }
print(evdev.events.is_key(e)) --> true
```

---

### `is_press(event)` {#is-press}

Return whether an event is a key/button press.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.PRESS }
print(evdev.events.is_press(e)) --> true
```

---

### `is_rel(event)` {#is-rel}

Return whether an event has type `EV_REL`.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_REL }
print(evdev.events.is_rel(e)) --> true
```

---

### `is_release(event)` {#is-release}

Return whether an event is a key/button release.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.RELEASE }
print(evdev.events.is_release(e)) --> true
```

---

### `is_repeat(event)` {#is-repeat}

Return whether an event is a key repeat.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_KEY, value = evdev.events.REPEAT }
print(evdev.events.is_repeat(e)) --> true
```

---

### `is_syn(event)` {#is-syn}

Return whether an event has type `EV_SYN`.

**Parameters**:

- `event` ([`evdev.event`])

**Returns**:

- **value** (`boolean`)

**Example**:

```lua
local e = { type = evdev.ecodes.EV_SYN }
print(evdev.events.is_syn(e)) --> true
```

<!-- markdownlint-disable MD053 -->
<!-- prettier-ignore-start -->
[`evdev.event`]: /evdev/types#evdev-event
[`is_abs(event)`]: #is-abs
[`is_key(event)`]: #is-key
[`is_press(event)`]: #is-press
[`is_rel(event)`]: #is-rel
[`is_release(event)`]: #is-release
[`is_repeat(event)`]: #is-repeat
[`is_syn(event)`]: #is-syn
<!-- prettier-ignore-end -->
<!-- markdownlint-enable MD053 -->
