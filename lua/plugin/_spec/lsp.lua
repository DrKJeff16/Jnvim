---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local vim_has = Check.exists.vim_has

---@type LazySpecs
local LSP = {
    {
        'neovim/nvim-lspconfig',
        version = false,
        cond = vim_has('nvim-0.11'), --- Constraint specified in the repo
    },
    {
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false,
    },
    --- Essential for Nvim Lua files
    {
        'folke/lazydev.nvim',
        dev = true,
        ft = 'lua',
        version = false,
        dependencies = {
            { 'justinsgithub/wezterm-types', lazy = true, dev = true, version = false },
        },
        config = CfgUtil.require('plugin.lazydev'),
        cond = executable('lua-language-server'),
    },

    {
        'stevearc/aerial.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        config = CfgUtil.require('plugin.aerial'),
    },

    {
        'folke/trouble.nvim',
        dev = true,
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        'p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp' },
        dev = true,
        version = false,
        config = CfgUtil.require('plugin.lsp.clangd'),
        cond = executable('clangd'),
    },
}

return LSP

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
