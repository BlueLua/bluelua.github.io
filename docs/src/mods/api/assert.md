---
title: "assert"
description:
  "Validation assertion helpers that throw an error if the validation fails."
---

Validation assertion helpers that throw an error if the validation fails.

```lua
local assert = mods.assert

assert.number(123)    --> 123
assert.number("nope") --> raises error: "number expected, got string"
assert(123, "number") --> runs validation, returns nil
```

## Functions

**Path Checks**:

| Function                                   | Description                                                                                                 |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| [`block_device(v, msg?, optional?, lvl?)`] | Asserts that `v` is a block device path. Returns `v` if successful, otherwise raises an error.              |
| [`char_device(v, msg?, optional?, lvl?)`]  | Asserts that `v` is a character device path. Returns `v` if successful, otherwise raises an error.          |
| [`device(v, msg?, optional?, lvl?)`]       | Asserts that `v` is a block or character device path. Returns `v` if successful, otherwise raises an error. |
| [`dir(v, msg?, optional?, lvl?)`]          | Asserts that `v` is a directory path. Returns `v` if successful, otherwise raises an error.                 |
| [`fifo(v, msg?, optional?, lvl?)`]         | Asserts that `v` is a FIFO path. Returns `v` if successful, otherwise raises an error.                      |
| [`file(v, msg?, optional?, lvl?)`]         | Asserts that `v` is a file path. Returns `v` if successful, otherwise raises an error.                      |
| [`path(v, msg?, optional?, lvl?)`]         | Asserts that `v` is a valid filesystem path. Returns `v` if successful, otherwise raises an error.          |
| [`socket(v, msg?, optional?, lvl?)`]       | Asserts that `v` is a socket path. Returns `v` if successful, otherwise raises an error.                    |
| [`symlink(v, msg?, optional?, lvl?)`]      | Asserts that `v` is a symlink path. Returns `v` if successful, otherwise raises an error.                   |

**Type Checks**:

| Function                               | Description                                                                                            |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [`Function(v, msg?, optional?, lvl?)`] | Asserts that `v` is a function. Returns `v` if successful, otherwise raises an error.                  |
| [`Nil(v, msg?, optional?, lvl?)`]      | Asserts that `v` is `nil`. Returns `nil` if successful, otherwise raises an error.                     |
| [`boolean(v, msg?, optional?, lvl?)`]  | Asserts that `v` is a boolean. Returns `v` if successful, otherwise raises an error.                   |
| [`cdata(v, msg?, optional?, lvl?)`]    | Asserts that `v` is a cdata value (LuaJIT only). Returns `v` if successful, otherwise raises an error. |
| [`number(v, msg?, optional?, lvl?)`]   | Asserts that `v` is a number. Returns `v` if successful, otherwise raises an error.                    |
| [`string(v, msg?, optional?, lvl?)`]   | Asserts that `v` is a string. Returns `v` if successful, otherwise raises an error.                    |
| [`table(v, msg?, optional?, lvl?)`]    | Asserts that `v` is a table. Returns `v` if successful, otherwise raises an error.                     |
| [`thread(v, msg?, optional?, lvl?)`]   | Asserts that `v` is a thread. Returns `v` if successful, otherwise raises an error.                    |
| [`userdata(v, msg?, optional?, lvl?)`] | Asserts that `v` is a userdata value. Returns `v` if successful, otherwise raises an error.            |

**Value Checks**:

| Function                               | Description                                                                                                   |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [`False(v, msg?, optional?, lvl?)`]    | Asserts that `v` is exactly `false`. Returns `false` if successful, otherwise raises an error.                |
| [`True(v, msg?, optional?, lvl?)`]     | Asserts that `v` is exactly `true`. Returns `true` if successful, otherwise raises an error.                  |
| [`callable(v, msg?, optional?, lvl?)`] | Asserts that `v` is callable. Returns `v` if successful, otherwise raises an error.                           |
| [`defined(v, msg?, optional?, lvl?)`]  | Asserts that `v` is defined (not `nil`). Returns `v` if successful, otherwise raises an error.                |
| [`falsy(v, msg?, optional?, lvl?)`]    | Asserts that `v` is falsy (either `false` or `nil`). Returns `v` if successful, otherwise raises an error.    |
| [`finite(v, msg?, optional?, lvl?)`]   | Asserts that `v` is a finite number. Returns `v` if successful, otherwise raises an error.                    |
| [`float(v, msg?, optional?, lvl?)`]    | Asserts that `v` is a float (has a fractional part). Returns `v` if successful, otherwise raises an error.    |
| [`infinite(v, msg?, optional?, lvl?)`] | Asserts that `v` is an infinite number. Returns `v` if successful, otherwise raises an error.                 |
| [`integer(v, msg?, optional?, lvl?)`]  | Asserts that `v` is an integer. Returns `v` if successful, otherwise raises an error.                         |
| [`nan(v, msg?, optional?, lvl?)`]      | Asserts that `v` is a NaN (not-a-number) value. Returns `v` if successful, otherwise raises an error.         |
| [`truthy(v, msg?, optional?, lvl?)`]   | Asserts that `v` is truthy (neither `false` nor `nil`). Returns `v` if successful, otherwise raises an error. |

### Path Checks

#### `block_device(v, msg?, optional?, lvl?)` {#block-device}

Asserts that `v` is a block device path. Returns `v` if successful, otherwise
raises an error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

#### `char_device(v, msg?, optional?, lvl?)` {#char-device}

Asserts that `v` is a character device path. Returns `v` if successful,
otherwise raises an error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

#### `device(v, msg?, optional?, lvl?)` {#device}

Asserts that `v` is a block or character device path. Returns `v` if successful,
otherwise raises an error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

#### `dir(v, msg?, optional?, lvl?)` {#dir}

Asserts that `v` is a directory path. Returns `v` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

**Example**:

```lua
assert.dir("src") --> "src"
```

---

#### `fifo(v, msg?, optional?, lvl?)` {#fifo}

Asserts that `v` is a FIFO path. Returns `v` if successful, otherwise raises an
error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

#### `file(v, msg?, optional?, lvl?)` {#file}

Asserts that `v` is a file path. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

**Example**:

```lua
assert.file("README.md") --> "README.md"
```

---

#### `path(v, msg?, optional?, lvl?)` {#path}

Asserts that `v` is a valid filesystem path. Returns `v` if successful,
otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

**Example**:

```lua
assert.path("README.md") --> "README.md"
```

---

#### `socket(v, msg?, optional?, lvl?)` {#socket}

Asserts that `v` is a socket path. Returns `v` if successful, otherwise raises
an error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

#### `symlink(v, msg?, optional?, lvl?)` {#symlink}

Asserts that `v` is a symlink path. Returns `v` if successful, otherwise raises
an error. **Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `path` (`T`): The passed path string.

---

### Type Checks

#### `Function(v, msg?, optional?, lvl?)` {#function}

Asserts that `v` is a function. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
local fn = function() end
assert.Function(fn) --> fn
assert.Function(1)  --> raises error: "function expected, got number"
```

---

#### `Nil(v, msg?, optional?, lvl?)` {#nil}

Asserts that `v` is `nil`. Returns `nil` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.Nil(nil) --> nil
assert.Nil(0)   --> raises error: "nil expected, got number"
```

---

#### `boolean(v, msg?, optional?, lvl?)` {#boolean}

Asserts that `v` is a boolean. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.boolean(true) --> true
assert.boolean(1)    --> raises error: "boolean expected, got number"
```

---

#### `cdata(v, msg?, optional?, lvl?)` {#cdata}

Asserts that `v` is a cdata value (LuaJIT only). Returns `v` if successful,
otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.cdata(val) --> val
```

---

#### `number(v, msg?, optional?, lvl?)` {#number}

Asserts that `v` is a number. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.number(42)  --> 42
assert.number("x") --> raises error: "number expected, got string"
```

---

#### `string(v, msg?, optional?, lvl?)` {#string}

Asserts that `v` is a string. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.string("hello") --> "hello"
assert.string(1)       --> raises error: "string expected, got number"
```

---

#### `table(v, msg?, optional?, lvl?)` {#table}

Asserts that `v` is a table. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
local t = {}
assert.table(t) --> t
assert.table(1) --> raises error: "table expected, got number"
```

---

#### `thread(v, msg?, optional?, lvl?)` {#thread}

Asserts that `v` is a thread. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
local co = coroutine.create(function() end)
assert.thread(co) --> co
assert.thread(1)  --> raises error: "thread expected, got number"
```

---

#### `userdata(v, msg?, optional?, lvl?)` {#userdata}

Asserts that `v` is a userdata value. Returns `v` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.userdata(io.stdout) --> io.stdout
assert.userdata(1)         --> raises error: "userdata expected, got number"
```

---

### Value Checks

#### `False(v, msg?, optional?, lvl?)` {#false}

Asserts that `v` is exactly `false`. Returns `false` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.False(false) --> false
assert.False(true)  --> raises error: "false value expected, got true"
```

---

#### `True(v, msg?, optional?, lvl?)` {#true}

Asserts that `v` is exactly `true`. Returns `true` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.True(true)  --> true
assert.True(false) --> raises error: "true value expected, got false"
```

---

#### `callable(v, msg?, optional?, lvl?)` {#callable}

Asserts that `v` is callable. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.callable(print) --> print
assert.callable(1)     --> raises error: "callable value expected, got 1"
```

---

#### `defined(v, msg?, optional?, lvl?)` {#defined}

Asserts that `v` is defined (not `nil`). Returns `v` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.defined(1)   --> 1
assert.defined(nil) --> raises error: "defined value expected, got no value"
```

---

#### `falsy(v, msg?, optional?, lvl?)` {#falsy}

Asserts that `v` is falsy (either `false` or `nil`). Returns `v` if successful,
otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.falsy(false) --> false
assert.falsy(1)     --> raises error: "falsy value expected, got 1"
```

---

#### `finite(v, msg?, optional?, lvl?)` {#finite}

Asserts that `v` is a finite number. Returns `v` if successful, otherwise raises
an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.finite(123)       --> 123
assert.finite(math.huge) --> raises error: "finite value expected, got inf"
```

---

#### `float(v, msg?, optional?, lvl?)` {#float}

Asserts that `v` is a float (has a fractional part). Returns `v` if successful,
otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.float(1.5) --> 1.5
assert.float(1)   --> raises error: "float value expected, got 1"
```

---

#### `infinite(v, msg?, optional?, lvl?)` {#infinite}

Asserts that `v` is an infinite number. Returns `v` if successful, otherwise
raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.infinite(math.huge) --> inf
assert.infinite(123)       --> raises error: "infinite value expected, got 123"
```

---

#### `integer(v, msg?, optional?, lvl?)` {#integer}

Asserts that `v` is an integer. Returns `v` if successful, otherwise raises an
error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.integer(1)   --> 1
assert.integer(1.5) --> raises error: "integer value expected, got 1.5"
```

---

#### `nan(v, msg?, optional?, lvl?)` {#nan}

Asserts that `v` is a NaN (not-a-number) value. Returns `v` if successful,
otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.nan(0/0) --> NaN
assert.nan(1)   --> raises error: "nan value expected, got 1"
```

---

#### `truthy(v, msg?, optional?, lvl?)` {#truthy}

Asserts that `v` is truthy (neither `false` nor `nil`). Returns `v` if
successful, otherwise raises an error.

**Parameters**:

- `v` (`T`): Value to validate.
- `msg?` (`string`): Optional override template.
- `optional?` (`boolean`): Skip validation when `v` is `nil`.
- `lvl?` (`integer`): Optional error level for `error()` (defaults to 2).

**Returns**:

- `v` (`T`): The passed value.

**Example**:

```lua
assert.truthy(1)     --> 1
assert.truthy(false) --> raises error: "truthy value expected, got false"
```

<!-- prettier-ignore-start -->
[`False(v, msg?, optional?, lvl?)`]: #false
[`Function(v, msg?, optional?, lvl?)`]: #function
[`Nil(v, msg?, optional?, lvl?)`]: #nil
[`True(v, msg?, optional?, lvl?)`]: #true
[`block_device(v, msg?, optional?, lvl?)`]: #block-device
[`boolean(v, msg?, optional?, lvl?)`]: #boolean
[`callable(v, msg?, optional?, lvl?)`]: #callable
[`cdata(v, msg?, optional?, lvl?)`]: #cdata
[`char_device(v, msg?, optional?, lvl?)`]: #char-device
[`defined(v, msg?, optional?, lvl?)`]: #defined
[`device(v, msg?, optional?, lvl?)`]: #device
[`dir(v, msg?, optional?, lvl?)`]: #dir
[`falsy(v, msg?, optional?, lvl?)`]: #falsy
[`fifo(v, msg?, optional?, lvl?)`]: #fifo
[`file(v, msg?, optional?, lvl?)`]: #file
[`finite(v, msg?, optional?, lvl?)`]: #finite
[`float(v, msg?, optional?, lvl?)`]: #float
[`infinite(v, msg?, optional?, lvl?)`]: #infinite
[`integer(v, msg?, optional?, lvl?)`]: #integer
[`nan(v, msg?, optional?, lvl?)`]: #nan
[`number(v, msg?, optional?, lvl?)`]: #number
[`path(v, msg?, optional?, lvl?)`]: #path
[`socket(v, msg?, optional?, lvl?)`]: #socket
[`string(v, msg?, optional?, lvl?)`]: #string
[`symlink(v, msg?, optional?, lvl?)`]: #symlink
[`table(v, msg?, optional?, lvl?)`]: #table
[`thread(v, msg?, optional?, lvl?)`]: #thread
[`truthy(v, msg?, optional?, lvl?)`]: #truthy
[`userdata(v, msg?, optional?, lvl?)`]: #userdata
<!-- prettier-ignore-end -->
