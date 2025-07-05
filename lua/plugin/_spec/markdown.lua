---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local source = CfgUtil.source
local executable = Check.exists.executable
local is_root = Check.is_root

_G.in_console = in_console or Check.in_console

---@type LazySpecs
local MD = {
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        version = false,
        build = executable('yarn') and 'cd app && yarn install'
            or function() vim.fn['mkdp#util#install']() end,
        init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
        config = source('plugin.markdown.md_preview'),
        enabled = not (in_console() or is_root()),
    },
    {
        'tadmccorkle/markdown.nvim',
        ft = 'markdown',
        version = false,
        config = source('plugin.markdown'),
    },
}

return MD

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
