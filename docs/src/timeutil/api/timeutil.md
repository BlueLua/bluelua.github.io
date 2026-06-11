---
description: "Wall-clock time, monotonic time, and native sleep utilities."
---

# `timeutil`

Wall-clock time, monotonic time, and native sleep utilities.

```lua
local timeutil = require("timeutil")
local start = timeutil.mono()
timeutil.sleep(0.1)
print(timeutil.now() - start)
```

## Functions

<a id="fn-mono"></a>

### `mono()`

Returns monotonic elapsed time in seconds.

**Return**:

- `seconds` (`number`)

**Example**:

```lua
local time = require("timeutil")
local monotime = time.mono

local start = monotime()
time.sleep(0.5)
local stop = monotime()

local elapsed_ms = math.floor((stop - start) * 1000)
print(elapsed_ms.."ms") --> 500ms
```

<a id="fn-now"></a>

### `now()`

Returns wall-clock Unix time in seconds.

**Return**:

- `seconds` (`number`)

**Example**:

```lua
local time = require("timeutil")
local now = time.now()
local seconds = math.floor(now)
local ms = math.floor((now - seconds) * 1000)
local dt = string.format("%s.%03d", os.date("%Y-%m-%d %H:%M:%S", seconds), ms)
print(dt) --> YYYY-MM-DD HH:mm:ss.SSS
```

<a id="fn-sleep"></a>

### `sleep(seconds)`

Blocks the current thread for the requested non-negative duration.

**Parameters**:

- `seconds` (`number`)

**Example**:

```lua
local time = require("timeutil")
time.sleep(1.5) -- sleep for 1.5 seconds
```

## Fields

<a id="version"></a>

### `_VERSION` (`string`)

Value: `"version"`
