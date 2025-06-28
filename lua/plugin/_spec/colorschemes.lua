---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')

local has_tgc = CfgUtil.has_tgc

---@type (LazySpec)[]
local ColorSchemes = {
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        main = 'onedark',
        version = false,
        init = CfgUtil:colorscheme_init('installed_onedark', true),
        cond = has_tgc(),
    },
    {
        'catppuccin/nvim',
        lazy = false,
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = CfgUtil:colorscheme_init('installed_catppuccin', true),
        cond = has_tgc(),
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = CfgUtil:colorscheme_init('installed_tokyonight', true),
        cond = has_tgc(),
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_nightfox', true),
        cond = has_tgc(),
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        main = 'kanagawa',
        version = false,
        init = CfgUtil:colorscheme_init('installed_kanagawa', true),
        cond = has_tgc(),
    },
    {
        'Mofiqul/vscode.nvim',
        lazy = false,
        priority = 1000,
        main = 'vscode',
        version = false,
        init = CfgUtil:colorscheme_init('installed_vscode', true),
        cond = has_tgc(),
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        main = 'gruvbox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_gruvbox', true),
        cond = has_tgc(),
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
        cond = has_tgc(),
    },
    {
        'dracula/vim',
        name = 'dracula',
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
