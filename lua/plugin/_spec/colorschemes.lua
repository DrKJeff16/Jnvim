---@module 'config.lazy'

local CfgUtil = require('config.util')

local in_console = require('user_api.check').in_console

-- WARN: Colorschemes are called from `lua/plugin/colorschemes/init.lua`

---@type LazySpecs
local ColorSchemes = {
    {
        'folke/tokyonight.nvim',
        main = 'tokyonight',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_tokyonight'),
        cond = not in_console(),
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_catppuccin'),
        cond = not in_console(),
    },
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_onedark'),
        cond = not in_console(),
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_nightfox'),
        cond = not in_console(),
    },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_kanagawa'),
        cond = not in_console(),
    },
    {
        'Mofiqul/vscode.nvim',
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_vscode'),
        cond = not in_console(),
    },
    {
        'Mofiqul/dracula.nvim',
        name = 'dracula',
        main = 'dracula',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_dracula'),
    },
    {
        'ellisonleao/gruvbox.nvim',
        main = 'gruvbox',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_gruvbox'),
        cond = not in_console(),
    },
    {
        'bkegley/gloombuddy',
        lazy = false,
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = CfgUtil.colorscheme_init('installed_gloombuddy'),
        cond = not in_console(),
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_colorbuddy'),
        cond = not in_console(),
    },
    {
        'vigoux/oak',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }),
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_spaceduck'),
        cond = not in_console(),
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_space_vim_dark'),
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_molokai'),
    },
    {
        'colepeters/spacemacs-theme.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = CfgUtil.colorscheme_init('installed_spacemacs'),
    },
}

return ColorSchemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
