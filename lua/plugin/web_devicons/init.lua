local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('nvim-web-devicons') then
    return
end

local WDI = require('nvim-web-devicons')

WDI.setup({
    override = {},

    color_icons = true,
    default_icons = true,
    strict = true,

    variant = 'dark',

    override_by_filename = {
        ['.gitignore'] = {
            icon = '',
            color = '#f1502f',
            name = 'Gitignore',
        },
    },

    override_by_extension = {},

    override_by_operating_system = {
        ['apple'] = {
            icon = '',
            color = '#A2AAAD',
            cterm_color = '248',
            name = 'Apple',
        },
    },
})

WDI.set_up_highlights()

User:register_plugin('plugin.web_devicons')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
