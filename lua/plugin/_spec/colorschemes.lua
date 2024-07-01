---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local CfgUtil = require('config.util')
local types = User.types.lazy

--- NOTE: This is a global defined in `user`
local Flags = ACTIVATION_FLAGS.plugins.colorschemes ---@see User.ActivationFlags

local is_bool = require('user.check.value').is_bool
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
        enabled = is_bool(Flags.onedark) and Flags.onedark or true,
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = colorscheme_init('installed_catppuccin'),
        enabled = is_bool(Flags.catppuccin) and Flags.catppuccin or true,
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = colorscheme_init('installed_tokyonight'),
        enabled = is_bool(Flags.tokyonight) and Flags.tokyonight or true,
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = colorscheme_init('installed_nightfox'),
        enabled = is_bool(Flags.nightfox) and Flags.nightfox or true,
    },
    {
        'bkegley/gloombuddy',
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = colorscheme_init('installed_gloombuddy'),
        enabled = is_bool(Flags.gloombuddy) and Flags.gloombuddy or true,
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
        enabled = is_bool(Flags.oak) and Flags.oak or true,
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_colorbuddy'),
        enabled = is_bool(Flags.colorbuddy) and Flags.colorbuddy or true,
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_spaceduck'),
        enabled = is_bool(Flags.spaceduck) and Flags.spaceduck or true,
    },
    {
        'dracula/vim',
        lazy = false,
        priority = 1000,
        name = 'dracula',
        version = false,
        init = colorscheme_init('installed_dracula'),
        enabled = is_bool(Flags.dracula) and Flags.dracula or true,
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_space_vim_dark'),
        enabled = is_bool(Flags.space_vim_dark) and Flags.space_vim_dark or true,
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_molokai'),
        enabled = is_bool(Flags.molokai) and Flags.molokai or true,
    },
    {
        'colepeters/spacemacs-theme.vim',
        lazy = false,
        priority = 1000,
        name = 'spacemacs',
        version = false,
        init = colorscheme_init('installed_spacemacs'),
        enabled = is_bool(Flags.spacemacs) and Flags.spacemacs or true,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
