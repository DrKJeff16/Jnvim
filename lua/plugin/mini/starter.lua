---@diagnostic disable:missing-fields

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

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('mini.starter') then
    return
end

local MS = require('mini.starter')
local Sections = MS.sections
local gen_hook = MS.gen_hook

---@type StarterPresets
local Starter = {}

Starter.simple = {
    evaluate_single = false,

    items = {
        Sections.builtin_actions(),
        Sections.recent_files(5, true, true),
        Sections.recent_files(2, false, true),
    },

    content_hooks = {
        gen_hook.adding_bullet('=> ', false),
        gen_hook.indexing('all', { 'Builtin actions' }),
        gen_hook.padding(2, 2),
        gen_hook.aligning('center', 'center'),
    },

    autoopen = true,
    silent = false,
    footer = nil,
    header = nil,
    query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
}

Starter.telescope = {
    evaluate_single = false,

    items = {
        Sections.telescope(),
    },

    content_hooks = {
        gen_hook.adding_bullet('=> '),
        gen_hook.aligning('center', 'center'),
    },

    autoopen = true,
    silent = true,
    footer = nil,
    header = 'TELESCOPE',
    query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
}

User.register_plugin('plugin.mini.starter')

return Starter

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
