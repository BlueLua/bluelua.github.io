---
title: "devices"
description: "Input device discovery helpers."
---

Input device discovery helpers.

## Usage

```lua
local devices = assert(evdev.devices.list_devices())
print(#devices)
```

## Functions

| Function              | Description                                                                 |
| --------------------- | --------------------------------------------------------------------------- |
| [`device_info(path)`] | Read metadata for one input device by path.                                 |
| [`find(query)`]       | Return the first discovered input device matching a path or a device name.  |
| [`find_all(query)`]   | Return all discovered input devices matching a path, alias, or device name. |
| [`list_devices()`]    | List evdev input devices under `/dev/input`.                                |

### `device_info(path)` {#device-info}

Read metadata for one input device by path.

**Parameters**:

- `path` ([`evdev.path`])

**Returns**:

- `info?` ([`evdev.deviceInfo`])
- `err?` (`string`)

**Example**:

```lua
local dev = assert(evdev.devices.device_info("/dev/input/event3"))
print(dev.name)
```

---

### `find(query)` {#find}

Return the first discovered input device matching a path or a device name.

**Parameters**:

- `query` (`string`): Exact device path, by-id path, by-path path, or device
  name.

**Returns**:

- `dev?` ([`evdev.deviceInfo`])
- `err?` (`string`)

**Example**:

```lua
local find = evdev.devices.find

local by_event_path = find("/dev/input/event3")
local by_path_alias = find("/dev/input/by-path/platform-i8042-serio-0-event-kbd")
local by_id_alias   = find("/dev/input/by-id/usb-Example-event-kbd")
local by_name       = find("AT Translated Set 2 keyboard")

print(by_event_path and by_event_path.name)
print(by_path_alias and by_path_alias.path)
print(by_id_alias   and by_id_alias.path)
print(by_name       and by_name.path)
```

---

### `find_all(query)` {#find-all}

Return all discovered input devices matching a path, alias, or device name.

**Parameters**:

- `query` (`string`): Exact device path, by-id path, by-path path, or device
  name.

**Returns**:

- `devs?` ([`evdev.deviceInfo`]`[]`)
- `err?` (`string`)

**Example**:

```lua
local find_all = evdev.devices.find_all

local by_event_path = assert(find_all("/dev/input/event3"))
local by_path_alias = assert(find_all("/dev/input/by-path/platform-i8042-serio-0-event-kbd"))
local by_id_alias   = assert(find_all("/dev/input/by-id/usb-Example-event-kbd"))
local by_name       = assert(find_all("AT Translated Set 2 keyboard"))

print(#by_event_path)
print(#by_path_alias)
print(#by_id_alias)
print(#by_name)
```

---

### `list_devices()` {#list-devices}

List evdev input devices under `/dev/input`.

**Returns**:

- `devs?` ([`evdev.deviceInfo`]`[]`)
- `err?` (`string`)

**Example**:

```lua
local devs = assert(evdev.devices.list_devices())
for _, dev in ipairs(devs) do
  print(dev.path, dev.name)
end
```

<!-- prettier-ignore-start -->
[`device_info(path)`]: #device-info
[`evdev.deviceInfo`]: /evdev/types#evdev-deviceinfo
[`evdev.path`]: /evdev/types#evdev-path
[`find(query)`]: #find
[`find_all(query)`]: #find-all
[`list_devices()`]: #list-devices
<!-- prettier-ignore-end -->
