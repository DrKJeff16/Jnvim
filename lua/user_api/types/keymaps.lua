---@meta

error('(user_api.types.keymaps): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'user_api.types.maps'

---@class Keymaps.PreExec
---@field ft string[]
---@field bt string[]

---@class User.Config.Keymaps
---@field NOP string[] Table of keys to no-op after `<leader>` is pressed
---@field no_oped? boolean
---@field Keys AllModeMaps
---@field set_leader fun(self: User.Config.Keymaps, leader: string, local_leader: string?, force: boolean?)
---@field new fun(O: table?): table|User.Config.Keymaps|fun(keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)

---@alias KeymapsFun fun(keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)
