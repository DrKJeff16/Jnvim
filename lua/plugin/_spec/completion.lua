local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util') ---@see PluginUtils
local types = User.types.lazy

local source = CfgUtil.source
local executable = User.check.exists.executable

---@type (LazySpec)[]
local M = {
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = {
            'onsails/lspkind.nvim',
            'hrsh7th/vim-vsnip',
        },
        init = function()
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
            vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
        end,
        config = source('plugin.cmp'),
    },
    {
        'hrsh7th/vim-vsnip',
        version = false,
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
        'paopaol/cmp-doxygen',
        ft = 'doxygen',
        dependencies = { 'nvim-treesitter-textobjects' },
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
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
