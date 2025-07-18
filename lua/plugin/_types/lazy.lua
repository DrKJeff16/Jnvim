---@meta

error('(plugin._types.lazy): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'lazy'
---@module 'config._types'
---@module 'plugin._types.colorschemes'

---@alias LazySpecs (LazySpec)[]

---@class LazySources
---@field [1] 'lazy'
---@field [2]? 'rockspec'|'packspec'
---@field [3]? 'rockspec'|'packspec'

---@class LazyMods
---@field Colorschemes CscMod

---@alias LazyPlug string|LazyConfig|LazyPluginSpec|LazySpecImport[][]
---@alias LazyPlugs (LazyPlug)[]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
