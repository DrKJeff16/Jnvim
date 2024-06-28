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
        lazy = false,
        version = false,
        enabled = executable('git'),
    },
    {
        'lewis6991/gitsigns.nvim',
        version = false,
        config = source('plugin.gitsigns'),
        enabled = executable('git') and not in_console(),
    },
    {
        'sindrets/diffview.nvim',
        version = false,
        config = source('plugin.diffview'),
        enabled = executable('git'),
    },
    {
        'kdheepak/lazygit.nvim',
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
