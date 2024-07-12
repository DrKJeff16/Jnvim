---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias MiniModules table<string, table|nil>

---@class StarterItem.Spec
---@field name string
---@field action string
---@field section string|integer

---@alias StarterPreset.Items (table|fun(): StarterItem.Spec|StarterItem.Spec)[]
---@alias StarterPreset.Hooks (fun()|table)[]

---@class StarterPreset
---@field evaluate_single? boolean
---@field items StarterPreset.Items|nil
---@field content_hooks? StarterPreset.Hooks|nil
---@field footer? string|fun(...): string|nil
---@field header? string|fun(...): string|nil
---@field autoopen? boolean
---@field silent? boolean
---@field query_updaters?
---|'abcdefghijklmnopqrstuvwxyz0123456789_-.'
---|'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.'

---@class StarterPresets
---@field simple StarterPreset
---@field telescope StarterPreset

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
