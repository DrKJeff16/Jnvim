local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('rainbow-delimiters') then
    User.deregister_plugin('plugin.rainbow_delimiters')
    return
end

local RD = require('rainbow-delimiters.setup')

RD.setup({
    strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
