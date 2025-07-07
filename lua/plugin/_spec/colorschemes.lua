---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')

---@type LazySpecs
local ColorSchemes = {
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        main = 'onedark',
        version = false,
        init = CfgUtil:colorscheme_init('installed_onedark', true),
    },
    {
        'catppuccin/nvim',
        lazy = false,
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = CfgUtil:colorscheme_init('installed_catppuccin', true),
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = CfgUtil:colorscheme_init('installed_tokyonight', true),
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_nightfox', true),
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        main = 'kanagawa',
        version = false,
        init = CfgUtil:colorscheme_init('installed_kanagawa', true),
    },
    {
        'Mofiqul/vscode.nvim',
        lazy = false,
        priority = 1000,
        main = 'vscode',
        version = false,
        init = CfgUtil:colorscheme_init('installed_vscode', true),
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        main = 'gruvbox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_gruvbox', true),
    },
    {
        'bkegley/gloombuddy',
        lazy = false,
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = CfgUtil:colorscheme_init('installed_gloombuddy', true),
    },
    {
        'vigoux/oak',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }, true),
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_colorbuddy', true),
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_spaceduck', true),
    },
    {
        'Mofiqul/dracula.nvim',
        name = 'dracula',
        main = 'dracula',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_dracula', true),
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_space_vim_dark', true),
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_molokai', true),
    },
    {
        'colepeters/spacemacs-theme.vim',
        name = 'spacemacs',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_spacemacs', true),
    },
}

return ColorSchemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
