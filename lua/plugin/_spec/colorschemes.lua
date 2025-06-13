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
        init = CfgUtil:colorscheme_init('installed_onedark'),
        cond = has_tgc(),
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = CfgUtil:colorscheme_init('installed_catppuccin'),
        cond = has_tgc(),
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = CfgUtil:colorscheme_init('installed_tokyonight'),
        cond = has_tgc(),
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_nightfox'),
        cond = has_tgc(),
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        main = 'kanagawa',
        version = false,
        init = CfgUtil:colorscheme_init('installed_kanagawa'),
        cond = has_tgc(),
    },
    {
        'Mofiqul/vscode.nvim',
        lazy = false,
        priority = 1000,
        main = 'vscode',
        version = false,
        init = CfgUtil:colorscheme_init('installed_vscode'),
        cond = has_tgc(),
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        main = 'gruvbox',
        version = false,
        init = CfgUtil:colorscheme_init('installed_gruvbox'),
        cond = has_tgc(),
    },
    {
        'bkegley/gloombuddy',
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = CfgUtil:colorscheme_init('installed_gloombuddy'),
    },
    {
        'vigoux/oak',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }),
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_colorbuddy'),
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_spaceduck'),
        cond = has_tgc(),
    },
    {
        'dracula/vim',
        lazy = false,
        priority = 1000,
        name = 'dracula',
        version = false,
        init = CfgUtil:colorscheme_init('installed_dracula'),
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_space_vim_dark'),
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil:colorscheme_init('installed_molokai'),
    },
    {
        'colepeters/spacemacs-theme.vim',
        lazy = false,
        priority = 1000,
        name = 'spacemacs',
        version = false,
        init = CfgUtil:colorscheme_init('installed_spacemacs'),
    },
}

return ColorSchemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
