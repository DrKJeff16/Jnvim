# Jnvim

## Table Of Contents

1. [About](#about)
    1. [Requirements](#requirements)
    2. [Structure](#structure)
    3. [Plugins](#plugins)
2. [User API](#api)
    1. [`types`](#types)
    2. [`opts`](#opts)
    3. [`check`](#check)
    4. [`maps`](#maps)
    5. [`highlight`](#highlight)

---

## About

This is a [Nvim](https://github.com/neovim/neovim) configuration, configured in a **modular**,
**_obsessively documented_**, **portable** and **platform-independant** way.
Type checking is supported and documentation is included as far as possible.

This configuration uses [`lazy.nvim`](https://github.com/folke/lazy.nvim) as the default plugin manager.
Please read the [Plugins section](#plugins) to get an understanding of how this works.

This configuration has its core entirely dependant on the [`user`](/lua/user) module, which provides a customized
**_API_** which includes **_module checking_**, **_type checking_**, **_highlighting functions_**,
**_options setting_**, **_keymap functions_**, **_annotations_**, and more.
For more info make sure to check the [User API](#api) section.

### Requirements

This config relies on essential plugins that improve the readability and understanding of how it works.
For these to work, the following executables must be installed and in your `$PATH`:

* `git`
* [`lua-language-server`](https://github.com/LuaLS/lua-language-server)
* [`vscode-json-languageserver`](https://www.npmjs.com/package/vscode-json-languageserver)
* [`ripgreg`](https://github.com/BurntSushi/ripgrep)
* [`fd`](https://github.com/sharkdp/fd)
* **(Optional)** [`fzf`](https://github.com/junegunn/fzf)

### Structure

```
/lua
├── lazy_cfg/  <== Folder containing all Lua plugin configurations.
│   ├── init.lua  <== Lazy Plugins are installed from here.
│   ├── plugin1/
│   │   ├── init.lua
│   │   └── ...
│   ├── plugin2/
│   │   └── init.lua
│   └── ...
└── user  <== User API module
    ├── check/  <== Checker Functions
    │   └── init.lua
    ├── highlight.lua  <== Highlight Functions
    ├── init.lua  <== API `init`
    ├── maps.lua  <== Mapping Functions
    ├── opts.lua  <== Vim Options
    └── types/  <== Lua Type Annotations and Documentation
        ├── user/  <== User API Documentation
        ├── module_1.lua
        ├── module_2.lua
        └── ...
```

### Plugins

There's a lot of plugins included. Those may be found in [`/lua/lazy_cfg/init.lua`](/lua/lazy_cfg/init.lua). Those are
ordered by category. Please refer to [`lazy.nvim`](https://github.com/folke/lazy.nvim) for more info on how to install.

Among the most important plugins there are:

* [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
    * [`Comment.nvim`](https://github.com/numToStr/Comment.nvim)
* [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
    * [`neoconf.nvim`](https://github.com/folke/neoconf.nvim)
    * [`neodev.nvim`](https://github.com/folke/neodev.nvim)
* [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
    * [`LuaSnip`](https://github.com/L3MON4D3/LuaSnip)
* [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim)
* [`Noice`](https://github.com/folke/noice.nvim)
* [`nvim-notify`](https://github.com/rcarriga/nvim-notify)
* [`which-key`](https://github.com/folke/which-key.nvim)
* [`telescope`](https://github.com/nvim-telescope/telescope.nvim)
* [`LuaLine`](https://github.com/nvim-lualine/lualine.nvim)
    * [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons)
    * [`BarBar`](https://github.com/romgrk/barbar.nvim)
* [`NvimTree`](https://github.com/nvim-tree/nvim-tree.lua)

---

## API

The `User` API can be found in [`lua/user`](/lua/user). It provides a bunch of functionalities to give easier
code structures and to simplify configuration. **_It's still at an experimental phase, but it works as-is_**.

### Types

This submodule includes type annotations and documentation. It can be found in [`user/types`](/lua/user/types)
You can include it by using the following code snippet:

```lua
require('user.types')
-- Or by using the entry point:
require('user').types
```

For API-specific documentation, you can use the submodule [`types/user`](/lua/user/types/user):

```lua
require('user.types.user')
-- Or by using the entry point:
require('user').types.user
```

Each include their pertinent files sourced by the `init.lua` file.

### Opts

This submodule can be found at [`here`](/lua/user/opts.lua). The options are defined in a table to be processed
by the local funtion `optset()`. Modify these at your leisure, but be sure to be compatible with how you'd
use the `vim.opt` table. _`vim.o` is currently used as a fallback in a very lazy way_.

To call the options:

```lua
require('user.opts')
-- Or by using the entry point:
require('user').opts
```

- **NOTE: This is still a very early WIP.**
