local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable

---@type (LazySpec)[]
local M = {
    --[[ {

        'hrsh7th/vim-vsnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        gversion = false,
    },
    {
        'onsails/lspkind.nvim',
        lazy = true,
        A
        version = false,
    },
    {
        'hrsh7th/vim-vsnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
    },
    {
        'onsails/lspkind.nvim',
        lazy = true,
        version = false,
    },
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'vim-vsnip' },
        init = function()
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
        end,
        config = source('plugin.cmp'),
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        version = false,
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-cmp' },
    },
    {
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        version = false,
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-cmp' },
    },
    {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        version = false,
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-cmp' },
    },
    {
        'hrsh7th/cmp-buffer',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'nvim-cmp' },
    },
    {
        'hrsh7th/cmp-path',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'nvim-cmp' },
    },
    {
        'https://codeberg.org/FelipeLema/cmp-async-path',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'nvim-cmp' },
    },
    {
        'petertriho/cmp-git',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'nvim-cmp' },
        cond = executable('git'),
    },
    {
        'davidsierradz/cmp-conventionalcommits',
        ft = 'gitcommit',
        version = false,
        dependencies = { 'nvim-cmp' },
        cond = executable('git'),
    },
    {
        'hrsh7th/cmp-cmdline',
        event = 'CmdlineEnter',
        version = false,
        dependencies = { 'nvim-cmp' },
    },
    {
        'paopaol/cmp-doxygen',
        ft = 'doxygen',
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-cmp' },
        cond = executable('doxygen'),
    },
    {
        'vlime/vlime',
        ft = 'lisp',
        version = false,
    },
    {
        'HiPhish/nvim-cmp-vlime',
        ft = 'lisp',
        version = false,
        dependencies = { 'vlime', 'nvim-cmp' },
    }, ]]
    {
        'saghen/blink.cmp',
        version = false,
        dependencies = {
            'L3MON4D3/LuaSnip',
            'folke/lazydev.nvim',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
            'Kaiser-Yang/blink-cmp-git',
        },
        build = executable('cargo') and 'cargo build --release' or false,
        config = source('plugin.blink_cmp'),
    },
    {
        'L3MON4D3/LuaSnip',
        lazy = true,
        build = executable('make') and 'make -j $(nproc) install_jsregexp' or false,
    },
    {
        'onsails/lspkind.nvim',
        lazy = true,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
