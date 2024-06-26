---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Maps = User.maps
local WK = Maps.wk

local exists = Check.exists.module
local desc = Maps.kmap.desc
local map_dict = Maps.map_dict

if not exists('nvim-highlight-colors') then
    return
end

local HiColors = require('nvim-highlight-colors')

HiColors.setup({
    ---@type 'background'|'foreground'|'virtual'
    render = 'background',

    ---Set virtual symbol (requires render to be set to 'virtual')
    virtual_symbol = '■',

    ---Set virtual symbol suffix (defaults to '')
    virtual_symbol_prefix = '',

    ---Set virtual symbol suffix (defaults to ' ')
    virtual_symbol_suffix = ' ',

    ---Set virtual symbol position()
    ---@usage 'inline'|'eol'|'eow'
    ---inline mimics VS Code style
    ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
    ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
    ---@type 'inline'|'eol'|'eow'
    virtual_symbol_position = 'inline',

    ---Highlight hex colors, e.g. '#FFFFFF'
    enable_hex = true,

    ---Highlight short hex colors e.g. '#fff'
    enable_short_hex = true,

    ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
    enable_rgb = true,

    ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
    enable_hsl = true,

    ---Highlight CSS variables, e.g. 'var(--testing-color)'
    enable_var_usage = true,

    ---Highlight named colors, e.g. 'green'
    enable_named_colors = true,

    ---Highlight tailwind colors, e.g. 'bg-blue-500'
    enable_tailwind = true,

    ---Set custom colors
    ---Label must be properly escaped with '%' to adhere to `string.gmatch`
    --- :help string.gmatch
    custom_colors = {
        { label = '%-%-theme%-primary%-color', color = '#0f1219' },
        { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
    },

    -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
    exclude_filetypes = {},
    exclude_buftypes = {
        'text',
        'gitcommit',
        'gitignore',
    },
})

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<leader>uCt'] = { HiColors.toggle, desc('Toggle Color Highlighting') },
        ['<leader>uC+'] = { HiColors.turnOn, desc('Turn Color Highlighting On') },
        ['<leader>uC-'] = { HiColors.turnOff, desc('Turn Color Highlighting Off') },
    },
    v = {
        ['<leader>uCt'] = { HiColors.toggle, desc('Toggle Color Highlighting') },
        ['<leader>uC+'] = { HiColors.turnOn, desc('Turn Color Highlighting On') },
        ['<leader>uC-'] = { HiColors.turnOff, desc('Turn Color Highlighting Off') },
    },
}
---@type table <MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>u'] = { name = '+UI' },
        ['<leader>uC'] = { name = '+Color Highlighting' },
    },
    v = {
        ['<leader>u'] = { name = '+UI' },
        ['<leader>uC'] = { name = '+Color Highlighting' },
    },
}

if WK.available() then
    map_dict(Names, 'wk.register', true)
end
map_dict(Keys, 'wk.register', true)
