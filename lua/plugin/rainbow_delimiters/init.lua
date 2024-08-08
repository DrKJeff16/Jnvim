---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('rainbow-delimiters') then
    return
end

local RD = require('rainbow-delimiters')

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = RD.strategy['global'],
        vim = RD.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
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
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
