---@class AuPair
---@field event string[]|string
---@field opts vim.api.keyset.create_autocmd

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl vim.api.keyset.create_autocmd[]

---@alias AuDict table<string, vim.api.keyset.create_autocmd>
---@alias AuRepeat table<string, vim.api.keyset.create_autocmd[]>
---@alias AuList AuPair[]

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local optset = vim.api.nvim_set_option_value
local optget = vim.api.nvim_get_option_value
local curr_win = vim.api.nvim_get_current_win
local notify = require('user_api.util.notify').notify

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local group = augroup('User.AU', { clear = true })

local function bt_get(bufnr)
    require('user_api.util').bt_get(bufnr)
end
local function ft_get(bufnr)
    require('user_api.util').ft_get(bufnr)
end

local function ft_set(s, bufnr)
    require('user_api.util').ft_set(s, bufnr)
end

---@class User.Util.Autocmd
local M = {}

---@type AuRepeatEvents[]
M.created = {
    -- NOTE: Keep this as first element for `orgmode` addition
    {
        events = { 'BufCreate', 'BufAdd', 'BufNew', 'BufNewFile', 'BufRead' },
        opts_tbl = {
            {
                group = group,
                pattern = '.spacemacs',
                callback = function(ev)
                    ft_set('lisp', ev.buf)()
                end,
            },
            {
                group = group,
                pattern = '*.el',
                callback = function(ev)
                    ft_set('lisp', ev.buf)()
                end,
            },
            {
                group = group,
                pattern = '*.org',
                callback = function(ev)
                    ft_set('org', ev.buf)()
                end,
            },
            {
                group = group,
                pattern = '.clangd',
                callback = function(ev)
                    ft_set('yaml', ev.buf)()
                end,
            },
            {
                group = group,
                pattern = '*.norg',
                callback = function(ev)
                    ft_set('norg', ev.buf)()
                end,
            },
            {
                group = group,
                pattern = { '*.c', '*.h' },
                callback = function(ev)
                    ---@type vim.api.keyset.option
                    local setopt_opts = { buf = ev.buf }
                    local opt_dict = {
                        tabstop = 2,
                        shiftwidth = 2,
                        softtabstop = 2,
                        expandtab = true,
                        autoindent = true,
                        filetype = 'c',
                    }

                    for opt, val in pairs(opt_dict) do
                        optset(opt, val, setopt_opts)
                    end
                end,
            },
            {
                group = group,
                pattern = {
                    '*.C',
                    '*.H',
                    '*.c++',
                    '*.cc',
                    '*.cpp',
                    '*.cxx',
                    '*.h++',
                    '*.hh',
                    '*.hpp',
                    '*.html',
                    '*.hxx',
                    '*.md',
                    '*.mdx',
                    '*.yaml',
                    '*.yml',
                },
                callback = function(ev)
                    ---@type vim.api.keyset.option
                    local setopt_opts = { buf = ev.buf }
                    local opt_dict = {
                        tabstop = 2,
                        shiftwidth = 2,
                        softtabstop = 2,
                        expandtab = true,
                        autoindent = true,
                    }

                    for opt, val in pairs(opt_dict) do
                        optset(opt, val, setopt_opts)
                    end
                end,
            },
        },
    },
    {
        events = { 'FileType' },
        opts_tbl = {
            {
                pattern = 'checkhealth',
                group = group,
                callback = function()
                    ---@type vim.api.keyset.option
                    local O = { scope = 'local' }
                    optset('wrap', true, O)
                    optset('number', false, O)
                    optset('signcolumn', 'no', O)
                end,
            },
        },
    },
    {
        events = { 'TextYankPost' },
        opts_tbl = {
            {
                pattern = '*',
                group = group,
                callback = function()
                    vim.hl.on_yank({ higroup = 'Visual', timeout = 300 })
                end,
            },
        },
    },
    {
        events = { 'BufEnter', 'WinEnter', 'BufWinEnter' },
        opts_tbl = {
            {
                group = group,
                callback = function(ev)
                    local Keymaps = require('user_api.config.keymaps')
                    local executable = require('user_api.check.exists').executable
                    local desc = require('user_api.maps').desc

                    local bt = bt_get(ev.buf)
                    local ft = ft_get(ev.buf)

                    ---@type vim.api.keyset.option
                    local win_opts = { win = curr_win() }

                    ---@type vim.api.keyset.option
                    local buf_opts = { buf = ev.buf }

                    if ft == 'lazy' then
                        optset('signcolumn', 'no', win_opts)
                        optset('number', false, win_opts)
                        return
                    end

                    if bt == 'help' or ft == 'help' then
                        optset('signcolumn', 'no', win_opts)
                        optset('number', false, win_opts)
                        optset('wrap', true, win_opts)
                        optset('colorcolumn', '', win_opts)

                        vim.keymap.set('n', 'q', vim.cmd.bdelete, { buffer = ev.buf })

                        local fn = vim.schedule_wrap(function()
                            vim.cmd.wincmd('=')
                            vim.cmd.noh()
                        end)

                        fn()
                        return
                    end

                    if not optget('modifiable', buf_opts) then
                        return
                    end

                    if ft == 'lua' and executable('stylua') then
                        Keymaps({
                            n = {
                                ['<leader><C-l>'] = {
                                    function()
                                        ---@diagnostic disable-next-line:param-type-mismatch
                                        local ok = pcall(vim.cmd, 'silent! !stylua %')

                                        if not ok then
                                            return
                                        end

                                        notify('Formatted successfully!', INFO, {
                                            title = 'StyLua',
                                            animate = true,
                                            timeout = 200,
                                            hide_from_history = true,
                                        })
                                    end,
                                    desc('Format With `stylua`'),
                                },
                            },
                        }, ev.buf)
                    end

                    if ft == 'python' and executable('isort') then
                        Keymaps({
                            n = {
                                ['<leader><C-l>'] = {
                                    function()
                                        ---@diagnostic disable-next-line:param-type-mismatch
                                        local ok = pcall(vim.cmd, 'silent! !isort %')

                                        if not ok then
                                            return
                                        end

                                        notify('Formatted successfully!', INFO, {
                                            title = 'isort',
                                            animate = true,
                                            timeout = 200,
                                            hide_from_history = true,
                                        })
                                    end,
                                    desc('Format With `isort`'),
                                },
                            },
                        }, ev.buf)
                    end
                end,
            },
        },
    },
}

---@param T AuPair
function M.au_pair(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        error('(user_api.util.au.au_pair): Not a table, or empty table', ERROR)
    end

    if not (type_not_empty('string', T.event) or type_not_empty('table', T.event)) then
        error('(user_api.util.au.au_pair): Event is neither a string nor a table', ERROR)
    end

    au(T.event, T.opts)
end

---@param T AuList
function M.au_from_arr(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
        return
    end

    for _, v in ipairs(T) do
        if
            not (
                type_not_empty('string', v.event)
                or type_not_empty('table', v.event) and type_not_empty('table', v.opts)
            )
        then
            error(
                '(user_api.util.au.au_from_arr): Event is neither a string nor a table, skipping',
                ERROR
            )
        end

        au(v.event, v.opts)
    end
end

---@param T AuDict
function M.au_from_dict(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
        return
    end

    for k, v in pairs(T) do
        if not (is_str(k) and type_not_empty('table', v)) then
            error('(user_api.util.au.au_from_arr): Dictionary key is not a string, skipping', ERROR)
        end

        au(k, v)
    end
end

---@param T AuRepeat
function M.au_repeated(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_repeated): Param is not a valid table', ERROR)
        return
    end

    for event, t in pairs(T) do
        if not is_str(event) then
            error('(user_api.util.au.au_repeated): Event is not a string, skipping', ERROR)
        end

        if not type_not_empty('table', t) then
            error('(user_api.util.au.au_repeated): Invalid options table, skipping', ERROR)
        end

        for _, opts in ipairs(t) do
            if not type_not_empty('table', opts) then
                vim.notify('(user_api.util.au.au_repeated): Option table is empty, skipping', ERROR)
                break
            end

            au(event, opts)
        end
    end
end

---@param T AuRepeatEvents
function M.au_repeated_events(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_repeated_events): Not a valid table', ERROR)
        return
    end

    if not (type_not_empty('table', T.events) and type_not_empty('table', T.opts_tbl)) then
        vim.notify('(user_api.util.au.au_repeated_events): Invalid autocmd tables', WARN)
        return
    end

    for _, opts in ipairs(T.opts_tbl) do
        if not type_not_empty('table', opts) then
            error('(user_api.util.au.au_repeated_events): Options are not a vaild table', ERROR)
        end

        au(T.events, opts)
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
