---@module 'lazy'

---@type LazySpec
return {
    'onsails/lspkind.nvim',
    version = false,
    opts = {
        -- defines how annotations are shown
        -- default: symbol
        -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
        mode = 'symbol_text',

        -- default symbol map
        -- can be either 'default' (requires nerd-fonts font) or
        -- 'codicons' for codicon preset (requires vscode-codicons font)
        --
        -- default: 'default'
        preset = 'default',

        -- override preset symbols
        --
        -- default: {}
        symbol_map = {},
    },
    config = function(_, opts)
        require('lspkind').init(opts)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
