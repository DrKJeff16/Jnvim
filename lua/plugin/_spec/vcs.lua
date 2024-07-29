---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'tpope/vim-fugitive',
        version = false,
        cond = executable('git'),
    },
    {
        'lewis6991/gitsigns.nvim',
        version = false,
        config = source('plugin.gitsigns'),
        cond = executable('git') and not in_console(),
    },
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.diffview'),
        cond = executable('git'),
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
        cond = executable({ 'git', 'lazygit' }),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
