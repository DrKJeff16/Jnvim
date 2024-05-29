---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModeEnum MapModes

---@class RegKey
---@field [1] string|fun()
---@field [2] string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@class RegPfx
---@field name string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@alias RegKeys table<string, RegKey|'which_key_ignore'|string|{ integer: string }>
---@alias RegKeysNamed table<string, RegPfx>

---@class RegOpts
---@field buffer? integer|nil
---@field mode MapModes
---@field prefix? string
---@field silent? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field expr? boolean

---@class WK
---@field reg fun(maps: RegKeys|RegKeysNamed, opts: RegOpts?)
