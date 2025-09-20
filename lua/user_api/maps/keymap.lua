--- Available modes
---@alias MapModes 'n'|'i'|'v'|'t'|'o'|'x'

--- Array for available modes
---@alias Modes (MapModes)[]

---@class KeyMapRhsArr
---@field [1] string|fun()
---@field [2]? User.Maps.Opts

---@class KeyMapRhsDict
---@field rhs string|fun()
---@field opts? User.Maps.Opts

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr
---@field [1] string
---@field [2] string|fun()
---@field [3]? User.Maps.Opts

---@alias KeyMapDict table<string, KeyMapRhsArr>
---@alias KeyMapDicts table<string, KeyMapRhsDict>

---@alias AllMaps table<string, KeyMapRhsArr|RegKey|RegPfx>
---@alias AllModeMaps table<MapModes, AllMaps>

---@class KeyMapTbl
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Opts

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

---@param mode MapModes
---@return fun(lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
local function variant(mode)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl

    ---@param lhs string
    ---@param rhs string|fun()
    ---@param opts? vim.keymap.set.Opts
    return function(lhs, rhs, opts)
        opts = is_tbl(opts) and opts or {}

        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@class User.Maps.Keymap
local Keymap = {
    ['n'] = variant('n'),
    ['i'] = variant('i'),
    ['v'] = variant('v'),
    ['t'] = variant('t'),
    ['o'] = variant('o'),
    ['x'] = variant('x'),
}

---@type User.Maps.Keymap
local M = setmetatable({}, {
    __index = Keymap,

    __newindex = function(_, _, _)
        error('(user_api.maps.keymap): Not allowed to modify this table')
    end,
})

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
