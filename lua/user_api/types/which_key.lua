---@class RegKey: vim.keymap.set.Opts
---@field [1] string
---@field [2] string|fun()
---@field desc? string
---@field group? string
---@field hidden? boolean
---@field mode? MapModes

---@class RegPfx
---@field group? string
---@field hidden? boolean
---@field mode? MapModes

---@alias RegKeys table<string, RegKey>
---@alias RegKeysNamed table<string, RegPfx>
---@alias ModeRegKeys table<MapModes, RegKeys>
---@alias ModeRegKeysNamed table<MapModes, RegKeysNamed>

---@class RegKeyOpts
---@field desc? string
---@field mode? MapModes
---@field hidden? boolean
---@field group? string

---@class RegOpts
---@field create? boolean
---@field notify? boolean
---@field version? number

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
