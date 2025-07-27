---@module 'config.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local source = CfgUtil.source
local executable = Check.exists.executable
local is_root = Check.is_root

_G.in_console = in_console or Check.in_console

---@type LazySpecs
local MD = {
    {
        'tadmccorkle/markdown.nvim',
        ft = 'markdown',
        version = false,
        config = source('plugin.markdown'),
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = source('plugin.markdown.render'),
    },
}

return MD

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
