---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'iamcco/markdown-preview.nvim',
        build = executable('yarn') and 'cd app && yarn install' or '',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        config = source('plugin.md_preview'),
        enabled = not in_console(),
    },
    --- Makefile viewer
    {
        'Zeioth/makeit.nvim',
        ft = { 'make' },
        version = false,
        dependencies = { 'stevearc/overseer.nvim' },
        opts = {},
    },
    --- The task runner used for `makeit.nvim`
    {
        'stevearc/overseer.nvim',
        cmd = { 'MakeitOpen', 'MakeitToggleResults', 'MakeitRedo' },
        version = false,
        opts = {
            task_list = {
                direction = 'bottom',
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
    },
    --- Docs viewer
    {
        'Zeioth/dooku.nvim',
        event = 'VeryLazy',
        version = false,
        enabled = executable('doxygen'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
