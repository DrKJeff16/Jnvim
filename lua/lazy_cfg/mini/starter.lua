---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local types = User.types.mini

local exists = Check.exists.module

if not exists('mini.starter') then
    return
end

local MS = require('mini.starter')
local Sections = MS.sections
local gen_hook = MS.gen_hook

---@type StarterPresets
---@diagnostic disable-next-line:missing-fields
local M = {}

--[[ local footer_n_seconds = (function()
    local timer = vim.uv.new_timer()
    local n_seconds = 0
    timer:start(0, 1000, vim.schedule_wrap(function()
        if vim.bo.filetype ~= 'starter' then
            timer:stop()
            return
        end
        n_seconds = n_seconds + 1
        MS.refresh()
    end))

    return function()
        return 'Number of seconds since opening: ' .. tostring(n_seconds)
    end
end)() ]]

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
    silent = false,
    footer = nil,
    header = 'TELESCOPE',
    query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
}

return M
