| Key           | Type        | Description                                                            |
| ------------- | ----------- | ---------------------------------------------------------------------- |
| `name`        | `string`    | Device name (default: `"Lua evdev virtual keyboard"`)                  |
| `path`        | `string`    | uinput control node (default: `"/dev/uinput"`)                         |
| `keys`        | `integer[]` | Key/button codes to expose (default: all real [KEY_*]/[BTN_*])         |
| `rels`        | `integer[]` | Relative axes to expose (default: all real [REL_*])                    |
| `event_types` | `integer[]` | Event types to enable (default: auto-detected from fields, see [EV_*]) |
| `bustype`     | `integer`   | Linux bus type (default: `BUS_USB` = `3`)                              |
| `vendor`      | `integer`   | Vendor ID (default: `0x1209`)                                          |
| `product`     | `integer`   | Product ID (default: `0xE7DE`)                                         |
| `version`     | `integer`   | Version number (default: `1`)                                          |

[KEY_*]: ../api/ecodes#key
[BTN_*]: ../api/ecodes#btn
[REL_*]: ../api/ecodes#rel
[EV_*]: ../api/ecodes#ev
