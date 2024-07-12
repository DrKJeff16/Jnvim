---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        version = false,
        build = executable('yarn') and 'cd app && yarn install' or '',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        config = source('plugin.md_preview'),
        cond = not in_console(),
    },
    --- Makefile viewer
    {
        'Zeioth/makeit.nvim',
        ft = { 'make' },
        version = false,
        dependencies = { 'stevearc/overseer.nvim' },
        opts = {},
        cond = not in_console(),
    },
    --- The task runner used for `makeit.nvim`
    {
        'stevearc/overseer.nvim',
        version = false,
        opts = {
            task_list = {
                direction = 'bottom',
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
        cond = not in_console(),
    },
    --- Docs viewer
    {
        'Zeioth/dooku.nvim',
        lazy = true,
        version = false,
        cond = executable('doxygen'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
