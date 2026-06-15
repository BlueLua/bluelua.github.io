# Documentation Generator Scripts

> [!NOTE] These scripts were generated and are maintained by an AI coding
> assistant.

These Lua scripts parse Lua Language Server (LuaLS) type annotations/definitions
and generate Markdown documentation suitable for [VitePress].

## Script Overview

- **[`generate-docs.lua`]**: The main driver script. It scans a source directory
  for type definition files (`.lua` or `.d.lua`), parses their type annotations,
  renders individual Markdown API files, and compiles a consolidated `types.md`
  file containing type aliases and especs.
- **[`luals-type-parser.lua`]**: Parses LuaLS type annotations, extracting
  classes, functions, aliases, parameters, return types, and descriptions.

## Running Locally

You can run the generator locally using `luajit` (or standard `lua`).

### Usage

```sh
lua scripts/generate-docs.lua <source_types_dir> <output_markdown_dir>
```

- **`<source_types_dir>`**: Path to the directory containing LuaLS type files
  (e.g. `types/` or `lua/`).
- **`<output_markdown_dir>`**: Path to the directory where you want the
  generated Markdown files to be saved (e.g. `docs/api` or `docs/src/mods/api`).

[VitePress]: https://vitepress.dev/
[`generate-docs.lua`]: ./generate-docs.lua
[`luals-type-parser.lua`]: ./luals-type-parser.lua
