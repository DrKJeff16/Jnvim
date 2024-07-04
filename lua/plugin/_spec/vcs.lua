---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'tpope/vim-fugitive',
        event = 'VeryLazy',
        version = false,
        enabled = executable('git'),
    },
    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.gitsigns'),
        enabled = executable('git') and not in_console(),
    },
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.diffview'),
        enabled = executable('git'),
    },
    {
        'kdheepak/lazygit.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'plenary.nvim',
            'telescope.nvim',
        },
        config = source('plugin.lazygit'),
        enabled = executable({ 'git', 'lazygit' }) and not in_console(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
