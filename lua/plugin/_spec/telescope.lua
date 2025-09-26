---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local tel_fzf_build = CfgUtil.tel_fzf_build
local executable = Check.exists.executable

---@type LazySpec[]
local Telescope = {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            { 'nvim-lua/plenary.nvim', version = false },
            { 'debugloop/telescope-undo.nvim', version = false },
            { 'OliverChao/telescope-picker-list.nvim', version = false },
            { 'nvim-telescope/telescope-file-browser.nvim', version = false },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                version = false,
                build = tel_fzf_build(),
                cond = executable('fzf'),
            },
            {
                'LukasPietzschmann/telescope-tabs',
                version = false,
                config = CfgUtil.require('plugin.telescope.tabs'),
            },
            {
                'DrKJeff16/telescope-makefile',
                ft = 'make',
                version = false,
                dependencies = { 'akinsho/toggleterm.nvim' },
                config = CfgUtil.require('plugin.telescope.makefile'),
                cond = executable('make') or executable('mingw32-make'),
            },
            {
                'olacin/telescope-cc.nvim',
                ft = 'gitcommit',
                version = false,
                cond = executable('git'),
            },
        },
        config = CfgUtil.require('plugin.telescope'),
    },
}

return Telescope

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
