---
title: "tty"
description:
  "Terminal helpers for checking TTY state and reading terminal dimensions."
---

Terminal helpers for checking TTY state and reading terminal dimensions.

## Functions

<a id="fn-isatty"></a>

### `isatty(fd?)`

Check whether a file descriptor or Lua file handle is attached to a terminal.

**Parameters**:

- `fd?` (`integer|file*`): A file descriptor number or a Lua file handle.

**Return**:

- `isatty` (`boolean`)

**Example**:

```lua
local tty = require "tty"

print(tty.isatty())
print(tty.isatty(2))
print(tty.isatty(io.stdout))
```

<a id="fn-size"></a>

### `size(fd?)`

Get the terminal size for stdout, or for a specific file descriptor or Lua file
handle.

**Parameters**:

- `fd?` (`integer|file*`): A file descriptor number or a Lua file handle.

**Return**:

- `rows` (`integer`): Number of terminal rows.
- `cols` (`integer`): Number of terminal columns.

**Example**:

```lua
local tty = require "tty"

local rows, cols = tty.size()
print(("terminal: %dx%d"):format(cols, rows))
```

## Fields

<a id="version"></a>

### `_VERSION` (`string`)

Value: `"version"`
