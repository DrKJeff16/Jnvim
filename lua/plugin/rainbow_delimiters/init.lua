local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local hl_from_dict = User.highlight.hl_from_dict

if not exists('rainbow-delimiters') then
    return
end

local RD = require('rainbow-delimiters')

---@type rainbow_delimiters.config.queries
local QRY = {
    [''] = 'rainbow-delimiters',
    bash = 'rainbow-blocks',
    html = 'rainbow-blocks',
    markdown = 'rainbow-blocks',
    latex = 'rainbow-blocks',
    lua = 'rainbow-blocks',
    python = 'rainbow-blocks',
    sh = 'rainbow-blocks',
    yaml = 'rainbow-blocks',
}

---@param s 'local'|'global'|'noop'
---@return rainbow_delimiters.strategy
local function strat(s)
    local VALID_ARGS = {
        'global',
        'local',
        'noop',
    }

    s = (is_str(s) and vim.tbl_contains(VALID_ARGS, s)) and s or 'global'

    ---@diagnostic disable-next-line
    return RD.strategy[s]
end

require('rainbow-delimiters.setup').setup({
    strategy = {
        [''] = strat('global'),
        commonlisp = strat('local'),
        html = strat('local'),
        lua = strat('global'),
        markdown = strat('local'),
        vim = strat('local'),
    },

    query = QRY,

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

    blacklist = { 'c', 'cpp' },
})

---@type HlDict
local HL = {
    ['RainbowDelimiterRed'] = { link = 'WarningMsg' },
}

vim.schedule(function() hl_from_dict(HL) end)

User:register_plugin('plugin.rainbow_delimiters')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
