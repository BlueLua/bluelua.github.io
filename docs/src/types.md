---
title: "Types Configuration"
description: "Configure Lua Language Server (LuaLS) to recognize BlueLua types."
---

To enable auto-completion, hover tooltips, and diagnostics for BlueLua modules,
configure the [Lua Language Server (LuaLS)] by adding a [configuration file]
(typically `.luarc.json`) to your project root, or by setting it up directly in
your editor ([VS Code](#vs-code), [Neovim](#neovim), etc.).

## `.luarc.json`

Configure the library paths for your BlueLua modules under `workspace.library`:

```jsonc
{
  "workspace": {
    "library": [
      /*
       * To load types for all installed modules automatically
       * (replace 'x' with your Lua version)
       */
      "/usr/share/lua/5.x",

      /*
       * Or to load types for a single specific module
       * (replace '{module}' with the module name)
       */
      "/usr/share/lua/5.x/{module}/types",
    ],
  },
}
```

## Editor Integration

### VS Code

The [VS Code Lua Extension] automatically reads [`.luarc.json`] in your
workspace root.

Alternatively, add library paths to [.vscode/settings.json]:

```jsonc
{
  "Lua.workspace.library": [
    /*
     * To load types for all installed modules automatically
     * (replace 'x' with your Lua version)
     */
    "/usr/share/lua/5.x",

    /*
     * Or to load types for a single specific module
     * (replace '{module}' with the module name)
     */
    "/usr/share/lua/5.x/{module}/types",
  ],
}
```

### Neovim

When configured via [nvim-lspconfig], the underlying [Lua Language Server
(LuaLS)] automatically detects and reads [`.luarc.json`] in your workspace root.

Alternatively, configure the library paths directly in your configuration:

```lua
---@type vim.lsp.Config
local config = {
  settings = {
    Lua = {
      workspace = {
        library = {
          vim.env.VIMRUNTIME,

          -- To load types for all installed modules automatically
          -- (replace 'x' with your Lua version)
          "/usr/share/lua/5.x",

          -- Or to load types for a single specific module
          -- (replace '{module}' with the module name)
          "/usr/share/lua/5.x/{module}/types",
        }
      }
    }
  }
}

vim.lsp.config('lua_ls', config)
```

For more detailed setup options, refer to the [LuaLS Wiki Configuration Page].

<!-- prettier-ignore-start -->
[Lua Language Server (LuaLS)]: https://luals.github.io/
[configuration file]: https://github.com/LuaLS/lua-language-server/wiki/Configuration-File
[VS Code Lua Extension]: https://marketplace.visualstudio.com/items?itemName=sumneko.lua
[LuaLS Wiki Configuration Page]: https://github.com/LuaLS/lua-language-server/wiki/Configuration-File
[.vscode/settings.json]: vscode://settings/Lua.workspace.library
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[`.luarc.json`]: #luarc-json
<!-- prettier-ignore-end -->
