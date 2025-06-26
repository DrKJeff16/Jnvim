---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')

local has_tgc = CfgUtil.has_tgc

---@type (LazySpec)[]
local ColorSchemes = {
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        main = 'onedark',
        version = false,
        init = CfgUtil:colorscheme_init('installed_onedark', true),
        cond = has_tgc(),
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = CfgUtil:colorscheme_init('installed_catppuccin', true),
        cond = has_tgc(),
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = CfgUtil:colorscheme_init('installed_tokyonight', true),
        cond = has_tgc(),
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_nightfox', true),
        cond = has_tgc(),
    },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000,
        main = 'kanagawa',
        version = false,
        init = CfgUtil:colorscheme_init('installed_kanagawa', true),
        cond = has_tgc(),
    },
    {
        'Mofiqul/vscode.nvim',
        priority = 1000,
        main = 'vscode',
        version = false,
        init = CfgUtil:colorscheme_init('installed_vscode', true),
        cond = has_tgc(),
    },
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        main = 'gruvbox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_gruvbox', true),
        cond = has_tgc(),
    },
    {
        'bkegley/gloombuddy',
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = CfgUtil:colorscheme_init('installed_gloombuddy', true),
    },
    {
        'vigoux/oak',
        priority = 1000,
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }, true),
    },
    {
        'tjdevries/colorbuddy.vim',
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_colorbuddy', true),
    },
    {
        'pineapplegiant/spaceduck',
        priority = 1000,
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init('installed_spaceduck', true),
        cond = has_tgc(),
    },
    {
        'dracula/vim',
        priority = 1000,
        name = 'dracula',
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init('installed_dracula', true),
    },
    {
        'liuchengxu/space-vim-dark',
        priority = 1000,
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init('installed_space_vim_dark', true),
    },
    {
        'tomasr/molokai',
        priority = 1000,
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init('installed_molokai', true),
    },
    {
        'colepeters/spacemacs-theme.vim',
        priority = 1000,
        name = 'spacemacs',
        lazy = false,
        version = false,
        init = CfgUtil:colorscheme_init('installed_spacemacs', true),
    },
}

return ColorSchemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
