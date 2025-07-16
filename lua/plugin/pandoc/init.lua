local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('pandoc') then
    return
end

local Pandoc = require('pandoc')
local Render = require('pandoc.render')
local Utils = require('pandoc.utils')

Pandoc.setup({
    commands = {
        name = 'PandocBuild',
        enable = true,
        extended = true,
    },
    default = {
        output = '%s_output.pdf',
        bin = 'pandoc',
        args = { { '--standalone' } },
    },
    mappings = {
        n = {
            ['<leader>Pr'] = function()
                Render.init({
                    { '--toc' },
                    { '--output', vim.fn.expand('~/Documents') },
                })
            end,
        },
    },
})

vim.api.nvim_create_user_command('PandocBuild', function()
    Render.init({
        { '--toc' },
        { '--output', vim.fn.expand('~/Documents/output.pdf') },
    })
end, {
    nargs = '*',
    complete = Utils.complete,
})

User:register_plugin('plugin.pandoc')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
