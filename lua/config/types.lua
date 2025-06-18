---@meta

---@module 'user_api.types.user.maps'

---@class Keymaps.PreExec
---@field ft string[]
---@field bt string[]

---@class Config.Keymaps
---@field NOP string[] Table of keys to no-op after `<leader>` is pressed
---@field no_oped? boolean
---@field Keys AllModeMaps
---@field set_leader fun(self: Config.Keymaps, leader: string, local_leader: string?, force: boolean?)
---@field setup fun(self: Config.Keymaps, keys: AllModeMaps, bufnr: integer?)
---@field new fun(O: table?): table|Config.Keymaps
