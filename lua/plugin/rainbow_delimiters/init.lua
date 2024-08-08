local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local hl_from_dict = User.highlight.hl_from_dict

if not exists('rainbow-delimiters') then
    return
end

local RD = require('rainbow-delimiters')

---@type rainbow_delimiters.config
require('rainbow-delimiters.setup').setup({
    strategy = {
        [''] = RD.strategy['global'],
        commonlisp = RD.strategy['local'],
        html = RD.strategy['local'],
        vim = RD.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        html = 'rainbow-blocks',
        latex = 'rainbow-blocks',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
    blacklist = {},
})

---@type HlDict
local HL = {
    ['RainbowDelimiterRed'] = { link = 'WarningMsg' },
}

hl_from_dict(HL)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
