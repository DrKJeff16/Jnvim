# Jnvim

## Table Of Contents

<ol>
<li>
<a href="#about">About</a>

<ol>
<li><a href="#requirements">Requirements</a></li>
<li><a href="#structure">Structure</a></li>
<li><a href="#plugins">Plugins</a></li>
</ol>

</li>
<li>
<a href="#api">User API</a>

<ol>
<li><a href="#types"><code>types</code></a></li>
<li><a href="#util"><code>util</code></a></li>
<li><a href="#opts"><code>opts</code></a></li>
<li><a href="#check"><code>check</code></a></li>
<li><a href="#maps"><code>maps</code></a>

<ol>
<li><a href="#wk">
<code>maps.wk</code>
</a>
</ol>

</li>
<li><a href="#highlight"><code>highlight</code></a>
</ol>

</li>
</ol>

---

## About

This is a [Nvim](https://github.com/neovim/neovim) configuration,
configured in a **modular**, **_obsessively documented_**, **portable**
and **platform-independant** way.
<u>Type checking is supported and documentation is included.</u>

This configuration uses [`lazy.nvim`](https://github.com/folke/lazy.nvim)
as the default plugin manager.
Please read the [Plugins section](#plugins) to get an understanding of how this works.

This configuration has its core entirely dependant on the
[`user`](/lua/user) module, which provides a customized
**_API_** which includes **_module checking_**,
**_type checking_**, **_highlighting functions_**,
**_options setting_**, **_keymap functions_**, **_annotations_**, and more.
For more info make sure to check the [User API](#api) section.

### Requirements

This config relies on essential plugins that improve the readability and understanding
of how it works.
For these to work, the following executables must be installed and in your `$PATH`:

* `git`
* [`lua-language-server`](https://github.com/LuaLS/lua-language-server)
* [`vscode-json-languageserver`](https://www.npmjs.com/package/vscode-json-languageserver)
* [`ripgreg`](https://github.com/BurntSushi/ripgrep)
* [`fd`](https://github.com/sharkdp/fd)
* **(Optional _(for `telescope`)_)** [`fzf`](https://github.com/junegunn/fzf)
* **(Optional _(for `Neorg`)_)** `luarocks`

### Structure

```
/lua
├── lazy_cfg/  <== Folder containing all Lua plugin configurations
│   ├── init.lua  <== Plugin Installation and entry points are called
│   ├── plugin1/
│   │   ├── init.lua  <== If submodules exist, entry points are defined here
│   │   └── ...
│   ├── plugin2/
│   │   └── init.lua
│   └── ...
├── user  <== User API module
│   ├── check/  <== Checker Functions
│   │   ├── init.lua  <== Entry points are defined here
│   │   ├── exists.lua  <== Existance checkers
│   │   └── value.lua  <== Value checkers
│   ├── distro/  <== OS Utilities
│   │   ├── init.lua  <== Entry points are defined here
│   │   └── archlinux.lua  <== Archlinux utilities
│   ├── highlight.lua  <== Highlight Functions
│   ├── init.lua  <== API `init`, where entry points are defined
│   ├── maps.lua  <== Mapping Functions
│   ├── opts.lua  <== Vim Options
│   ├── util/  <== Misc Utils
│   │   ├── init.lua  <== Entry points are defined here
│   │   └── notify.lua  <== Notification utilities
│   └── types/  <== Lua Type Annotations and Documentation
│       ├── init.lua  <== Entry points are defined here
│       ├── user/  <== User API Documentation
│       │   ├── init.lua  <== Entry points are defined here
│       │   ├── autocmd.lua  <== Autocommand annotations
│       │   ├── check.lua  <== `check` module annotations
│       │   ├── highlight.lua  <== `highlight` module annotations
│       │   ├── maps.lua  <== `maps` module annotations
│       │   ├── opts.lua  <== `opts` module annotations
│       │   └── util.lua  <== `util` module annotations
│       ├── module_1.lua
│       ├── module_2.lua
│       └── ...
```

### Plugins

There's a lot of plugins included.
Those may be found in [`/lua/lazy_cfg/init.lua`](/lua/lazy_cfg/init.lua).
They are ordered by category, and you can make your own.

<br/>

<b>NOTE:</b> <u>Please refer to
<a href="https://github.com/folke/lazy.nvim"><code>lazy.nvim</code></a>
for more info on how to install plugins.</u>

<br/>

<details>
<summary>
<b><u>Some of the included plugins...</u></b>
</summary>

<br/>

* [`which-key.nvim`](https://github.com/folke/which-key.nvim)
* [`nvim-notify`](https://github.com/rcarriga/nvim-notify)
* [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
* [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
* [`neoconf.nvim`](https://github.com/folke/neoconf.nvim)
* [`lazydev.nvim`](https://github.com/folke/lazydev.nvim)
* [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
* [`cmp-nvim-lsp`](https://github.com/hrsh7th/cmp-nvim-lsp)
* [`LuaSnip`](https://github.com/L3MON4D3/LuaSnip)
* [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim)
* [`noice.nvim`](https://github.com/folke/noice.nvim)
* [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
* [`LuaLine`](https://github.com/nvim-lualine/lualine.nvim)
* [`BarBar`](https://github.com/romgrk/barbar.nvim)
* [`nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua)

</details>

---

<h2 id="api">
The <code>User</code> API
</h2>

The `User` API can be found in [`lua/user`](/lua/user).
It provides a bunch of functionalities to give easier
code structures and to simplify configuration.
**_It's still at an experimental phase, but it works as-is_**.

<h3 id="types">
<u>
<code>user.types</code>
</u>
</h3>

This submodule includes type annotations and documentation.
It can be found in [`user/types`](/lua/user/types).

<br/>

You can include it by using the following code snippet:

```lua
require('user.types[.<type_module>]')
-- Or by using the entry point:
-- require('user').types[.<type_module>]
```

For API-specific documentation, you can use the submodule [`types/user`](/lua/user/types/user):

```lua
require('user.types.user[.<type_module>]')
-- Or by using the entry point:
-- require('user').types.user[.<type_module>]
```

Each directory serves as an entry point for its pertinent files,
sourced by the `init.lua` file in it.

<h3 id="opts">
<u>
<code>user.opts</code>
</u>
</h3>

This submodule can be found at [`here`](/lua/user/opts.lua).
The options are defined in a table to be processed
by the local funtion `optset()`. Modify these at your leisure, but be sure to be compatible with how you'd
use the `vim.opt` table. _`vim.o` is currently used as a fallback in a very lazy way_.

To call the options:

```lua
require('user.opts')
-- Or by using the entry point:
-- require('user').opts
```

- **NOTE: This is still a very early WIP.**

<h3 id="check">
<u>
<code>user.check</code>
</u>
</h3>

_**This is the most important utility for this config.**_ Of critical importance.

<br/>

It provides a table with two
sub-tables. Both used for many conditional checks, aswell as module handling.

<br/>

<u>These are the following:</u>

<ul>
<li>
<b><u>
<code>user.check.value</code>
</u></b>

Used for value checking, differentiation and conditional code, aswell as
for optional parameters in functions.
It can be found in <a href="/lua/user/check/value.lua">
<code>user/check/value.lua</code>
</a>.

<br/>

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

</li>

<br/>

<li>

<b><u>
<code>user.check.exists</code>
</u></b>

Used for data existance checks, conditional module loading and fallback operations.
It can be found in [`user/check/exists.lua`](/lua/user/check/exists.lua).

|   function   |                                                                                                                                                                                              description                                                                                                                              |                       parameter types                           |            return type            |
|:------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------:|:---------------------------------:|
| `module`     |                                                                                           Checks whether a `require(...)` statement is valid, given the input string.<br>If 2nd parameter is `true`, attempt to return said statement if the module can be found.                                                                     |   `mod`: `string`, `return_mod`: `boolean` (default: `false`)   |         `boolean\|unknown`        |
| `modules`    |   Checks whether multiple `require(...)` statements are valid, given the input strings.<br>If 2nd parameter is `false` then check for each string, then stop and return false if one is not valid.<br>If 2nd parameter is `true`, return a dictionary for each key as each input string,<br> and a boolean as its respective value.   |   `mod`: `string[]`, `need_all`: `boolean` (default: `false`)   | `boolean\|table<string, boolean>` |
| `vim_exists` |                                            Checks whether a string or multiple strings are true statements using the Vimscript `exists()` function.<br>If a string array is given, check each string and if any string is invalid, return `false`. Otherwise return `true` when finished.                                             |                    `expr`: `string\|string[]`                   |             `boolean`             |
| `vim_has`    |                                                 Checks whether a string or multiple are true statements when using the Vimscript `has()` function.<br>If a string array is given, check each string and if any string is invalid, return `false`. Otherwise return `true` when finished.                                              |                    `expr`: `string\|string[]`                   |             `boolean`             |
| `vim_isdir`  |                                                                                                                                                                                  Checks whether the string is a directory.                                                                                                            |                        `path`: `string`                         |             `boolean`             |
| `executable` | Checks whether one or multiple strings are executables found in `$PATH`.<br>If a string array is given, check each string and if any string is invalid and the `fallback` parameter is a function then execute the _fallback_ function.<br>This function will return the result regardless of whether `fallback` has been set or not. | `exe`: `string\|string[]`, `fallback`: `fun()` (default: `nil`) |             `boolean`             |

</li>
</ul>

<br/>
<hr/>

<h3 id="maps">
<u><code>maps</code></u>
</h3>

This module provides keymapping utilities in a more
complete, extensible and (hopefully) smarter way for the end user.

There are 3 fields which are tables that have the same function names,
but each one follows a specific behaviour:

* `maps.map`: Follows the behaviour of `vim.api.nvim_set_keymap()`.
* `maps.kmap`: Follows the behaviour of `vim.keymap.set()`.
* `maps.buf_map`: Follows the behaviour of `vim.api.nvim_buf_set_keymap()`.

Parameters and/or parameter types are tweaked for their respective table.
Each table has a function for each mode available,
<b><u>treat each function as the field's behaviour function,
minus the <code>mode</code> field</u></b>:

* `maps.<table>.n(...)`: Same as `:nmap`
* `maps.<table>.i(...)`: Same as `:imap`
* `maps.<table>.v(...)`: Same as `:vmap`
* `maps.<table>.t(...)`: Same as `:tmap`
* `maps.<table>.o(...)`: Same as `:omap`
* `maps.<table>.x(...)`: Same as `:xmap`

Also, each table has a `desc()` method that returns an option table with a description field
and other fields corresponding to each parameter.

<ul>
<li>
<b><u><code>maps.kmap.desc</code></u></b>

<br/>

```lua
--- Returns a `vim.keymap.set.Opts` table
---@param msg: string Defaults do `'Unnamed Key'`
---@param silent? boolean Defaults to `true`
---@param bufnr? integer Not included in output table unless explicitly set
---@param noremap? boolean Defaults to `true`
---@param nowait? boolean Defaults to `true`
---@param expr? boolean Defaults to `false`
---@return vim.keymap.set.Opts
maps.kmap.desc(msg, silent, bufnr, noremap, nowait, expr)
```

</li>

<br/>

<li>
<b><u><code>maps.map.desc</code></u></b> / <b><u><code>maps.buf_map.desc</code></u></b>

<br/>

```lua
--- Returns a `vim.api.keyset.keymap` table
---@param msg: string Defaults do `'Unnamed Key'`
---@param silent? boolean Defaults to `true`
---@param noremap? boolean Defaults to `true`
---@param nowait? boolean Defaults to `true`
---@param expr? boolean Defaults to `false`
---@return vim.api.keyset.keymap
maps.map.desc(msg, silent, noremap, nowait, expr)
```

</li>
</ul>

<br/>

<h4 id="wk">
<code>maps.wk</code>
</h4>

<hr/>

<b>WARNING:</b> <u>For the moment the API won't register a keymap without
a description defined for such keymap
(<i>A.K.A. the</i> <code>desc</code> <i>field in the keymap options</i>)</u>.
I will try to correct for this behaviour later, but for documentation
purposes I'm leaving this bug as an enforcer to keep keymaps documented.

<hr/>

The `maps` API also includes integration with
[`which_key`](https://github.com/folke/which-key.nvim) as `user.maps.wk`.
It can be found found in [`user/maps.lua`](/lua/user/maps.lua)

This module creates mappings using custom-made functions that convert
a specific type of mapping dictionary to a format compatible with `which_key`.
To understand how this works refer to the aforementioned link to the
`which_key` repository.

This module has the method _`wk.available()`_, which simply returns a boolean
indicating whether `which-key` is installed and available to use.
Use it, for example, to setup a fallback for setting keys, like in the
following example:

```lua
local Kmap = require('user').maps.kmap
local WK = require('user').maps.wk

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
--- Using `vim.keymap.set()` (`User.maps.kmap`) as an example.
--- You can translate a `User.maps.map` equivalent the same way, but
--- you'll have to define the buffer number externally if you use
--- `User.maps.buf_map`

---@class KeyMapRhsOptsArr
---@field [1] User.Maps.Keymap.Rhs
---@field [2]? User.Maps.Keymap.Opts

---@alias KeyMapDict table<string, KeyMapRhsOptsArr> A dict with the key as lhs and the value as the class above

---@type KeyMapDict
local Keys = {
    ['lhs1'] = { 'rhs1', { desc = 'Keymap 1' } },
    ['lhs2'] = { function() print('this is rhs2') end, { desc = 'Keymap 1', noremap = true } }
}
```

<br/>

With this dict, you can convert it and then map it using `WK.convert_dict()`
and `WK.register()` respectively.

<ul>
<li>

<details>
<summary>
<b><u>Example 1</u></b>
</summary>

```lua
--- Following the code above the examples...

local Keys_WK = WK.convert_dict()

if WK.available() then
    WK.register(Keys_WK, opts?) -- `opts` defaults to `{ mode = 'n' }`
else
    for lhs, v in next, Keys do
        --- `v[1]` is `rhs`
        --- `v[2]` is `vim.keymap.set.Opts` (in this case using `kmap`)
        Kmap.<vim_mode>(lhs, v[1], v[2])
    end
end
```

</details>
</li>

<br/>

<li>

<details>
<summary>
<b><u>Example 2</u></b>
</summary>

```lua
--- Following the code above the examples...

if WK.available() then
    WK.register(WK.convert_dict(Keys), opts?) -- `opts` defaults to `{ mode = 'n' }`
    -- Wk.register(WK.convert_dict(Keys), { mode = 'n' })
else
    for lhs, v in next, Keys do
        --- `v[1]` is `rhs`
        --- `v[2]` is `vim.keymap.set.Opts` (in this case using `kmap`)
        Kmap.<vim_mode>(lhs, v[1], v[2])
    end
end
```

</details>
</li>
</ul>

<br/>

<code>wk.register()</code> <u>has two arguments</u>:

<br/>

<ol>
<li>
A table of the aforementioned format (or a
<a href="https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings">group names</a>
dictionary, we'll get to that shortly)
</li>
<li>An options table with the structure specified
<a href="https://github.com/folke/which-key.nvim?tab=readme-ov-file#-setup">in
the <code>which_key</code> repository
</a>:

```lua
--- NOTE: These fields are set to their default value in `wk.register`.
---       `nil` means it is not set at all inside the function if not defined,
---       not their valid type (unless explicitly defined as type `nil`).

---@alias MapModes ('n'|'i'|'v'|'t'|'o'|'x')
{
    ---@type MapModes
    mode = 'n',

    --- prefix: use "<leader>f" for example for mapping everything related to finding files
    --- the prefix is prepended to every mapping part of `mappings`
    ---@type string
    prefix = nil,

    ---@type integer|nil
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings

    ---@type boolean
    silent = true, -- use `silent` when creating keymaps

    ---@type boolean
    noremap = true, -- use `noremap` when creating keymaps

    --- NOTE: If processing a group keymap field (`['...'] = { name = '...' }`)
    ---       the default value is `false`
    ---@type boolean
    nowait = true, -- use `nowait` when creating keymaps

    ---@type boolean
    expr = nil, -- use `expr` when creating keymaps
}
```

</li>
</ol>

<br/>

You can also process <u>group names</u> the following way:

```lua
---@class RegPfx
---@field name string The map group name. Should look like `'+Group'`
---@field noremap? boolean Defaults to `true`
---@field nowait? boolean Defaults to `false`
---@field silent? boolean Defaults to `true`

---@alias RegKeysNamed table<string, RegPfx> The key string is the keymap prefix that defines the group

---@type RegKeysNamed
local Names = {
    ['<leader>X'] = { name = '+Group X' },
    ['<leader>X1'] = { name = '+Subgroup X1' },

    ['<leader>t'] = { name = '+Group t' },
}

WK.register(Names, { mode = <whatever mode> })
```

<br/>

<u><b>This API component is in early design so it will be simpler and more
completein the future.</b></u>

---

<h3 id="highlight">
<u>
<code>user.highlight</code>
</u>
</h3>

This module provides utilities for setting highlights in an easier way.
It can be found in [`user/highlight.lua`](/lua/user/highlight.lua).

<b><u>A description will be pending until further notice, i.e. when the module is
structured in a satisfactory manner.</u></b>
