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

## [`mods.DurationHumanizeOptions`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L6-L12)

| Key            | Type                                                                                                 | Description                                             |
| -------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `max_unit?`    | <code><a href="/mods/types#mods-dateunit">mods.DateUnit</a></code>                                   | Largest unit allowed when choosing the displayed unit.  |
| `min_unit?`    | <code><a href="/mods/types#mods-dateunit">mods.DateUnit</a></code>                                   | Smallest unit allowed when choosing the displayed unit. |
| `round?`       | <code><a href="/mods/types#mods-durationhumanizeroundmode">mods.DurationHumanizeRoundMode</a></code> | Rounding mode for custom unit output.                   |
| `short?`       | `boolean`                                                                                            | Whether to use abbreviated unit labels like `2h`.       |
| `with_suffix?` | `boolean`                                                                                            | Whether to include `ago` / `in` style wording.          |

## [`mods.DurationHumanizeRoundMode`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L3-L5)

&nbsp;`"ceil"` &nbsp;`"floor"` &nbsp;`"round"` &nbsp;`boolean`

## [`mods.DurationParts`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L3-L5)

| Key             | Type     |
| --------------- | -------- |
| `days?`         | `number` |
| `hours?`        | `number` |
| `milliseconds?` | `number` |
| `minutes?`      | `number` |
| `months?`       | `number` |
| `quarters?`     | `number` |
| `seconds?`      | `number` |
| `weeks?`        | `number` |
| `years?`        | `number` |

## [`mods.FsEntryType`](https://github.com/BlueLua/mods/blob/main/types/fs.d.lua#L3-L12)

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

## [`mods.globOptions`](https://github.com/BlueLua/mods/blob/main/types/glob.d.lua#L3-L9)

Options for glob matching and directory traversal.

| Key           | Type      | Description                                   |
| ------------- | --------- | --------------------------------------------- |
| `follow?`     | `boolean` | Whether to follow symbolic links.             |
| `hidden?`     | `boolean` | Whether to include hidden files/directories.  |
| `ignorecase?` | `boolean` | Whether to perform case-insensitive matching. |
| `recursive?`  | `boolean` | Whether to traverse directories recursively.  |

## [`mods.log.levelno`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L13-L20)

| Name    | Value         |
| ------- | ------------- |
| `debug` | `10`          |
| `error` | `40`          |
| `info`  | `20`          |
| `off`   | `"math.huge"` |
| `warn`  | `30`          |

## [`mods.log.logger`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L61-L63)

| Key       | Type                                                                                         | Description                                                 |
| --------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `debug`   | `fun(...: any)`                                                                              | Emit a `debug` record.                                      |
| `error`   | `fun(...: any)`                                                                              | Emit an `error` record.                                     |
| `info`    | `fun(...: any)`                                                                              | Emit an `info` record.                                      |
| `log`     | <code>fun(levelname: <a href="/mods/types#mods-loglevel">mods.LogLevel</a>, ...: any)</code> | Emit a record for `level` when it passes the logger filter. |
| `private` | `_levelno`                                                                                   | mods.log.levelno                                            |
| `warn`    | `fun(...: any)`                                                                              | Emit a `warn` record.                                       |

## [`mods.log.new.opts`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L30-L34)

| Key        | Type                                                                   | Description                                                                  |
| ---------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `handler?` | <code><a href="/mods/types#mods-loghandler">mods.LogHandler</a></code> | Optional handler function that receives each emitted record.                 |
| `level?`   | <code><a href="/mods/types#mods-loglevel">mods.LogLevel</a></code>     | Minimum enabled level; use `"off"` to disable logging. Defaults to `"warn"`. |
| `name?`    | `string`                                                               | Optional logger name included in emitted records.                            |

## [`mods.log.record`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L22-L29)

| Key         | Type                                                               | Description                          |
| ----------- | ------------------------------------------------------------------ | ------------------------------------ |
| `args`      | `{[integer]:any, n:integer}`                                       | Original variadic arguments.         |
| `levelname` | <code><a href="/mods/types#mods-loglevel">mods.LogLevel</a></code> | Log level name.                      |
| `levelno`   | `integer`                                                          | Numeric severity used for filtering. |
| `line`      | `string`                                                           | Formatted plain-text log line.       |
| `message`   | `string`                                                           | Joined message string.               |

## [`mods.LogHandler`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L11-L12)

`fun(record: mods.log.record)`

## [`mods.LogLevel`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L3-L10)

| Value     | Description                |
| --------- | -------------------------- |
| `"debug"` | Debug messages.            |
| `"error"` | Error messages.            |
| `"info"`  | Informational messages.    |
| `"off"`   | Logging disabled.          |
| `"warn"`  | Warning messages.          |
| `string`  | Any custom log level name. |

## [`mods.ValidatorName`](https://github.com/BlueLua/mods/blob/main/types/is.d.lua#L6-L24)

| Value        | Description                                               |
| ------------ | --------------------------------------------------------- |
| `"block"`    | A block device path.                                      |
| `"callable"` | A function or table with a `__call` metamethod.           |
| `"char"`     | A character device path.                                  |
| `"device"`   | A character or block device path.                         |
| `"dir"`      | A directory path.                                         |
| `"false"`    | The boolean value false.                                  |
| `"falsy"`    | A falsy value (nil or false).                             |
| `"fifo"`     | A named pipe (FIFO) path.                                 |
| `"file"`     | A regular file path.                                      |
| `"integer"`  | An integer number.                                        |
| `"link"`     | A symbolic link path.                                     |
| `"path"`     | Any existing path or symbolic link.                       |
| `"socket"`   | A socket path.                                            |
| `"true"`     | The boolean value true.                                   |
| `"truthy"`   | A truthy value (not nil and not false).                   |
| `string`     | Any validator name.                                       |
| `type`       | Any standard Lua type name (e.g., `"table"`, `"number"`). |

## [`modsValidatorMessages`](https://github.com/BlueLua/mods/blob/main/types/validate.d.lua#L3-L31)

| Key         | Type     |
| ----------- | -------- |
| `[string]`  | `string` |
| `block?`    | `string` |
| `boolean?`  | `string` |
| `callable?` | `string` |
| `char?`     | `string` |
| `device?`   | `string` |
| `dir?`      | `string` |
| `false?`    | `string` |
| `falsy?`    | `string` |
| `fifo?`     | `string` |
| `file?`     | `string` |
| `function?` | `string` |
| `integer?`  | `string` |
| `link?`     | `string` |
| `nil?`      | `string` |
| `number?`   | `string` |
| `path?`     | `string` |
| `socket?`   | `string` |
| `string?`   | `string` |
| `table?`    | `string` |
| `thread?`   | `string` |
| `true?`     | `string` |
| `truthy?`   | `string` |
| `userdata?` | `string` |
