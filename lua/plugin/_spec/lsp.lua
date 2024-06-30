---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'neovim/nvim-lspconfig',
        version = false,
        dependencies = {
            'lazydev.nvim',
            'neoconf.nvim',
            'trouble.nvim',
            'SchemaStore',
        },
        config = source('plugin.lspconfig'),
        enabled = vim_has('nvim-0.8'), --- Constraint specified in the repo
    },
    {
        'b0o/SchemaStore',
        lazy = true,
        version = false,
        enabled = executable('vscode-json-language-server'),
    },
    --- Essential for Nvim Lua files.
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        version = false,
        dependencies = { 'Bilal2453/luvit-meta' },
        config = source('plugin.lspconfig.lazydev'),
        enabled = executable('lua-language-server'),
    },
    { 'Bilal2453/luvit-meta', lazy = true, version = false }, --- optional `vim.uv` typings
    {
        'folke/neoconf.nvim',
        lazy = false,
        version = false,
    },
    {
        'folke/trouble.nvim',
        lazy = false,
        version = false,
        dependencies = { 'nvim-web-devicons' },
        enabled = not in_console(),
    },
    {
        'p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp' },
        version = false,
        config = source('plugin.lspconfig.clangd'),
        enabled = executable('clangd') and not in_console(),
    },
    {
        'smjonas/inc-rename.nvim',
        config = source('plugin.lspconfig.inc_rename'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
