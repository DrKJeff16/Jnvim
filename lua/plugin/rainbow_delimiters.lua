---@module 'lazy'

---@type LazySpec
return {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    version = false,
    config = function()
        require('rainbow-delimiters.setup').setup({
            strategy = {
                [''] = 'rainbow-delimiters.strategy.global',
                bash = 'rainbow-delimiters.strategy.local',
                c = 'rainbow-delimiters.strategy.global',
                commonlisp = 'rainbow-delimiters.strategy.local',
                cpp = 'rainbow-delimiters.strategy.global',
                lua = 'rainbow-delimiters.strategy.local',
                python = 'rainbow-delimiters.strategy.local',
                vim = 'rainbow-delimiters.strategy.local',
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks',
                python = 'rainbow-blocks',
            },
            priority = {
                [''] = 110,
                lua = 210,
            },
            highlight = {
                'RainbowRed',
                'RainbowYellow',
                'RainbowBlue',
                'RainbowOrange',
                'RainbowGreen',
                'RainbowViolet',
                'RainbowCyan',
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
