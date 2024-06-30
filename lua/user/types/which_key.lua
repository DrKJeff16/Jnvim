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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
