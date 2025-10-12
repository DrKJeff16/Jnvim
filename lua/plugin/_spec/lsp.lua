---@module 'lazy'

---@type LazySpec[]
return {
    { 'neovim/nvim-lspconfig', version = false },
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    {
        'folke/trouble.nvim',
        dev = true,
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
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
