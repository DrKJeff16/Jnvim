---@diagnostic disable:missing-fields

---@alias User.Maps.Keymap.Opts vim.keymap.set.Opts

--- `Rhs` for use in `vim.keymap.set`
---@alias User.Maps.Keymap.Rhs string|fun()

--- Available modes
---@alias MapModes ('n'|'i'|'v'|'t'|'o'|'x')

--- Array for available modes
---@alias Modes (MapModes)[]

---@class KeyMapRhsOptsArr
---@field [1] User.Maps.Keymap.Rhs
---@field [2]? User.Maps.Keymap.Opts

---@class KeyMapRhsOptsDict
---@field rhs User.Maps.Keymap.Rhs
---@field opts? User.Maps.Keymap.Opts

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr
---@field [1] string
---@field [2] string|fun()
---@field [3]? User.Maps.Keymap.Opts

---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@alias AllMaps table<string, KeyMapRhsOptsArr|RegKey|RegPfx>

---@class AllModeMaps
---@field n? AllMaps
---@field i? AllMaps
---@field v? AllMaps
---@field t? AllMaps
---@field o? AllMaps
---@field x? AllMaps

---@class KeyMapTbl
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Keymap.Opts

---@class KeyMapOpts: vim.keymap.set.Opts
---@field new fun(T: (User.Maps.Keymap.Opts|table)?): KeyMapOpts
---@field add fun(self: KeyMapOpts, T: User.Maps.Keymap.Opts|table)

---@alias KeyMapFunction fun(lhs: string, rhs: User.Maps.Keymap.Rhs, opts: User.Maps.Keymap.Opts?)

---@alias KeyMapModeDict table<MapModes, KeyMapDict>
---@alias KeyMapModeDicts table<MapModes, KeyMapTbl[]>

---@alias MapFuncs KeyMapFunction

---@alias KeyDescFun fun(msg: string, silent: boolean?, bufnr: integer?, noremap: boolean?, nowait: boolean?, expr: boolean?): User.Maps.Keymap.Opts

---@class User.Maps.Keymap
---@field n KeyMapFunction
---@field i KeyMapFunction
---@field v KeyMapFunction
---@field t KeyMapFunction
---@field o KeyMapFunction
---@field x KeyMapFunction
---@field desc KeyDescFun

---@type KeyMapOpts
local O = {}

---@param self KeyMapOpts
---@param T table|KeyMapOpts
function O:add(T)
    local is_str = require('user_api.check.value').is_str

    for k, v in next, T do
        if is_str(k) then
            self[T] = v
        end
    end
end

---@param T? User.Maps.Keymap.Opts|table
---@return KeyMapOpts|table
function O.new(T)
    local is_tbl = require('user_api.check.value').is_tbl
    T = is_tbl(T) and T or {}

    return setmetatable(T, { __index = O })
end

---@param mode MapModes
---@return KeyMapFunction
local function variant(mode)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_bool = Value.is_bool

    ---@type KeyMapFunction
    return function(lhs, rhs, opts)
        local DEFAULTS = { 'noremap', 'silent' }
        opts = is_tbl(opts) and opts or {}

        for _, v in next, DEFAULTS do
            opts[v] = is_bool(opts[v]) and opts[v] or true
        end

        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@type User.Maps.Keymap
local Kmap = {}

---@param msg? string|'Unnamed Key'
---@param silent? boolean
---@param bufnr? integer|nil
---@param noremap? boolean
---@param nowait? boolean
---@param expr? boolean
---@return User.Maps.Keymap.Opts|table
function Kmap.desc(msg, silent, bufnr, noremap, nowait, expr)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_int = Value.is_int
    local is_bool = Value.is_bool
    local empty = Value.empty

    ---@type KeyMapOpts
    local res = O.new({
        desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
        silent = is_bool(silent) and silent or true,
        noremap = is_bool(noremap) and noremap or true,
        nowait = is_bool(nowait) and nowait or true,
        expr = is_bool(expr) and expr or false,
    })

    if is_int(bufnr) then
        res.buffer = bufnr
    end

    return res
end

Kmap.n = variant('n')
Kmap.i = variant('i')
Kmap.v = variant('v')
Kmap.t = variant('t')
Kmap.o = variant('o')
Kmap.x = variant('x')

return Kmap

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
