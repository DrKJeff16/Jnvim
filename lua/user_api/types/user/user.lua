---@meta

error('`user_apu.types.user.user` is not to be sourced!', vim.log.levels.ERROR)

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table
---@alias Maps table<MapModes, table<string, KeyMapRhsOptsArr>>

---@class UserAPI
---@field check User.Check
---@field commands User.Commands
---@field distro User.Distro
---@field highlight User.Hl
---@field maps User.Maps
---@field opts User.Opts
---@field update User.Update
---@field util User.Util
---@field registered_plugins string[]
---@field register_plugin fun(self: UserAPI, pathstr: string, index: integer?)
---@field reload_plugins fun(self: UserAPI): (failed: string[]|table)
---@field setup_keys fun(self: UserAPI)
---@field new fun(O: table?): UserAPI|table
---@field print_loaded_plugins fun(self: UserAPI)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
