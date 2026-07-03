---
title: "runtime"
description: "Lua runtime metadata and version compatibility flags."
---

Lua runtime metadata and version compatibility flags.

## Usage

```lua
runtime = mods.runtime

print(runtime.version)  --> 501 | 502 | 503 | 504 | 505
```

## Fields

| Field          | Description                                           |
| -------------- | ----------------------------------------------------- |
| [`is_luajit`]  | True when running under LuaJIT.                       |
| [`is_unix`]    | True when running on a Unix-like host (Linux, macOS). |
| [`is_windows`] | True when running on a Windows host.                  |
| [`major`]      | Major version number parsed from `version`.           |
| [`minor`]      | Minor version number parsed from `version`.           |
| [`version`]    | Numeric version encoded as `major * 100 + minor`.     |

### `is_luajit` (`boolean`) {#is-luajit}

True when running under LuaJIT.

```lua
print(runtime.is_luajit) --> true | false
```

---

### `is_unix` (`boolean`) {#is-unix}

True when running on a Unix-like host (Linux, macOS).

```lua
print(runtime.is_unix) --> true | false
```

---

### `is_windows` (`boolean`) {#is-windows}

True when running on a Windows host.

```lua
print(runtime.is_windows) --> true | false
```

---

### `major` (`5`) {#major}

Major version number parsed from `version`.

```lua
print(runtime.major) --> 5
```

---

### `minor` (`1` | `2` | `3` | `4` | `5`) {#minor}

Minor version number parsed from `version`.

```lua
print(runtime.minor) --> 1 | 2 | 3 | 4 | 5
```

---

### `version` (`501` | `502` | `503` | `504` | `505`) {#version}

Numeric version encoded as `major * 100 + minor`.

```lua
print(runtime.version) --> 501 | 502 | 503 | 504 | 505
```

<!-- prettier-ignore-start -->
[`is_luajit`]: #is-luajit
[`is_unix`]: #is-unix
[`is_windows`]: #is-windows
[`major`]: #major
[`minor`]: #minor
[`version`]: #version
<!-- prettier-ignore-end -->
