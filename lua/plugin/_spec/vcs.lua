---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable

---@type LazySpecs
local VCS = {
    {
        'tpope/vim-fugitive',
        version = false,
        init = flag_installed('fugitive'),
        cond = executable('git'),
    },
    {
        'lewis6991/gitsigns.nvim',
        version = false,
        config = CfgUtil.require('plugin.git.gitsigns'),
        cond = executable('git'),
    },
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
}

return VCS

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
