# timeutil

[![Test](https://img.shields.io/github/actions/workflow/status/BlueLua/timeutil/test.yml?branch=main&label=test&style=flat-square)](https://github.com/BlueLua/timeutil/actions/workflows/test.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/timeutil?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/timeutil)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/timeutil/blob/main/LICENSE)

High-performance C-backed Lua module for precision wall-clock time, monotonic
time, and sleep utilities.

Check out the [documentation] for guides and examples.

## ✨ Features

- **Monotonic Clock**: Measure precise intervals unaffected by system clock
  shifts or NTP syncs.
- **Wall-Clock Time**: Fetch system real-time with sub-microsecond precision.
- **Fractional Sleep**: Sleep for fractional seconds without busy-waiting or
  high CPU utilization.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.
- **Cross-Platform**: Works consistently across Windows, macOS, and Linux.

## 📦 Installation

```sh
luarocks install timeutil
```

## 🚀 Usage

```lua
local timeutil = require "timeutil"

-- Measure precise elapsed time
local start = timeutil.mono()
timeutil.sleep(0.05) -- sleep for 50ms
local elapsed = timeutil.mono() - start

print(string.format("Elapsed:%.6f seconds", elapsed))
print(string.format("Current Unix timestamp: %.6f", timeutil.now()))
```

[documentation]: https://bluelua.github.io/timeutil
