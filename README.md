<div align="center">

# Jnvim

</div>

## Table Of Contents

1. [About](#about)
    1. [Requirements](#requirements)
    2. [Structure](#structure)
    3. [Plugins](#plugins)
2. [User API](#the-user-api)
    1. [`user_api.types`](#user_apitypes)
    2. [`user_api.util`](#user_apiutil)
    3. [`user_api.opts`](#user_apiutil)
    4. [`user_api.check`](#user_apicheck)
    5. [`user_api.maps`](#user_apimaps)
        1. [`user_api.kmap.desc`](#user_apikmapdesc)
        2. [`user_api.maps.wk`](#user_apimapswk)
    6. [`user_api.highlight`](#user_apihighlight)

---

## About

This is a [Nvim](https://github.com/neovim/neovim) configuration,
configured in a **modular, _obsessively documented_, portable
and platform-independent** way. Typed documentation is included.

This configuration uses [`lazy.nvim`](https://github.com/folke/lazy.nvim)
as the default plugin manager.
Please read the [Plugins section](#plugins) to get an understanding of how this works.

This configuration has its core entirely dependant on the
[`user_api`](lua/user_api) module, which provides a customized
**_API_** which includes **_module checking_**,
**_type checking_**, **_highlighting functions_**,
**_options setting_**, **_keymap functions_**, **_annotations_**, and more.
For more info make sure to check the [User API](#the-user-api) section.

### Requirements

- **(Optional, but recommended):** A [patched font](https://www.nerdfonts.com)

This config relies on essential plugins that improve the readability and understanding
of how it works.
For these to work, the following executables must be installed and in your `$PATH`:

- `git`
- [`lua-language-server`](https://github.com/LuaLS/lua-language-server)
- [`vscode-json-languageserver`](https://www.npmjs.com/package/vscode-json-languageserver)
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- **(Optional _(for `telescope`)_)**:
    - [`fzf`](https://github.com/junegunn/fzf)
    - [`fd`](https://github.com/sharkdp/fd)
- **(Optional _(for `Lazy` and/or `Neorg`)_)**:
    - `luarocks`
    - `pathspec`

### Structure

```
/lua
├── config/  <== Folder containing all Lua plugin configurations
│   ├── keymaps.lua  <== Setup default, non-plugin keymaps here
│   ├── lazy.lua  <== Plugin Installation. `plugin._spec` entry points are called here
│   └── util.lua  <== Utilities used in the file above (env checks, etc.)
├── plugin/  <==  Plugins are configured in this directory
│   ├── _spec/  <== Plugin categories are stored here in files serving as categories. `config.lazy` calls this  directory
│   │   ├── essentials.lua  <== Essential plugins. TREAT THIS ONE WITH CARE
│   │   ├── colorschemes.lua  <== Colorscheme plugins
│   │   ├── completion.lua  <== Completion plugins
│   │   ├── editing.lua  <== Editing enhancement plugins
│   │   ├── lsp.lua  <== LSP-related plugins
│   │   ├── neorg.lua  <== Neorg-related plugins
│   │   ├── syntax.lua  <== Syntax plugins
│   │   ├── telescope.lua  <== Telescope-related plugins
│   │   ├── treesitter.lua  <== Treesitter plugins
│   │   ├── ui.lua  <== UI-enhancement plugins
│   │   ├── utils.lua  <== Utilitary plugins
│   │   └── vcs.lua  <== Version Control plugins
│   ├── plugin1/  <== Arbitrary plugin #1
│   │   └── init.lua  <== Entry points + setup
│   ├── plugin2/  <== Arbitrary plugin #2
│   │   ├── init.lua  <== Entry points + setup
│   │   └── submoule.lua  <== Arbitrary submodule
│   └── ...  <==  More plugin configs...
├── user_api/  <== User API module
│   ├── init.lua  <== API entry points
│   ├── check/  <== Checker Functions
│   │   ├── init.lua  <== Entry points are defined here
│   │   ├── exists.lua  <== Existance checkers
│   │   └── value.lua  <== Value checkers
│   ├── commands.lua  <== User-defined commands
│   ├── distro/  <== OS Utilities
│   │   ├── init.lua  <== Entry points are defined here
│   │   └── archlinux.lua  <== Arch Linux utilities
│   ├── highlight.lua  <== Highlight Functions
│   ├── maps/  <== Mapping Utilities
│   │   ├── init.lua  <== Entry points are defined here
│   │   ├── kmap.lua  <== `vim.keymap.set` utilities
│   │   └── wk.lua  <== `which_key` utilities (regardless if installed or not)
│   ├── opts/  <== Vim Option Utilities
│   │   ├── init.lua  <== Entry points are defined here
│   │   ├── all_opts.lua  <== Internal checking utility [DO NOT TOUCH]
│   │   └── config.lua  <== Default options set here
│   ├── update.lua  <== Update utilities
│   ├── util/  <== Misc Utils
│   │   ├── init.lua  <== Entry points are defined here
│   │   ├── autocmd.lua  <== Autocommand utilities
│   │   ├── notify.lua  <== Notification utilities
│   │   └── string.lua  <== String operators/pre-defined lists
│   └── types/  <== Lua Type Annotations and Documentation
│       ├── init.lua  <== Entry points are defined here
│       ├── user/  <== User API Documentation
│       │   ├── init.lua  <== Entry points are defined here
│       │   ├── autocmd.lua  <== Autocommand annotations
│       │   ├── check.lua  <== `check` module annotations
│       │   ├── commands.lua  <== `commands` module annotations
│       │   ├── highlight.lua  <== `highlight` module annotations
│       │   ├── maps.lua  <== `maps` module annotations
│       │   ├── opts.lua  <== `opts` module annotations
│       │   ├── update.lua  <== `update` module annotations (WIP)
│       │   └── util.lua  <== `util` module annotations
└───────└── ...  <== Other annotations
```

### Plugins

There's a lot of plugins included.
The plugins are installed based on the files in the [`lua/plugin/_spec`](lua/plugin/_spec) directory.
_You can create your own category file or expand from the existant files in said directory._
Just make sure to read the
[`lazy.nvim`](https://github.com/folke/lazy.nvim) documentation for more info on how to install plugins.

**_Some of the included plugins..._**

- [`which-key.nvim`](https://github.com/folke/which-key.nvim)
- [`mini.nvim`](https://github.com/echasnovski/mini.nvim)
- [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim)
- [`nvim-notify`](https://github.com/rcarriga/nvim-notify)
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
- [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
- [`neoconf.nvim`](https://github.com/folke/neoconf.nvim)
- [`lazydev.nvim`](https://github.com/folke/lazydev.nvim)
- [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
- [`noice.nvim`](https://github.com/folke/noice.nvim)
- [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
- [`LuaLine`](https://github.com/nvim-lualine/lualine.nvim)
- [`nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua)
- [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons)

---

## The `user` API

The `user` API can be found in [`lua/user_api`](lua/user_api).
It provides a bunch of functionalities to give easier
code structures and to simplify configuration.
**_It's still at an experimental phase, but it works as-is_**.

### `user_api.types`

This submodule includes type annotations and documentation.
It can be found in [`user_api/types`](lua/user_api/types).

- You can include it by using the following code snippet:

```lua
require('user_api.types.module_name')
-- Or by using the entry point (not recommended):
require('user_api').types.module_name
```

For API-specific documentation, you can find them in the submodule [`user_api/types/user`](lua/user_api/types/user):

```lua
require('user_api.types.user.module_name')
-- Or by using the entry point (not recommended):
require('user_api').types.user.module_name
```

Each directory serves as an entry point for its pertinent files,
sourced by the `init.lua` file in it.

### `user_api.opts`

This submodule can be found at [`here`](lua/user_api/opts.lua).
The options are defined in a default table to be processed
by the funtion `opts.setup()`.

To call the options:

```lua
local Opts1 = require('user_api.opts')
Opts1:setup()
--- Or by using the entry point:
local Opts2 = require('user_api').opts
Opts2:setup()
```

The `setup()` function optionally accepts a dictionary-like table with your own vim options.
It overwrites some of the default options as defined in [`opts.lua`](lua/user_api/opts.lua).
**MAKE SURE THEY CAN BE ACCEPTED BY `vim.opt`**.

As an example:

```lua
local User = require('user_api')
local Opts = User.opts

Opts:setup({
    completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
    nu = false, -- `:set nonumber`

    -- These equate to `:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab`
    -- In the cmdline
    ts = 4,
    sts = 4,
    sw = 4,
    et = true,

    wrap = false,
})
```

### `user_api.check`

_**This is the most important utility for this config.**_ It currently provides a table with two
sub-tables. Both used for many conditional checks, aswell as module handling.

_These are the following:_

- **`user_api.check.value`**
    Used for value checking, differentiation and conditional code, aswell as
    for optional parameters in functions.
    It can be found in [`user_api/check/value.lua`](lua/user_api/check/value.lua).
    |  function  |                                                                                               description                                                                                               |                          parameter types                          | return type |
    |:----------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------:|:-----------:|
    |  `is_nil`  | Checks whether the input values are `nil`<br>(AKA whether they even exist).<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`. | `var`: `unknown\|table`, `multiple`: `boolean` (default: `false`) |  `boolean`  |
    |  `is_str`  |            Checks whether the input values are of `string` type.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.            |                        _Same as `is_nil`_.                        |  `boolean`  |
    |  `is_num`  |            Checks whether the input values are of `number` type.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.            |                        _Same as `is_nil`_.                        |  `boolean`  |
    |  `is_bool` |            Checks whether the input values are of `boolean` type.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.           |                        _Same as `is_nil`_.                        |  `boolean`  |
    |  `is_fun`  |           Checks whether the input values are of `function` type.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.           |                        _Same as `is_nil`_.                        |  `boolean`  |
    |  `is_tbl`  |             Checks whether the input values are of `table` type.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.            |                        _Same as `is_nil`._                        |  `boolean`  |
    |  `is_int`  |              Checks whether the input values are **integers**.<br>By default it checks for a single value,<br>but can be told to check for multiple<br>by setting the 2nd param as `true`.              |                        _Same as `is_nil`._                        |  `boolean`  |
    |  `empty`   |              If input is a string, checks for an empty string.<br>If input is number, checks for value `0`.<br>If input is table, checks for an empty table.<br>If other type return `true`.            |                    `v`: `string\|number\|table`                   |  `boolean`  |

- **`user_api.check.exists`**
    Used for data existance checks, conditional module loading and fallback operations.
    It can be found in [`user_api/check/exists.lua`](lua/user_api/check/exists.lua).
    |   function   |                                                                                                                                                                                              description                                                                                                                              |                       parameter types                           |            return type            |
    |:------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------:|:---------------------------------:|
    | `module`     |                                                                                           Checks whether a `require(...)` statement is valid, given the input string.<br>If 2nd parameter is `true`, attempt to return said statement if the module can be found.                                                                     |   `mod`: `string`, `return_mod`: `boolean` (default: `false`)   |         `boolean\|unknown`        |
    | `modules`    |   Checks whether multiple `require(...)` statements are valid, given the input strings.<br>If 2nd parameter is `false` then check for each string, then stop and return false if one is not valid.<br>If 2nd parameter is `true`, return a dictionary for each key as each input string,<br> and a boolean as its respective value.   |   `mod`: `string[]`, `need_all`: `boolean` (default: `false`)   | `boolean\|table<string, boolean>` |
    | `vim_exists` |                                            Checks whether a string or multiple strings are true statements using the Vimscript `exists()` function.<br>If a string array is given, check each string and if any string is invalid, return `false`. Otherwise return `true` when finished.                                             |                    `expr`: `string\|string[]`                   |             `boolean`             |
    | `vim_has`    |                                                 Checks whether a string or multiple are true statements when using the Vimscript `has()` function.<br>If a string array is given, check each string and if any string is invalid, return `false`. Otherwise return `true` when finished.                                              |                    `expr`: `string\|string[]`                   |             `boolean`             |
    | `vim_isdir`  |                                                                                                                                                                                  Checks whether the string is a directory.                                                                                                            |                        `path`: `string`                         |             `boolean`             |
    | `executable` | Checks whether one or multiple strings are executables found in `$PATH`.<br>If a string array is given, check each string and if any string is invalid and the `fallback` parameter is a function then execute the _fallback_ function.<br>This function will return the result regardless of whether `fallback` has been set or not. | `exe`: `string\|string[]`, `fallback`: `fun()` (default: `nil`) |             `boolean`             |

---

### `user_api.maps`

This module provides keymapping utilities in a more
complete, extensible and (hopefully) smarter way for the end user.

The `maps.kmap` module has the same function names for each mode:

* `maps.kmap.n(...)`: Same as `:nmap`
* `maps.kmap.i(...)`: Same as `:imap`
* `maps.kmap.v(...)`: Same as `:vmap`
* `maps.kmap.t(...)`: Same as `:tmap`
* `maps.kmap.o(...)`: Same as `:omap`
* `maps.kmap.x(...)`: Same as `:xmap`

<!--TODO: Fix sections above and below-->

#### `user_api.kmap.desc`

There exists a `kmap.desc()` method that returns an option table with a description field
and other fields corresponding to each parameter.

```lua
--- Returns a `vim.keymap.set.Opts` table
---@param msg: string Defaults to `'Unnamed Key'`
---@param silent? boolean Defaults to `true`
---@param bufnr? integer|nil Not included in output table unless explicitly set
---@param noremap? boolean Defaults to `true`
---@param nowait? boolean Defaults to `true`
---@param expr? boolean Defaults to `false`
---@return vim.keymap.set.Opts
maps.kmap.desc(msg, silent, bufnr, noremap, nowait, expr)
```

The function returns this table:

```lua
-- DO NOT COPY THIS DIRECTLY
{
    desc = 'Unnamed Key' or msg, -- First option is the default
    silent = true or false, -- First option is the default
    noremap = true or false, -- First option is the default
    nowait = true or false, -- First option is the default
    expr = false or true, -- First option is the default

    -- If buffer is passed as an argument:
    buffer = bufnr or 0,
}
```

#### `user_api.maps.wk`

The `maps` API also includes integration with
[`which_key`](https://github.com/folke/which-key.nvim) as `user_api.maps.wk`.
It can be found found in [`user_api/maps.lua`](lua/user_api/maps.lua)

This module creates mappings using custom-made functions that convert
a specific type of mapping dictionary to a format compatible with `which_key`.
To understand how this works refer to the aforementioned link to the
`which_key` repository.

This module has the method _`wk.available()`_, which simply returns a boolean
indicating whether `which-key` is installed and available to use.
Use it, for example, to setup a fallback for setting keys, like in the
following example:

```lua
local Kmap = require('user_api.maps.kmap')
local WK = require('user_api.maps.wk')

local my_keys = {
    --- Your maps go here...
}

if WK.available() then
    --- Use `WK`
else
    --- Use `Kmap`
end

```

If you try to use `wk.register()` despite not being available it'll
return `false` and refuse to process your keymaps altogether.

If you want to convert a keymap table, you must first structure it as follows:

```lua
-- Using `vim.keymap.set()` (`User.maps.kmap`) as an example.

---@class KeyMapRhsOptsArr
---@field [1] User.Maps.Keymap.Rhs
---@field [2]? User.Maps.Keymap.Opts

---@alias KeyMapDict table<string, KeyMapRhsOptsArr> A dict with the key as lhs and the value as the class above

---@alias MapMode ('n'|'i'|'v'|'t'|'o'|'x') Vim Mode
---@alias MapModes MapMode[]

---@alias KeyMapModeDict table<MapMode, KeyMapDict>

-- Without modes
---@type KeyMapDict
local Keys1 = {
    ['lhs1'] = { 'rhs1', { desc = 'Keymap 1' } },
    ['lhs2'] = { function() print('this is rhs2') end, { desc = 'Keymap 1', noremap = true } }
}

-- With modes
---@type KeyMapModeDict
local Keys2 = {
    -- Normal Mode Keys
    n = {
        ['n_lhs1'] = { 'n_rhs1', { desc = 'Keymap 1' } },
        ['n_lhs2'] = { function() print('this is n_rhs2') end, { desc = 'Keymap 1', noremap = true } },
    },
    v = {
        ['v_lhs1'] = { 'v_rhs1', { desc = 'Keymap 1 (Visual Mode)' } },
    }
}
```

You can then pass this dictionary to [`user_api.maps.map_dict()`](lua/user_api/maps/init.lua):

- **Example**
    ```lua
    -- Following the code above...

    local map_dict = require('user_api.maps').map_dict

    -- NOTE: Third parameter is `false` because the `Keys1` table doesn't tell what mode to use
    map_dict(Keys1, 'wk.register', false, 'n')

    -- NOTE: Third parameter is `true` because the `Keys2` table tells us what modes to use,
    -- so fourth param can be `nil`
    map_dict(Keys2, 'wk.register', true, nil)
    ```

- You can also process **keymap groups** the following way:
    ```lua
    ---@class RegPfx
    ---@field group string The map group name. Should look like `'+Group'`
    ---@field hidden? boolean Whether to show the map in `which-key`
    ---@field mode? MapModes @see user_api.types.user.maps

    ---@alias RegKeysNamed table<string, RegKeysNamed>

    ---@type RegKeysNamed
    local Names = {
        ['<leader>X'] = { group = '+Group X' },
        ['<leader>X1'] = { group = '+Subgroup X1' },

        ['<leader>t'] = { group = '+Group t' },
    }

    -- If `which_key` is available
    if require('user_api.maps.wk').available() then
        require('user_api.maps').map_dict(Names, 'wk.register', false, 'n')
    end
    ```

**_This API component is in early design so it will be simpler and more
complete in the future._**

---

### `user_api.highlight`

This module provides utilities for setting highlights in an easier way.
It can be found in [`user_api/highlight.lua`](lua/user_api/highlight.lua).

_A description will be pending until further notice, i.e. when the module is
structured in a satisfactory manner._

---
