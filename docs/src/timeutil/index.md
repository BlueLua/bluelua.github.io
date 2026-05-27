# What is timeutil?

`timeutil` is a C-backed Lua module for wall-clock time, monotonic time, and
blocking sleep.

It lets Lua read Unix wall-clock timestamps, measure elapsed monotonic time, and
pause execution for a duration.

## Compatibility

`timeutil` supports:

- Lua 5.1
- Lua 5.2
- Lua 5.3
- Lua 5.4
- Lua 5.5
- LuaJIT

## Use Cases

- Get Unix wall-clock time from Lua.
- Measure elapsed time without wall-clock jumps.
- Sleep for fractional-second durations.
- Write timing, polling, timeout, and benchmark code.
