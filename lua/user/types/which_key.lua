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

---@class RegPfx
---@field name? string

---@alias RegKeysTbl table<string, RegPfx|RegKey>

---@class RegOpts
---@field mode? ModeEnum
---@field prefix string
---@field buffer? nil|integer
---@field silent? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field expr? boolean
