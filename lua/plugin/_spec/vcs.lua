---@module 'lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local executable = Check.exists.executable

---@type LazySpec[]
local VCS = {
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.git.diffview'),
        cond = executable('git'),
    },
    {
        'kdheepak/lazygit.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        config = CfgUtil.require('plugin.git.lazygit'),
        cond = executable({ 'git', 'lazygit' }),
    },
    {
        'ttibsi/pre-commit.nvim',
        dev = true,
        event = 'VeryLazy',
        version = false,
        cond = executable({ 'git', 'pre-commit' }),
    },
}

return VCS

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
