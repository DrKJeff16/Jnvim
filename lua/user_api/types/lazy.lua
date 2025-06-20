---@meta

---@module 'lazy'
---@module 'user_api.types.colorschemes'
---@module 'user_api.types.user.maps'

---@class LazySources
---@field [1] 'lazy'
---@field [2]? 'rockspec'|'packspec'
---@field [3]? 'rockspec'|'packspec'

---@class LazyMods
---@field Colorschemes CscMod

---@alias LazyPlug string|LazyConfig|LazyPluginSpec|LazySpecImport[][]
---@alias LazyPlugs (LazyPlug)[]

---@class PluginUtils
---@field set_tgc fun(force: boolean?)
---@field flag_installed fun(name: string): fun()
---@field colorscheme_init fun(self: PluginUtils, fields: string|table<string, any>, force_tgc: boolean?): fun()
---@field source fun(mod_str: string): fun()
---@field tel_fzf_build fun(): string
---@field luarocks_check fun(): boolean
---@field key_variant fun(cmd: ('ed'|'tabnew'|'split'|'vsplit')?): fun()
---@field has_tgc fun(): boolean

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
