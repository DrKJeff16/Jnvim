---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local tel_fzf_build = CfgUtil.tel_fzf_build
local executable = Check.exists.executable

---@type LazySpecs
local Telescope = {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = { 'plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = source('plugin.telescope'),
    },
    {
        'OliverChao/telescope-picker-list.nvim',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        version = false,
        build = tel_fzf_build(),
        dependencies = { 'nvim-telescope/telescope.nvim' },
        cond = executable('fzf'),
    },
    -- TODO: Split into its file
    {
        'LukasPietzschmann/telescope-tabs',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = source('plugin.telescope.tabs'),
    },
    {
        'DrKJeff16/telescope-makefile',
        ft = 'make',
        version = false,
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'akinsho/toggleterm.nvim',
        },
        config = function()
            -- TODO: Separate this into its own submodule
            require('telescope-makefile').setup({})

            require('telescope').load_extension('make')
        end,
        cond = (executable('make') or executable('mingw32-make')) and not in_console(),
    },
    {
        'olacin/telescope-cc.nvim',
        ft = 'gitcommit',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        cond = executable('git'),
    },
}

return Telescope

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
