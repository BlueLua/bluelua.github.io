# What is timeutil?

`timeutil` is a C-backed Lua module for wall-clock time, monotonic time, and
blocking sleep.

Compatible with Lua 5.1, 5.2, 5.3, 5.4, 5.5, and LuaJIT.

Use `timeutil` to read Unix wall-clock timestamps, measure elapsed monotonic
time without wall-clock jumps, and sleep for fractional-second durations.

## Install

::: code-group

```sh [LuaRocks]
luarocks install timeutil
```

:::

## Quick Start

::: code-group

```lua [exmaple.lua]
local time = require "timeutil"

local start = time.mono()
time.sleep(0.05)
local elapsed = time.mono() - start

print(("elapsed: %.3fs"):format(elapsed))
print(("now: %.3f"):format(time.now()))
```

:::
