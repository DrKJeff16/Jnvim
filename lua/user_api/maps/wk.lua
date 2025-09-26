---The Vim modes used for `which-key` as a `string`
---@alias RegModes 'n'|'i'|'v'|'t'|'o'|'x'

---This is an abstraction of `vim.keymaps.set.Opts` (see `User.Maps.Opts`),
---with few extensions.
---
---This table defines a keymap that is used for grouping keymaps with an extra sequence.
---
---This class type is reserved for either direct usage with `which-key`, or most regularly
---for `User.maps.map_dict()` and anything in the `User.maps.wk` module.
--- ---
---@class RegKey
--- AKA `lhs` of a Vim Keymap.
---
---@field [1] string
--- AKA `rhs` of a Vim Keymap.
---
---@field [2] string|fun()
---@field [3]? User.Maps.Opts
--- Keymap's description.
---
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

--- A dictionary of string ==> `RegKey` class
---
---This merely describes a dictionary of `RegKey` type objects
---
---**Example:**
---
---```lua
----- DO NOT COPY THE CODE BELOW OUT OF THE BLUE!!!!
---
------@type RegKeys
---local Keys = {
---    ['<leader>x'] = {
---        rhs()|'rhs',
---        { ... }, ---@see vim.keymap.set.Opts
---        hidden = false,
---        mode = 'n' | 'i' | 'v' | 't' | 'o' | 'x',
---    },
---}
---```
--- ---
---@alias RegKeys table<string, RegKey>

---A dictionary of string ==> `RegPfx` class.
---
---This merely describes a dictionary of `RegPfx` type objects.
---
---**This is only valid if _`which-key`_ is installed.**
---
---@alias RegKeysNamed table<string, RegPfx>

---@alias ModeRegKeys table<MapModes, RegKeys>

---@alias ModeRegKeysNamed table<MapModes, RegKeysNamed>

---A group mapping scheme for usage related to `which-key`.
---
--- - **Warning:** If you remove the `group` field, it'll be parsed as any other table
---
---This class type is reserver for either direct usage with `which-key`, or most regularly
---for `User.maps.map_dict()` and anything in the `User.maps.wk` module.
---
---This table defines a keymap that is used for grouping keymaps with an extra sequence,
---for example:
---
---```
---<leader>fs    <=== [ ] not a group
---<leader>f     <=== [X] this is a group the keymap above belongs to
---```
---
---**_EXAMPLE:_**
---
---```lua
---arbitrory_keys = {
---    ['<leader><leader>']= { group = '+Group1', buffer = 4, hidden = true },
---}
---```
---
--- - `group` (`string`): The name of the group. Optionally you can prepend a `+` to the name,
---                   but I don't think `which-key` cares if you don't do it
---
--- - `hidden` (`boolean`, optional): Determines whether said key should be shown
---                               by `which-key` or not
---
---See `:h vim.keymap.set()` to find the other fields.
--- ---
---@class RegPfx: vim.keymap.set.Opts
---@field mode? MapModes
---@field hidden? boolean
---@field group? string

---Configuration table to be passed to `require('which-key').add()`.
--- ---
---@class RegOpts: wk.Opts
---@field create? boolean
---@field notify? boolean
---@field version? number

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local O = require('user_api.maps.objects')
local Value = require('user_api.check.value')

local is_tbl = Value.is_tbl
local is_str = Value.is_str
local is_bool = Value.is_bool
local type_not_empty = Value.type_not_empty

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---`which_key` API entrypoints.
---@class User.Maps.WK
local WK = {}

---@return boolean
function WK.available()
    return require('user_api.check.exists').module('which-key')
end

---@param lhs string
---@param rhs string|fun()
---@param opts? User.Maps.Opts|vim.keymap.set.Opts|RegPfx
---@return RegKey|RegPfx
function WK.convert(lhs, rhs, opts)
    if not WK.available() then
        error('(user.maps.wk.convert): `which_key` not available', WARN)
    end

    opts = is_tbl(opts) and opts or {}

    ---@type RegKey|RegPfx
    local res = { lhs, rhs }

    if is_bool(opts.hidden) then
        res.hidden = opts.hidden
    end

    if type_not_empty('string', opts.group) then
        res.group = opts.group
        return res
    end

    if type_not_empty('string', opts.desc) then
        res.desc = opts.desc
    end

    return res
end

---@param T AllMaps
---@return AllMaps res
function WK.convert_dict(T)
    ---@type RegKeys
    local res = {}

    for lhs, v in pairs(T) do
        ---@type string|fun()
        local rhs = v[1]

        ---@type User.Maps.Opts
        local opts = is_tbl(v[2]) and v[2] or {}

        table.insert(res, WK.convert(lhs, rhs, opts))
    end

    return res
end

---@param T AllMaps
---@param opts? RegPfx|User.Maps.Opts
---@return false?
function WK.register(T, opts)
    vim.validate('T', T, 'table', false, 'AllMaps')
    vim.validate('opts', opts, 'table', true, 'RegPfx|User.Maps.Opts')

    if not WK.available() then
        vim.notify('(user.maps.wk.register): `which_key` unavailable', ERROR)
        return false
    end

    local WKEY = require('which-key')

    opts = opts or O.new({ mode = 'n' })

    opts.mode = (is_str(opts.mode) and vim.list_contains(MODES, opts.mode)) and opts.mode or 'n'

    ---@type (KeyMapRhsArr|AllMaps|AllModeMaps)[]
    local filtered = {}

    for _, val in pairs(T) do
        table.insert(filtered, val)
    end

    WKEY.add(filtered)
end

return WK

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
