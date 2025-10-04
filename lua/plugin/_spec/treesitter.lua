---@module 'lazy'

---@type LazySpec[]
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        version = false,
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-context',
                version = false,
                config = require('config.util').require('plugin.ts.context'),
            },
            {
                'windwp/nvim-ts-autotag',
                version = false,
                config = require('config.util').require('plugin.ts.autotag'),
            },
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                version = false,
                config = function()
                    require('ts_context_commentstring').setup({ enable_autocmd = false })
                end,
            },
        },
        config = require('config.util').require('plugin.ts'),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
