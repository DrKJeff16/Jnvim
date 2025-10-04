---@module 'lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local executable = Check.exists.executable

---@type LazySpec[]
return {
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.git.diffview'),
        enabled = executable('git'),
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
        enabled = executable({ 'git', 'lazygit' }),
    },
    {
        'ttibsi/pre-commit.nvim',
        dev = true,
        event = 'VeryLazy',
        version = false,
        enabled = executable({ 'git', 'pre-commit' }),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
