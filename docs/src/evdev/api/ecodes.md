# `ecodes`

Linux input event code constants used when reading events from `/dev/input` or
emitting events through `uinput`.

## Usage

```lua
local evdev = require "evdev"

local Device = evdev.device.open
local dev = assert(Device("/dev/input/event3"))

for e in dev:events() do
  if e.type == evdev.ecodes.EV_KEY and e.code == evdev.ecodes.KEY_ENTER then
    print("Enter key event", e.value)
  end
end
```

## [`EV`]

Event type constants used in the `type` field of Linux input events.

## [`SYN`]

Synchronization constants used to separate or mark input event packets.

## [`REL`]

Relative axis constants used with `EV_REL` events, such as mouse movement and
wheel input.

## [`BTN`]

Button constants used with `EV_KEY` events for mouse, joystick, gamepad, tablet,
and other button-like inputs.

## [`KEY`]

Keyboard and consumer key constants used with `EV_KEY` events.

[`EV`]: ../types#ev
[`SYN`]: ../types#syn
[`REL`]: ../types#rel
[`BTN`]: ../types#btn
[`KEY`]: ../types#key
