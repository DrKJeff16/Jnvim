---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local colorscheme_init = CfgUtil.colorscheme_init

---@type LazySpec[]
local M = {
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        main = 'onedark',
        version = false,
        init = colorscheme_init('installed_onedark'),
        enabled = vim.o.termguicolors,
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = colorscheme_init('installed_catppuccin'),
        enabled = vim.o.termguicolors,
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = colorscheme_init('installed_tokyonight'),
        enabled = vim.o.termguicolors,
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = colorscheme_init('installed_nightfox'),
        enabled = vim.o.termguicolors,
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        main = 'kanagawa',
        version = false,
        init = colorscheme_init('installed_kanagawa'),
        enabled = vim.o.termguicolors,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        main = 'gruvbox',
        version = false,
        init = colorscheme_init('installed_gruvbox'),
        enabled = vim.o.termguicolors,
    },
    {
        'bkegley/gloombuddy',
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = colorscheme_init('installed_gloombuddy'),
    },
    {
        'vigoux/oak',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }),
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_colorbuddy'),
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_spaceduck'),
        enabled = vim.o.termguicolors,
    },
    {
        'dracula/vim',
        lazy = false,
        priority = 1000,
        name = 'dracula',
        version = false,
        init = colorscheme_init('installed_dracula'),
        enabled = vim.o.termguicolors,
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_space_vim_dark'),
        enabled = vim.o.termguicolors,
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_molokai'),
        enabled = vim.o.termguicolors,
    },
    {
        'colepeters/spacemacs-theme.vim',
        lazy = false,
        priority = 1000,
        name = 'spacemacs',
        version = false,
        init = colorscheme_init('installed_spacemacs'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
