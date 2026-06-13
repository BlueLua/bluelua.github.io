# timeutil

[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/timeutil?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/timeutil)
[![CI Status](https://img.shields.io/github/actions/workflow/status/BlueLua/timeutil/ci.yml?label=CI&style=flat-square)](https://github.com/BlueLua/timeutil/actions/workflows/ci.yml)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/timeutil/blob/main/LICENSE)

`timeutil` is a high-performance C-backed Lua module providing precision
wall-clock time, monotonic time, and sleep utilities.

## ✨ Features

- **Monotonic Clock**: Measure precise intervals unaffected by [NTP] syncs or
  system clock shifts.
- **Wall-Clock Time**: Fetch system real-time with sub-microsecond precision.
- **Fractional Sleep**: Put the execution thread to sleep for fractional seconds
  without high CPU utilization.a
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.

## 📦 Installation

```sh
luarocks install timeutil
```

## 🚀 Usage

```lua
local time = require "timeutil"

-- Measure precise elapsed time
local start = time.mono()
time.sleep(0.05) -- sleep for 50ms
local elapsed = time.mono() - start

print(string.format("Elapsed: %.6f seconds", elapsed))
print(string.format("Current Unix timestamp: %.6f", time.now()))
```

[NTP]: https://en.wikipedia.org/wiki/Network_Time_Protocol
