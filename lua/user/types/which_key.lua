---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class RegKey
---@field [1] string
---@field [2]? string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@alias ModeEnum
---| 'n'
---| 'v'
---| 'i'
---| 't'
---| 'o'
---| 'x'

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
