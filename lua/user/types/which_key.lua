---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModeEnum MapModes

---@class RegKey
---@field [1] string|fun()
---@field [2]? string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@class RegPfx
---@field name string
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean

---@alias RegKeys table<string, RegKey>
---@alias RegKeysNamed table<string, RegPfx>

---@alias RegOpts vim.keymap.set.Opts

---@class WK
---@field reg fun(maps: RegKeys|RegKeysNamed, opts: RegOpts?)
