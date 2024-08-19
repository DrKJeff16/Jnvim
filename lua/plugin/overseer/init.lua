local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local is_nil = Check.value.is_nil
local empty = Check.value.empty
local au = User.util.au.au_repeated

local augroup = vim.api.nvim_create_augroup
local ucmd = vim.api.nvim_create_user_command

if not exists('overseer') then
    return
end

User.register_plugin('plugin.overseer')

local OS = require('overseer')

local Opts = {
    task_list = {
        direction = 'bottom',
        min_height = 25,
        max_height = 25,
        default_detail = 1,
    },

    templates = {
        'builtin',
        'user.c_build',
        'user.clang_build',
        'user.clangpp_build',
        'user.cpp_build',
    },
}

local group = augroup('UserOverseer', { clear = false })

---@type AuRepeat
local AUCMDS = { WatchRun = {} }

if executable('stylua') and exists('overseer.template.user.stylua') then
    table.insert(Opts.templates, 'user.stylua')
end

OS.setup(Opts)

ucmd('OverseerRestartLast', function()
    local overseer = require('overseer')
    local tasks = overseer.list_tasks({ recent_first = true })
    if empty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], 'restart')
    end
end, {})

au(AUCMDS)
