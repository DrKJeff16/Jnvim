local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

local source = CfgUtil.source
local executable = User.check.exists.executable

---@type (LazySpec)[]
local M = {
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
    },

    -- TODO: Future replacement/alternative for `nvim-cmp`.
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'folke/lazydev.nvim' },
        opts = {
            sources = {
                default = {
                    'lazydev',
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                },
            },
        },
        enabled = false,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
