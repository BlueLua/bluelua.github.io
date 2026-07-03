---
title: "is"
description: "Type predicates for Lua values and filesystem path types."
---

Type predicates for Lua values and filesystem path types.

## Usage

```lua
is = mods.is

ok = is.number(3.14)       --> true
ok = is("hello", "string") --> true
ok = is.table({})          --> true
```

> [!NOTE]
>
> Function names are case-insensitive.
>
> ```lua
> is.table({})  --> true
> is.Table({})  --> true
> is.tAbLe({})  --> true
> ```

<!-- markdownlint-disable MD028 -->

> [!IMPORTANT]
>
> Path checks require **LuaFileSystem** ([`lfs`]) and raise an error if it is
> not installed.

<!-- markdownlint-enable MD028 -->

## `is()`

`is` is also callable as `is(value, type)` to check if a value is of a given
type.

```lua
is("hello", "string") --> true
is("hello", "String") --> true
is("hello", "STRING") --> true
```

## Functions

**Path Checks**:

| Function            | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| [`block_device(v)`] | Returns `true` when `v` is a block device path.              |
| [`char_device(v)`]  | Returns `true` when `v` is a character device path.          |
| [`device(v)`]       | Returns `true` when `v` is a block or character device path. |
| [`dir(v)`]          | Returns `true` when `v` is a directory path.                 |
| [`fifo(v)`]         | Returns `true` when `v` is a FIFO path.                      |
| [`file(v)`]         | Returns `true` when `v` is a file path.                      |
| [`path(v)`]         | Returns `true` when `v` is a valid filesystem path.          |
| [`socket(v)`]       | Returns `true` when `v` is a socket path.                    |
| [`symlink(v)`]      | Returns `true` when `v` is a symlink path.                   |

**Type Checks**:

| Function        | Description                                             |
| --------------- | ------------------------------------------------------- |
| [`Function(v)`] | Returns `true` when `v` is a function.                  |
| [`Nil(v)`]      | Returns `true` when `v` is `nil`.                       |
| [`boolean(v)`]  | Returns `true` when `v` is a boolean.                   |
| [`cdata(v)`]    | Returns `true` when `v` is a cdata value (LuaJIT only). |
| [`number(v)`]   | Returns `true` when `v` is a number.                    |
| [`string(v)`]   | Returns `true` when `v` is a string.                    |
| [`table(v)`]    | Returns `true` when `v` is a table.                     |
| [`thread(v)`]   | Returns `true` when `v` is a thread.                    |
| [`userdata(v)`] | Returns `true` when `v` is userdata.                    |

**Value Checks**:

| Function        | Description                                            |
| --------------- | ------------------------------------------------------ |
| [`False(v)`]    | Returns `true` when `v` is exactly `false`.            |
| [`True(v)`]     | Returns `true` when `v` is exactly `true`.             |
| [`callable(v)`] | Returns `true` when `v` is callable.                   |
| [`defined(v)`]  | Returns `true` when `v` is defined (not `nil`).        |
| [`falsy(v)`]    | Returns `true` when `v` is falsy.                      |
| [`finite(v)`]   | Returns `true` when `v` is a finite number.            |
| [`float(v)`]    | Returns `true` when `v` is a float number.             |
| [`infinite(v)`] | Returns `true` when `v` is an infinite number.         |
| [`integer(v)`]  | Returns `true` when `v` is an integer.                 |
| [`nan(v)`]      | Returns `true` when `v` is a NaN (not-a-number) value. |
| [`truthy(v)`]   | Returns `true` when `v` is truthy.                     |

### Path Checks

#### `block_device(v)` {#block-device}

Returns `true` when `v` is a block device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isBlockDevice` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.block_device("/dev/sda")
```

---

#### `char_device(v)` {#char-device}

Returns `true` when `v` is a character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isCharDevice` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.char_device("/dev/null")
```

---

#### `device(v)` {#device}

Returns `true` when `v` is a block or character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isDevice` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.device("/dev/null")
```

---

#### `dir(v)` {#dir}

Returns `true` when `v` is a directory path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isDir` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.dir("/tmp")
```

---

#### `fifo(v)` {#fifo}

Returns `true` when `v` is a FIFO path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFifo` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.fifo("/path/to/fifo")
```

---

#### `file(v)` {#file}

Returns `true` when `v` is a file path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFile` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.file("README.md")
```

---

#### `path(v)` {#path}

Returns `true` when `v` is a valid filesystem path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isPath` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.path("README.md")
```

> [!NOTE]
>
> Returns `true` for broken symlinks.

---

#### `socket(v)` {#socket}

Returns `true` when `v` is a socket path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isSocket` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.socket("/path/to/socket")
```

---

#### `symlink(v)` {#symlink}

Returns `true` when `v` is a symlink path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isSymlink` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.symlink("/path/to/link")
```

---

### Type Checks

#### `Function(v)` {#function}

Returns `true` when `v` is a function.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFunction` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Function(function() end)
```

---

#### `Nil(v)` {#nil}

Returns `true` when `v` is `nil`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isNil` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Nil(nil)
```

---

#### `boolean(v)` {#boolean}

Returns `true` when `v` is a boolean.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isBoolean` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.boolean(true)
```

---

#### `cdata(v)` {#cdata}

Returns `true` when `v` is a cdata value (LuaJIT only).

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isCdata` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.cdata(v)
```

---

#### `number(v)` {#number}

Returns `true` when `v` is a number.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isNumber` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.number(3.14)
```

---

#### `string(v)` {#string}

Returns `true` when `v` is a string.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isString` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.string("hello")
```

---

#### `table(v)` {#table}

Returns `true` when `v` is a table.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.table({})
```

---

#### `thread(v)` {#thread}

Returns `true` when `v` is a thread.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isThread` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.thread(coroutine.create(function() end))
```

---

#### `userdata(v)` {#userdata}

Returns `true` when `v` is userdata.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isUserdata` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.userdata(io.stdout)
```

---

### Value Checks

#### `False(v)` {#false}

Returns `true` when `v` is exactly `false`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFalse` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.False(false)
```

---

#### `True(v)` {#true}

Returns `true` when `v` is exactly `true`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTrue` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.True(true)
```

---

#### `callable(v)` {#callable}

Returns `true` when `v` is callable.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isCallable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.callable(function() end)
```

---

#### `defined(v)` {#defined}

Returns `true` when `v` is defined (not `nil`).

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isDefined` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.defined(1)     --> true
is.defined(false) --> true
is.defined(nil)   --> false
```

---

#### `falsy(v)` {#falsy}

Returns `true` when `v` is falsy.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFalsy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.falsy(false)
```

---

#### `finite(v)` {#finite}

Returns `true` when `v` is a finite number.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFinite` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.finite(42) --> true
```

---

#### `float(v)` {#float}

Returns `true` when `v` is a float number.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFloat` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.float(1.5) --> true
is.float(1.0) --> true (on Lua >= 5.3) or false (on Lua <= 5.2)
```

---

#### `infinite(v)` {#infinite}

Returns `true` when `v` is an infinite number.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isInfinite` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.infinite(math.huge)  --> true
```

---

#### `integer(v)` {#integer}

Returns `true` when `v` is an integer.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isInteger` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.integer(42)
```

---

#### `nan(v)` {#nan}

Returns `true` when `v` is a NaN (not-a-number) value.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isNan` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.nan(0/0)
```

---

#### `truthy(v)` {#truthy}

Returns `true` when `v` is truthy.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTruthy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.truthy("non-empty")
```

<!-- prettier-ignore-start -->
[`False(v)`]: #false
[`Function(v)`]: #function
[`Nil(v)`]: #nil
[`True(v)`]: #true
[`block_device(v)`]: #block-device
[`boolean(v)`]: #boolean
[`callable(v)`]: #callable
[`cdata(v)`]: #cdata
[`char_device(v)`]: #char-device
[`defined(v)`]: #defined
[`device(v)`]: #device
[`dir(v)`]: #dir
[`falsy(v)`]: #falsy
[`fifo(v)`]: #fifo
[`file(v)`]: #file
[`finite(v)`]: #finite
[`float(v)`]: #float
[`infinite(v)`]: #infinite
[`integer(v)`]: #integer
[`lfs`]: https://github.com/lunarmodules/luafilesystem
[`nan(v)`]: #nan
[`number(v)`]: #number
[`path(v)`]: #path
[`socket(v)`]: #socket
[`string(v)`]: #string
[`symlink(v)`]: #symlink
[`table(v)`]: #table
[`thread(v)`]: #thread
[`truthy(v)`]: #truthy
[`userdata(v)`]: #userdata
<!-- prettier-ignore-end -->
