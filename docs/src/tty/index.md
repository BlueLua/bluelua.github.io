# What is tty?

`tty` provides small cross-platform Lua bindings for terminal inspection.

Compatible with Lua 5.1, 5.2, 5.3, 5.4, 5.5, and LuaJIT.

Use `tty` to detect whether streams, file handles, or file descriptors are
attached to a terminal, and to read terminal rows and columns for CLI output.

## Install

::: code-group

```sh [LuaRocks]
luarocks install tty
```

:::

## Quick Start

::: code-group

```lua [exmaple.lua]
local tty = require "tty"

if tty.isatty(io.stdout) then
  local rows, cols = tty.size()
  print(("terminal: %dx%d"):format(cols, rows))
else
  print("stdout is redirected")
end
```

:::
