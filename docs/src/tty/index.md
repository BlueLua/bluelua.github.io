# tty

[![Test](https://img.shields.io/github/actions/workflow/status/BlueLua/tty/test.yml?branch=main&label=test&style=flat-square)](https://github.com/BlueLua/tty/actions/workflows/test.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/tty?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/tty)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/tty/blob/main/LICENSE)

Lightweight, cross-platform C-backed Lua bindings for terminal detection and
terminal size inspection.

Check out the [documentation] for guides and examples.

## ✨ Features

- **TTY Verification**: Check if a Lua file handle, standard stream, or raw file
  descriptor is interactive.
- **Window Dimension Query**: Retrieve the current terminal width (columns) and
  height(rows) dynamically.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.
- **Cross-Platform**: Works consistently across Windows, macOS, and Linux.

## 📦 Installation

```sh
luarocks install tty
```

## 🚀 Usage

```lua
local tty = require "tty"

-- Check if standard output is a TTY
if tty.isatty(io.stdout) then
  local rows,cols = tty.size()
  print(string.format("Terminal size: %dx%d", cols, rows))
else
print("Output is redirected")
end
```

[documentation]: https://bluelua.github.io/tty
