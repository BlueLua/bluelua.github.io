# Documentation Generator Scripts

> [!NOTE] These scripts were generated and are maintained by an AI coding
> assistant.

These Lua scripts parse Lua Language Server (LuaLS) type annotations/definitions
and generate Markdown documentation suitable for [VitePress].

## Script Overview

- **[`generate-api-docs.lua`]**: The main driver script. It scans a source
  directory for type definition files (`.lua` or `.d.lua`), invokes the parser
  and renderer, and writes output `.md` files.
- **[`luals-type-parser.lua`]**: Parses LuaLS type annotations, extracting
  classes, functions, aliases, parameters, return types, and descriptions.
- **[`render-api-docs.lua`]**: Renders the parsed Lua structure into formatted
  Markdown API documentation.

## Running Locally

You can run the generator locally using `luajit` (or standard `lua`).

### Usage

```sh
lua scripts/generate-api-docs.lua <source_types_dir> <output_markdown_dir>
```

- **`<source_types_dir>`**: Path to the directory containing LuaLS type files
  (e.g. `types/` or `lua/`).
- **`<output_markdown_dir>`**: Path to the directory where you want the
  generated Markdown files to be saved.

[VitePress]: https://vitepress.dev/
[`generate-api-docs.lua`]: ./generate-api-docs.lua
[`luals-type-parser.lua`]: ./luals-type-parser.lua
[`render-api-docs.lua`]: ./render-api-docs.lua
