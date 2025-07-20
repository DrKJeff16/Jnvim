---@diagnostic disable:missing-fields

---@module 'which-key'

-- The Vim modes used for `which-key` as a `string`
---@alias RegModes
---|'n'
---|'i'
---|'v'
---|'t'
---|'o'
---|'x'

--- This is an abstraction of `vim.keymaps.set.Opts` (see `User.Maps.Kmap`), with few extensions
--- ---
--- ## Description
---
--- This table defines a keymap that is used for grouping keymaps with an extra sequence,
--- e.g.
---
--- This class type is reserved for either direct usage with `which-key`, or most regularly
--- for `User.maps.map_dict()` and anything in the `User.maps.wk` module
---
--- ---
---@see vim.keymap.set.Opts
---@see User.Maps.WK
---@see RegModes
---@class RegKey: vim.keymap.set.Opts
--- AKA `lhs` of a Vim Keymap
---@field [1] string
--- AKA `rhs` of a Vim Keymap
---@field [2] string|fun()
--- Keymap's description
---@field desc? string
--- If `true`, `which-key` will hide this keymap
--- **See `:h vim.keymap.set()` to find the other fields**
---@field hidden? boolean
--- Any of the Vim modes: `'n'|'i'|'v'|'t'|'o'|'x'`
---@field mode? RegModes
---@field cond? boolean|fun(): boolean
---@field icon? string|wk.Icon|fun(): (wk.Icon|string)
---@field proxy? string
---@field expand? fun(): wk.Spec

--- A **group mapping scheme** for usage related to `which-key`
--- ---
--- ## Description
---
---  * **WARNING:** If you remove the `group` field, it'll be parsed as any other table
---
--- This class type is reserver for either direct usage with `which-key`, or most regularly
--- for `User.maps.map_dict()` and anything in the `User.maps.wk` module
---
--- This table defines a keymap that is used for grouping keymaps with an extra sequence,
--- e.g.
---
--- ```
--- <leader>fs    <=== [ ] not a group
--- <leader>f     <=== [X] this is a group the keymap above belongs to
--- ```
---
--- **_EXAMPLE:_**
---
--- ```lua
--- arbitrory_keys = {
---     ['<leader><leader>']= { group = '+Group1', buffer = 4, hidden = true },
---                         --- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
---                             --- This is the `RegPfx` table
--- }
--- ```
---
--- ---
--- ## Fields
---
--- - **_`group`_** (string): The name of the group. Optionally you can prepend a `+` to the name, but
---                   I don't think `which-key` cares if you don't do it
---
--- - **_`hidden`_** (boolean, **optional**): Determines whether said key should be shown by `which-key` or not
---
--- **See `:h vim.keymap.set()` to find the other fields**
---
--- ---
---@see vim.keymap.set.Opts
---@see User.Maps.WK
---@class RegPfx: vim.keymap.set.Opts
---@field group string

--- A dictionary of string ==> `RegKey` class
--- ---
--- ## Description
---
--- This merely describes a dictionary of `RegKey` type objects
---
--- **Example:**
---
--- ```lua
--- -- DO NOT COPY THE CODE BELOW OUT OF THE BLUE!!!!
---
--- ---@type RegKeys
--- local Keys = {
---     ['<leader>x'] = {
---         rhs()|'rhs',
---         { ... }, ---@see vim.keymap.set.Opts
---         hidden = false,
---         mode = 'n' | 'i' | 'v' | 't' | 'o' | 'x',
---     },
--- }
--- ```
--- @see RegKey
---@alias RegKeys table<string, RegKey>

--- @see RegPfx
--- A dictionary of string ==> `RegPfx` class
--- ---
--- ## Description
---
--- This merely describes a dictionary of `RegPfx` type objects
---
--- - **NOTE:** This is **only valid if** _`which-key`_ is installed
---@alias RegKeysNamed table<string, RegPfx>

---@alias ModeRegKeys table<MapModes, RegKeys>

---@alias ModeRegKeysNamed table<MapModes, RegKeysNamed>

---@class RegKeyOpts: vim.keymap.set.Opts
---@field mode? MapModes
---@field hidden? boolean
---@field group? string

--- Configuration table to be passed to `require('which-key').add()`
--- ---
---@see wk.Opts
---@class RegOpts: wk.Opts
---@field create? boolean
---@field notify? boolean
---@field version? number

---@class User.Maps.WK
---@field available fun(): boolean
---@field convert fun(lhs: string, rhs: User.Maps.Keymap.Rhs|RegKey|RegPfx, opts: (User.Maps.Keymap.Opts|RegKeyOpts)?): RegKey|RegPfx
---@field convert_dict fun(T: KeyMapDict|RegKeys|RegKeysNamed): RegKeys|RegKeysNamed
---@field register fun(T: RegKeys|RegKeysNamed, opts: RegOpts|RegKeyOpts?): false?

local Value = require('user_api.check.value')

local is_tbl = Value.is_tbl
local is_str = Value.is_str
local is_bool = Value.is_bool
local empty = Value.empty

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

--- `which_key` API entrypoints
---@type User.Maps.WK
---@diagnostic disable-next-line:missing-fields
local WK = {}

function WK.available()
    return require('user_api.check.exists').module('which-key')
end

function WK.convert(lhs, rhs, opts)
    if not WK.available() then
        error('(user.maps.wk.convert): `which_key` not available')
    end

    opts = is_tbl(opts) and opts or {}

    ---@type RegKey|RegKeyOpts
    local res = { lhs, rhs }

    if is_bool(opts.hidden) then
        res.hidden = opts.hidden
    end

    if is_str(opts.group) and not empty(opts.group) then
        res.group = opts.group
        return res
    end

    if is_str(opts.desc) and not empty(opts.desc) then
        res.desc = opts.desc
    end

    return res
end

function WK.convert_dict(T)
    ---@type RegKeys
    local res = {}

    for lhs, v in next, T do
        v[2] = is_tbl(v[2]) and v[2] or {}

        table.insert(res, WK.convert(lhs, v[1], v[2]))
    end

    return res
end

function WK.register(T, opts)
    if not WK.available() then
        require('user_api.util.notify').notify('(user.maps.wk.register): `which_key` unavailable')
        return false
    end

    local WKEY = require('which-key')

    opts = is_tbl(opts) and opts or {}

    opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

    ---@type RegKeys
    local filtered = {}

    for _, val in next, T do
        table.insert(filtered, val)
    end

    WKEY.add(filtered)
end

return WK

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
