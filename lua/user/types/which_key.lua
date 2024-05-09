---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

---@class RegKey
---@field [1] string|fun()
---@field [2]? string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@alias ModeEnum MapModes

---@class RegPfx
---@field name? string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@alias RegKeysTbl table<string, RegPfx|RegKey>

---@class RegOpts
---@field mode? ModeEnum
---@field prefix? string
---@field buffer? integer
---@field silent? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field expr? boolean
---@field desc? boolean
