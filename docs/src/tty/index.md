# tty

<p style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1.5rem;">
  <a href="https://luarocks.org/modules/BlueLua/tty">
    <img src="https://img.shields.io/luarocks/v/BlueLua/tty?color=blue&style=flat-square" alt="LuaRocks">
  </a>
  <a href="https://github.com/BlueLua/tty/actions/workflows/test.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/BlueLua/tty/test.yml?style=flat-square" alt="Test Status">
  </a>
  <img src="https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square" alt="Lua Versions">
  <img src="https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square" alt="Platform">
  <a href="https://github.com/BlueLua/tty/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  </a>
</p>

`tty` provides lightweight, cross-platform C-backed Lua bindings for terminal
detection and terminal size inspection.

## ✨ Features

- **TTY Verification**: Check if a Lua file handle (like `io.stdout`,
  `io.stdin`), standard stream, or raw [file descriptor] is interactive.
- **Window Dimension Query**: Retrieve the current width (columns) and height
  (rows) of the active terminal dynamically.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.

## 📦 Installation

::: code-group

```sh [LuaRocks]
luarocks install tty
```

:::

## 🚀 Usage

::: code-group

```lua [example.lua]
local tty = require "tty"

-- Check if standard output is a TTY
if tty.isatty(io.stdout) then
  local rows, cols = tty.size()
  print(string.format("Terminal size: %dx%d", cols, rows))
else
  print("Output is redirected")
end
```

:::

[file descriptor]: https://en.wikipedia.org/wiki/File_descriptor
