---@meta

error('(user_api.types.user): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table
---@alias Maps table<MapModes, table<string, KeyMapRhsOptsArr>>

---@class User.Config
---@field keymaps User.Config.Keymaps

---@class UserAPI
---@field paths string[]|table
---@field FAILED string[]|table
---@field check User.Check
---@field config User.Config
---@field commands User.Commands
---@field distro User.Distro|fun()
---@field highlight User.Hl
---@field maps User.Maps
---@field opts User.Opts|fun(override: table|vim.bo|vim.wo?, verbose: boolean?)
---@field update User.Update
---@field util User.Util
---@field registered_plugins string[]
---@field register_plugin fun(self: UserAPI, pathstr: string, index: integer?)
---@field reload_plugins fun(self: UserAPI): boolean,(string[]|table)
---@field setup_keys fun(self: UserAPI)
---@field plugin_maps fun(self: UserAPI)
---@field new fun(O: table?): table|UserAPI
---@field print_loaded_plugins fun(self: UserAPI)
---@field sleep fun(t: number)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
