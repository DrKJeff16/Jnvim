---@module 'config.lazy'

local CfgUtil = require('config.util')

---@type LazySpecs
local MD = {
    {
        'tadmccorkle/markdown.nvim',
        ft = 'markdown',
        version = false,
        config = CfgUtil.require('plugin.markdown'),
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = CfgUtil.require('plugin.markdown.render'),
    },
}

return MD

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
