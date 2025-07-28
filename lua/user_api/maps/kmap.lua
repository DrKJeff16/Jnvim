---@diagnostic disable:missing-fields

---@module 'user_api.maps.wk'

---@class KeyMapOpts: vim.keymap.set.Opts
---@field new fun(O: table?): table|KeyMapOpts
---@field add fun(self: KeyMapOpts, T: table|User.Maps.Keymap.Opts)

---@alias User.Maps.Keymap.Opts (vim.keymap.set.Opts|KeyMapOpts)

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

---@alias KeyMapFun fun(lhs: string, rhs: User.Maps.Keymap.Rhs, opts: (User.Maps.Keymap.Opts)?)

---@class KeyMapModeDict
---@field n KeyMapDict
---@field i KeyMapDict
---@field v KeyMapDict
---@field t KeyMapDict
---@field o KeyMapDict
---@field x KeyMapDict

---@class KeyMapModeDicts
---@field n KeyMapTbl[]
---@field i KeyMapTbl[]
---@field v KeyMapTbl[]
---@field t KeyMapTbl[]
---@field o KeyMapTbl[]
---@field x KeyMapTbl[]

---@alias KeyDescFun fun(msg: string, silent: boolean?, bufnr: integer?, noremap: boolean?, nowait: boolean?, expr: boolean?): res: User.Maps.Keymap.Opts

---@type KeyMapOpts
local O = {}

---@param self KeyMapOpts
---@param T table
function O:add(T)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        return
    end

    for k, v in next, T do
        self[k] = v
    end
end

---@param T? table
---@return KeyMapOpts|table
function O.new(T)
    local is_tbl = require('user_api.check.value').is_tbl
    T = is_tbl(T) and T or {}

    return setmetatable(T, {
        __index = O,
    })
end

---@param mode MapModes
---@return KeyMapFun
local function variant(mode)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl

    ---@param lhs string
    ---@param rhs User.Maps.Keymap.Rhs
    ---@param opts? User.Maps.Keymap.Opts
    return function(lhs, rhs, opts)
        opts = is_tbl(opts) and opts or {}

        opts = O.new(vim.deepcopy(opts))

        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@class User.Maps.Keymap
---@field n KeyMapFun
---@field i KeyMapFun
---@field v KeyMapFun
---@field t KeyMapFun
---@field o KeyMapFun
---@field x KeyMapFun
---@field desc KeyDescFun
local Kmap = {}

---@param msg? string|'Unnamed Key'
---@param silent? boolean
---@param bufnr? integer|nil
---@param noremap? boolean
---@param nowait? boolean
---@param expr? boolean
---@return KeyMapOpts res
function Kmap.desc(msg, silent, bufnr, noremap, nowait, expr)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty
    local is_int = Value.is_int

    if not type_not_empty('string', msg) then
        msg = 'Unnamed Key'
    end
    if silent == nil then
        silent = true
    end
    if noremap == nil then
        noremap = true
    end
    if nowait == nil then
        nowait = true
    end
    if expr == nil then
        expr = false
    end

    ---@type table|KeyMapOpts
    local res = O.new()

    res:add({
        desc = msg,
        silent = silent,
        noremap = noremap,
        nowait = nowait,
        expr = expr,
    })

    if is_int(bufnr) then
        res:add({ buffer = bufnr })
    end

    return res
end

Kmap.n = variant('n')
Kmap.i = variant('i')
Kmap.v = variant('v')
Kmap.t = variant('t')
Kmap.o = variant('o')
Kmap.x = variant('x')

return setmetatable({}, {
    __index = Kmap,

    __newindex = function(self, k, v)
        error('(user_api.maps.kmap): Not allowed to modify this table')
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
