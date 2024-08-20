local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console
local is_root = Check.is_root

---@type (LazySpec)[]
local M = {
    {
        'neovim/nvim-lspconfig',
        version = false,
        config = source('plugin.lspconfig'),
        enabled = vim_has('nvim-0.8'), --- Constraint specified in the repo
    },
    {
        'b0o/SchemaStore',
        event = 'VeryLazy',
        version = false,
        cond = executable('vscode-json-language-server'),
    },
    --- Essential for Nvim Lua files
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        version = false,
        dependencies = { 'Bilal2453/luvit-meta' },
        config = source('plugin.lazydev'),
        cond = executable('lua-language-server'),
    },
    --- optional `vim.uv` typings
    {
        'Bilal2453/luvit-meta',
        lazy = true,
        version = false,
    },
    {
        'folke/neoconf.nvim',
        lazy = true,
        version = false,
    },
    {
        'folke/trouble.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        cond = not in_console(),
    },
    {
        'p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp' },
        version = false,
        config = source('plugin.lspconfig.clangd'),
        cond = executable('clangd') and not in_console(),
    },
    {
        'smjonas/inc-rename.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.lspconfig.inc_rename'),
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = true,
        version = false,
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        cond = not is_root(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
