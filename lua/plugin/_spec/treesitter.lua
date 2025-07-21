---@module 'config.lazy'

local CfgUtil = require('config.util')

local source = CfgUtil.source

---@type LazySpecs
local TS = {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-context',
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-refactor',
        },
        config = source('plugin.treesitter'),
    },
}

return TS

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
