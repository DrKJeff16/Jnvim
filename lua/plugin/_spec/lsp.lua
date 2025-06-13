---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local in_console = Check.in_console
local is_root = Check.is_root

---@type (LazySpec)[]
local LSP = {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        version = false,
        config = source('plugin.lsp'),
        enabled = vim_has('nvim-0.8'), --- Constraint specified in the repo
    },
    {
        'b0o/SchemaStore',
        lazy = true,
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
        version = false,
    },
    {
        'folke/neoconf.nvim',
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
        config = source('plugin.lsp.clangd'),
        cond = executable('clangd') and not in_console(),
    },
    {
        'smjonas/inc-rename.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.lsp.inc_rename'),
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        version = false,
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        cond = not is_root(),
    },
}

return LSP

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
