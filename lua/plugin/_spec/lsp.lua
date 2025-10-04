---@module 'lazy'

local CfgUtil = require('config.util')

---@type LazySpec[]
return {
    { 'neovim/nvim-lspconfig', version = false },
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    {
        'folke/lazydev.nvim',
        version = false,
        dependencies = {
            { 'DrKJeff16/wezterm-types', lazy = true, dev = true, version = false },
        },
        config = CfgUtil.require('plugin.lazydev'),
        enabled = require('user_api.check.exists').executable('lua-language-server'),
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
        enabled = require('user_api.check.exists').executable('clangd'),
    },
    {
        'NeoSahadeo/lsp-toggle.nvim',
        dev = true,
        version = false,
        config = function()
            require('lsp-toggle').setup({
                cache = true,
                cache_type = 'file_type',
                exclude_lsp = { 'marksman', 'yamlls', 'taplo' },
            })
        end,
    },
    {
        'romus204/referencer.nvim',
        version = false,
        config = function()
            require('referencer').setup()
        end,
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
