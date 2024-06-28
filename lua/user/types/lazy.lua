---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.colorschemes')
require('user.types.user.maps')

---@class LazyMods
---@field colorschemes CscMod

---@alias LazyPlug string|LazyConfig|LazyPluginSpec|LazySpecImport|string|LazyPluginSpec|LazySpecImport|string|LazyPluginSpec|LazySpecImport[][]
---@alias LazyPlugs (LazyPlug)[]

---@class PluginUtils
---@field colorscheme_init fun(fields: string|table<string, any>): fun()
---@field source fun(mod_str: string): fun()
---@field tel_fzf_build fun(): string
---@field luasnip_build fun(): string
---@field luarocks_set fun(): boolean
