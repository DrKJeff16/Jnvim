---@meta
--# selene: allow(unused_variable)
-- luacheck: ignore

---@module 'user_api.maps.wk'
---@module 'user_api.maps.keymap'

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@class User.Maps
local Maps = {}

Maps.modes = MODES

---@type User.Maps.WK
Maps.wk = {}

---@type User.Maps.Keymap
Maps.keymap = {}

---@param desc string
---@param silent? boolean
---@param bufnr? integer|nil
---@param noremap? boolean
---@param nowait? boolean
---@param expr? boolean
---@return User.Maps.Opts res
function Maps.desc(desc, silent, bufnr, noremap, nowait, expr) end

---@param T AllMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes true
---@param mode (MapModes)[]|MapModes
---@param bufnr? integer
function Maps.map_dict(T, map_func, has_modes, mode, bufnr) end

---@param T AllModeMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes? false
---@param mode? nil
---@param bufnr? integer
function Maps.map_dict(T, map_func, has_modes, mode, bufnr) end

---@param T string[]|string
---@param opts? User.Maps.Opts
---@param mode? MapModes
---@param prefix? string
function Maps.nop(T, opts, mode, prefix) end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
