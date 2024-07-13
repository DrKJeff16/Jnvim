---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModeEnum MapModes

---@class RegKey
---@field [1] string
---@field [2] string|fun()
---@field group? string
---@field hidden? boolean

---@alias RegPfx RegKey

---@alias RegKeys table<string, RegKey>
---@alias RegKeysNamed table<string, RegPfx>

---@class RegOpts
---@field buffer? integer|nil
---@field mode MapModes
---@field prefix? string
---@field silent? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field expr? boolean

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
