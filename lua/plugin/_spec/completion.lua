---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

--- NOTE: This is a global defined in `user`
local Flags = ACTIVATION_FLAGS.plugins.completion ---@see User.ActivationFlags

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
        enabled = Flags.cmp,
    },
    {
        'paopaol/cmp-doxygen',
        lazy = true,
        dependencies = {
            'nvim-treesitter-textobjects',
        },
        enabled = Flags.cmp,
    },
    {
        'rafamadriz/friendly-snippets',
        lazy = false,
        version = false,
        enabled = Flags.luasnip and Flags.cmp,
    },
    {
        'L3MON4D3/LuaSnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        build = luasnip_build(),
        enabled = Flags.luasnip,
    },
    {
        'vlime/vlime',
        ft = 'lisp',
        version = false,
        enabled = Flags.vlime,
    },
    {
        'HiPhish/nvim-cmp-vlime',
        ft = 'lisp',
        version = false,
        enabled = Flags.vlime,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
