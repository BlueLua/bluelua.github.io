# mods

<p style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1.5rem;">
  <a href="https://luarocks.org/modules/BlueLua/mods">
    <img src="https://img.shields.io/luarocks/v/BlueLua/mods?color=blue&style=flat-square" alt="LuaRocks">
  </a>
  <a href="https://github.com/BlueLua/mods/actions/workflows/test.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/BlueLua/mods/test.yml?style=flat-square" alt="Test Status">
  </a>
  <img src="https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square" alt="Lua Versions">
  <img src="https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square" alt="Platform">
  <a href="https://github.com/BlueLua/mods/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  </a>
</p>

`mods` is a comprehensive Lua utility library featuring predictable APIs, lazy-loaded inter-module dependencies, and wide Lua runtime compatibility.

## ✨ Features

- **Predictable APIs**: Standard utility functions for strings, tables, filesystem paths, lists, sets, and template rendering.
- **Lazy Loading**: Automatic lazy loading of sub-modules to keep startup times fast.
- **Cross-Platform**: Works consistently across Windows, macOS, and Linux.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and 5.5.

## 📦 Installation

::: code-group

```sh [LuaRocks]
luarocks install mods
```

:::

## 🚀 Usage

::: code-group

```lua [example.lua]
local mods = require "mods"

-- Use the lazy-loaded stringcase sub-module
local title = mods.stringcase.titlecase("hello world")
print(title) -- Output: Hello World

-- Use the lazy-loaded List class
local items = mods.List { 1, 2, 3 }
local doubled = items:map(function(x) return x * 2 end)
print(doubled:join(", ")) -- Output: 2, 4, 6
```

:::
