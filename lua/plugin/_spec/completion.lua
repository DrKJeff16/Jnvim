---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

local source = CfgUtil.source
local luasnip_build = CfgUtil.luasnip_build

---@type LazySpec[]
local M = {
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = {
            'onsails/lspkind.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-document-symbol',
            'hrsh7th/cmp-nvim-lsp-signature-help',

            'hrsh7th/cmp-buffer',

            'hrsh7th/cmp-path',
            'https://codeberg.org/FelipeLema/cmp-async-path',

            'petertriho/cmp-git',
            'davidsierradz/cmp-conventionalcommits',

            'hrsh7th/cmp-cmdline',

            'saadparwaiz1/cmp_luasnip',
        },
        init = function()
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
            vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
        end,
        config = source('plugin.cmp'),
    },
    {
        'paopaol/cmp-doxygen',
        lazy = true,
        dependencies = {
            'nvim-treesitter-textobjects',
        },
    },
    {
        'rafamadriz/friendly-snippets',
        version = false,
    },
    {
        'L3MON4D3/LuaSnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        build = luasnip_build(),
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
