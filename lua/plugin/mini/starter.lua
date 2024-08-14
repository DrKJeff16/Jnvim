local User = require('user_api')
local Check = User.check
local Types = User.types.mini

local exists = Check.exists.module

if not exists('mini.starter') then
    return
end

User.register_plugin('plugin.mini.starter')

local MS = require('mini.starter')
local Sections = MS.sections
local gen_hook = MS.gen_hook

---@type StarterPresets
---@diagnostic disable-next-line:missing-fields
local M = {}

M.simple = {
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

M.telescope = {
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

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
