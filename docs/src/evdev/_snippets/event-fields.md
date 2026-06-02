| Key      | Type       | Description                                                     |
| -------- | ---------- | --------------------------------------------------------------- |
| `type`   | `integer`  | Event type, e.g. `EV_KEY` (`1`), `EV_REL` (`2`), `EV_ABS` (`3`) |
| `code`   | `integer`  | Key/button/axis code, e.g. `KEY_A` (`30`), `REL_X` (`0`)        |
| `value`  | `integer`  | `0` = release, `1` = press, `2` = repeat (for keys)             |
| `sec`    | `integer?` | Timestamp seconds                                               |
| `usec`   | `integer?` | Timestamp microseconds                                          |
| `device` | `table`    | The Device object that produced this event                      |
