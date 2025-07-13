---@module 'plugin._types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local in_console = Check.in_console

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
        config = source('plugin.lazydev'),
        cond = executable('lua-language-server'),
    },
    {
        'folke/trouble.nvim',
        version = false,
        dependencies = { 'nvim-web-devicons' },
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
        version = false,
        config = source('plugin.lsp.inc_rename'),
        enabled = false,
    },
}

return LSP

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
