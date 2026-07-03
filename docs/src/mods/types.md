---
title: "Types"
description: "Types defined in the mods module."
pageClass: "types-page"
---

Types defined in the mods module.

## [`mods.calendarMonth`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L13-L27)

Month number (1-12) where 1 is January and 12 is December.

| Value | Description |
| ----- | ----------- |
| `1`   | January     |
| `2`   | February    |
| `3`   | March       |
| `4`   | April       |
| `5`   | May         |
| `6`   | June        |
| `7`   | July        |
| `8`   | August      |
| `9`   | September   |
| `10`  | October     |
| `11`  | November    |
| `12`  | December    |

## [`mods.calendarMonthDay`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L28-L61)

Day of the month (1-31).

| Value | Description           |
| ----- | --------------------- |
| `1`   | 1st day of the month  |
| `2`   | 2nd day of the month  |
| `3`   | 3rd day of the month  |
| `4`   | 4th day of the month  |
| `5`   | 5th day of the month  |
| `6`   | 6th day of the month  |
| `7`   | 7th day of the month  |
| `8`   | 8th day of the month  |
| `9`   | 9th day of the month  |
| `10`  | 10th day of the month |
| `11`  | 11th day of the month |
| `12`  | 12th day of the month |
| `13`  | 13th day of the month |
| `14`  | 14th day of the month |
| `15`  | 15th day of the month |
| `16`  | 16th day of the month |
| `17`  | 17th day of the month |
| `18`  | 18th day of the month |
| `19`  | 19th day of the month |
| `20`  | 20th day of the month |
| `21`  | 21st day of the month |
| `22`  | 22nd day of the month |
| `23`  | 23rd day of the month |
| `24`  | 24th day of the month |
| `25`  | 25th day of the month |
| `26`  | 26th day of the month |
| `27`  | 27th day of the month |
| `28`  | 28th day of the month |
| `29`  | 29th day of the month |
| `30`  | 30th day of the month |
| `31`  | 31st day of the month |

## [`mods.calendarWeekday`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L3-L12)

Weekday number (1-7) where 1 is Monday and 7 is Sunday.

| Value | Description |
| ----- | ----------- |
| `1`   | Monday      |
| `2`   | Tuesday     |
| `3`   | Wednesday   |
| `4`   | Thursday    |
| `5`   | Friday      |
| `6`   | Saturday    |
| `7`   | Sunday      |

## [`mods.DateParts`](https://github.com/BlueLua/mods/blob/main/types/date.d.lua#L3-L15)

Representation of date components.

| Key      | Type      | Description                                                        |
| -------- | --------- | ------------------------------------------------------------------ |
| `day?`   | `integer` | The day of the month (`1` to `31`).                                |
| `hour?`  | `integer` | The hour of the day (`0` to `23`).                                 |
| `isdst?` | `boolean` | `true` if Daylight Saving Time (DST) is active, `false` otherwise. |
| `min?`   | `integer` | The minute of the hour (`0` to `59`).                              |
| `month?` | `integer` | The month of the year (`1` to `12`).                               |
| `ms?`    | `integer` | The millisecond of the second (`0` to `999`).                      |
| `sec?`   | `integer` | The second of the minute (`0` to `59`).                            |
| `wday?`  | `integer` | The weekday number (typically `1` to `7` where Sunday is `1`).     |
| `yday?`  | `integer` | The day of the year (`1` to `366`).                                |
| `year`   | `integer` | The 4-digit year (e.g., `2026`).                                   |

## [`mods.DurationHumanizeOptions`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L56-L63)

Configuration options for humanizing durations into relative-style strings.

| Key            | Type                                                                                                 | Description                                             |
| -------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `max_unit?`    | <code><a href="/mods/types#mods-durationunit">mods.durationUnit</a></code>                           | Largest unit allowed when choosing the displayed unit.  |
| `min_unit?`    | <code><a href="/mods/types#mods-durationunit">mods.durationUnit</a></code>                           | Smallest unit allowed when choosing the displayed unit. |
| `round?`       | <code><a href="/mods/types#mods-durationhumanizeroundmode">mods.durationHumanizeRoundMode</a></code> | Rounding mode for custom unit output.                   |
| `short?`       | `boolean`                                                                                            | Whether to use abbreviated unit labels like `2h`.       |
| `with_suffix?` | `boolean`                                                                                            | Whether to include `ago` / `in` style wording.          |

## [`mods.durationHumanizeRoundMode`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L15-L21)

Rounding mode to use when humanizing durations.

| Value     | Description                             |
| --------- | --------------------------------------- |
| `"ceil"`  | Round up (ceil).                        |
| `"floor"` | Round down (floor).                     |
| `"round"` | Round to the nearest integer.           |
| `boolean` | Whether to round (true) or not (false). |

## [`mods.DurationParts`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L3-L14)

Representation of duration parts.

| Key             | Type     | Description                                     |
| --------------- | -------- | ----------------------------------------------- |
| `days?`         | `number` | The day component (7 days = 1 week).            |
| `hours?`        | `number` | The hour component (24 hours = 1 day).          |
| `milliseconds?` | `number` | The millisecond component (1000 ms = 1 second). |
| `minutes?`      | `number` | The minute component (60 minutes = 1 hour).     |
| `months?`       | `number` | The month component (12 months = 1 year).       |
| `quarters?`     | `number` | The quarter component (3 months = 1 quarter).   |
| `seconds?`      | `number` | The second component (60 seconds = 1 minute).   |
| `weeks?`        | `number` | The week component.                             |
| `years?`        | `number` | The year component.                             |

## [`mods.durationUnit`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L22-L55)

Supported units of time for duration representation and calculations.

| Value            | Description  |
| ---------------- | ------------ |
| `"d"`            | Days         |
| `"day"`          | Days         |
| `"days"`         | Days         |
| `"h"`            | Hours        |
| `"hour"`         | Hours        |
| `"hours"`        | Hours        |
| `"M"`            | Months       |
| `"m"`            | Minutes      |
| `"millisecond"`  | Milliseconds |
| `"milliseconds"` | Milliseconds |
| `"min"`          | Minutes      |
| `"mins"`         | Minutes      |
| `"minute"`       | Minutes      |
| `"minutes"`      | Minutes      |
| `"month"`        | Months       |
| `"months"`       | Months       |
| `"ms"`           | Milliseconds |
| `"q"`            | Quarters     |
| `"quarter"`      | Quarters     |
| `"quarters"`     | Quarters     |
| `"s"`            | Seconds      |
| `"sec"`          | Seconds      |
| `"second"`       | Seconds      |
| `"seconds"`      | Seconds      |
| `"secs"`         | Seconds      |
| `"w"`            | Weeks        |
| `"week"`         | Weeks        |
| `"weeks"`        | Weeks        |
| `"y"`            | Years        |
| `"year"`         | Years        |
| `"years"`        | Years        |

## [`mods.fsEntryType`](https://github.com/BlueLua/mods/blob/main/types/fs.d.lua#L3-L13)

Filesystem entry type.

| Value         | Description                           |
| ------------- | ------------------------------------- |
| `"block"`     | A block device.                       |
| `"char"`      | A character device.                   |
| `"directory"` | A directory.                          |
| `"fifo"`      | A named pipe (FIFO).                  |
| `"file"`      | A regular file.                       |
| `"link"`      | A symbolic link.                      |
| `"socket"`    | A socket.                             |
| `"unknown"`   | An unknown or unsupported entry type. |

## [`mods.GlobOptions`](https://github.com/BlueLua/mods/blob/main/types/glob.d.lua#L3-L9)

Options for glob matching and directory traversal.

| Key           | Type      | Description                                   |
| ------------- | --------- | --------------------------------------------- |
| `follow?`     | `boolean` | Whether to follow symbolic links.             |
| `hidden?`     | `boolean` | Whether to include hidden files/directories.  |
| `ignorecase?` | `boolean` | Whether to perform case-insensitive matching. |
| `recursive?`  | `boolean` | Whether to traverse directories recursively.  |

## [`mods.log.levelno`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L15-L24)

Numeric severity levels used for log message filtering.

| Name    | Value         | Description             |
| ------- | ------------- | ----------------------- |
| `debug` | `10`          | Debug messages.         |
| `error` | `40`          | Error messages.         |
| `info`  | `20`          | Informational messages. |
| `off`   | `"math.huge"` | Logging disabled.       |
| `warn`  | `30`          | Warning messages.       |

## [`mods.log.logger`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L67-L69)

| Key       | Type                                                                                         | Description                                                 |
| --------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `debug`   | `fun(...: any)`                                                                              | Emit a `debug` record.                                      |
| `error`   | `fun(...: any)`                                                                              | Emit an `error` record.                                     |
| `info`    | `fun(...: any)`                                                                              | Emit an `info` record.                                      |
| `log`     | <code>fun(levelname: <a href="/mods/types#mods-loglevel">mods.logLevel</a>, ...: any)</code> | Emit a record for `level` when it passes the logger filter. |
| `private` | `_levelno`                                                                                   | mods.log.levelno                                            |
| `warn`    | `fun(...: any)`                                                                              | Emit a `warn` record.                                       |

## [`mods.log.new.opts`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L35-L40)

Configuration options for creating a new logger instance.

| Key        | Type                                                                   | Description                                                                  |
| ---------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `handler?` | <code><a href="/mods/types#mods-loghandler">mods.logHandler</a></code> | Optional handler function that receives each emitted record.                 |
| `level?`   | <code><a href="/mods/types#mods-loglevel">mods.logLevel</a></code>     | Minimum enabled level; use `"off"` to disable logging. Defaults to `"warn"`. |
| `name?`    | `string`                                                               | Optional logger name included in emitted records.                            |

## [`mods.log.record`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L26-L34)

A single log entry containing metadata and the formatted message.

| Key         | Type                                                               | Description                          |
| ----------- | ------------------------------------------------------------------ | ------------------------------------ |
| `args`      | `{[integer]:any, n:integer}`                                       | Original variadic arguments.         |
| `levelname` | <code><a href="/mods/types#mods-loglevel">mods.logLevel</a></code> | Log level name.                      |
| `levelno`   | `integer`                                                          | Numeric severity used for filtering. |
| `line`      | `string`                                                           | Formatted plain-text log line.       |
| `message`   | `string`                                                           | Joined message string.               |

## [`mods.logHandler`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L12-L14)

Callback function for handling log records.

`fun(record: mods.log.record)`

## [`mods.logLevel`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L3-L11)

Log level name or severity threshold.

| Value     | Description                |
| --------- | -------------------------- |
| `"debug"` | Debug messages.            |
| `"error"` | Error messages.            |
| `"info"`  | Informational messages.    |
| `"off"`   | Logging disabled.          |
| `"warn"`  | Warning messages.          |
| `string`  | Any custom log level name. |

## [`mods.validatorName`](https://github.com/BlueLua/mods/blob/main/types/is.d.lua#L3-L27)

Supported validation and type check names.

| Value            | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `"block_device"` | A block device path.                                      |
| `"callable"`     | A function or table with a `__call` metamethod.           |
| `"char_device"`  | A character device path.                                  |
| `"defined"`      | A defined value (not nil).                                |
| `"device"`       | A character or block device path.                         |
| `"dir"`          | A directory path.                                         |
| `"false"`        | The boolean value false.                                  |
| `"falsy"`        | A falsy value (nil or false).                             |
| `"fifo"`         | A named pipe (FIFO) path.                                 |
| `"file"`         | A regular file path.                                      |
| `"finite"`       | A finite number.                                          |
| `"float"`        | A float number.                                           |
| `"infinite"`     | An infinite number.                                       |
| `"integer"`      | An integer number.                                        |
| `"nan"`          | A NaN (not-a-number) value.                               |
| `"path"`         | Any existing path or symbolic link.                       |
| `"socket"`       | A socket path.                                            |
| `"symlink"`      | A symbolic link path.                                     |
| `"true"`         | The boolean value true.                                   |
| `"truthy"`       | A truthy value (not nil and not false).                   |
| `string`         | Any validator name.                                       |
| `type`           | Any standard Lua type name (e.g., `"table"`, `"number"`). |

## [`modsValidatorMessages`](https://github.com/BlueLua/mods/blob/main/types/validate.d.lua#L3-L38)

Custom error message templates for validators, indexed by validator name.

| Key             | Type     | Description                                                      |
| --------------- | -------- | ---------------------------------------------------------------- |
| `[string]`      | `string` | Custom message template for a validator.                         |
| `block_device?` | `string` | Custom message template for block device validator failures.     |
| `boolean?`      | `string` | Custom message template for boolean validator failures.          |
| `callable?`     | `string` | Custom message template for callable validator failures.         |
| `cdata?`        | `string` | Custom message template for cdata validator failures.            |
| `char_device?`  | `string` | Custom message template for character device validator failures. |
| `defined?`      | `string` | Custom message template for defined validator failures.          |
| `device?`       | `string` | Custom message template for device validator failures.           |
| `dir?`          | `string` | Custom message template for directory validator failures.        |
| `false?`        | `string` | Custom message template for false validator failures.            |
| `falsy?`        | `string` | Custom message template for falsy validator failures.            |
| `fifo?`         | `string` | Custom message template for named pipe validator failures.       |
| `file?`         | `string` | Custom message template for file validator failures.             |
| `finite?`       | `string` | Custom message template for finite validator failures.           |
| `float?`        | `string` | Custom message template for float validator failures.            |
| `function?`     | `string` | Custom message template for function validator failures.         |
| `infinite?`     | `string` | Custom message template for infinite validator failures.         |
| `integer?`      | `string` | Custom message template for integer validator failures.          |
| `nan?`          | `string` | Custom message template for nan validator failures.              |
| `nil?`          | `string` | Custom message template for nil validator failures.              |
| `number?`       | `string` | Custom message template for number validator failures.           |
| `path?`         | `string` | Custom message template for path validator failures.             |
| `socket?`       | `string` | Custom message template for socket validator failures.           |
| `string?`       | `string` | Custom message template for string validator failures.           |
| `symlink?`      | `string` | Custom message template for symbolic link validator failures.    |
| `table?`        | `string` | Custom message template for table validator failures.            |
| `thread?`       | `string` | Custom message template for thread validator failures.           |
| `true?`         | `string` | Custom message template for true validator failures.             |
| `truthy?`       | `string` | Custom message template for truthy validator failures.           |
| `userdata?`     | `string` | Custom message template for userdata validator failures.         |
