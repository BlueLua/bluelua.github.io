---
title: "tty"
description:
  "Terminal helpers for checking TTY state and reading terminal dimensions."
---

Terminal helpers for checking TTY state and reading terminal dimensions.

## Fields

### `_VERSION` (`string`) {#version}

Value: `"version"`

## Functions

### `isatty(fd?)` {#isatty}

Check whether a file descriptor or Lua file handle is attached to a terminal.

**Parameters**:

- `fd?` ([`tty.fd`]): A file descriptor number or a Lua file handle.

**Returns**:

- `isatty` (`boolean`)

**Example**:

```lua
local tty = require "tty"

print(tty.isatty())
print(tty.isatty(2))
print(tty.isatty(io.stdout))
```

---

### `size(fd?)` {#size}

Get the terminal size for stdout, or for a specific file descriptor or Lua file
handle.

**Parameters**:

- `fd?` ([`tty.fd`]): A file descriptor number or a Lua file handle.

**Returns**:

- `rows` (`integer`): Number of terminal rows.
- `cols` (`integer`): Number of terminal columns.

**Example**:

```lua
local tty = require "tty"

local rows, cols = tty.size()
print(("terminal: %dx%d"):format(cols, rows))
```

<!-- prettier-ignore-start -->
[`tty.fd`]: /tty/types#tty-fd
<!-- prettier-ignore-end -->
