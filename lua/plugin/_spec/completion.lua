---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

local source = CfgUtil.source
local luasnip_build = CfgUtil.luasnip_build
local executable = User.check.exists.executable

---@type (LazySpec)[]
local M = {
    {
        'L3MON4D3/LuaSnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        build = luasnip_build(),
    },
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'onsails/lspkind.nvim' },
        init = function()
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
            vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
        end,
        config = source('plugin.cmp'),
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        version = false,
        dependencies = { 'nvim-lspconfig' },
    },
    {
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        version = false,
        dependencies = { 'nvim-lspconfig' },
    },
    {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        version = false,
        dependencies = { 'nvim-lspconfig' },
    },
    {
        'hrsh7th/cmp-buffer',
        version = false,
    },
    {
        'hrsh7th/cmp-path',
        version = false,
    },
    {
        'https://codeberg.org/FelipeLema/cmp-async-path',
        version = false,
    },
    {
        'petertriho/cmp-git',
        version = false,
        cond = executable('git'),
    },
    {
        'davidsierradz/cmp-conventionalcommits',
        ft = 'gitcommit',
        version = false,
        cond = executable('git'),
    },
    {
        'hrsh7th/cmp-cmdline',
        event = 'CmdlineEnter',
        version = false,
    },
    {
        'saadparwaiz1/cmp_luasnip',
        version = false,
        dependencies = { 'LuaSnip' },
    },
    {
        'paopaol/cmp-doxygen',
        ft = 'doxygen',
        dependencies = { 'nvim-treesitter-textobjects' },
        cond = executable('doxygen'),
    },
    {
        'rafamadriz/friendly-snippets',
        lazy = false,
        version = false,
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
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
