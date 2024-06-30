---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight
local map_t = User.types.user.maps
local Maps = User.maps
local kmap = Maps.kmap
local WK = Maps.wk
local Highlight = User.highlight

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local hi = Highlight.hl
local desc = kmap.desc
local map_dict = Maps.map_dict

if not exists('treesitter-context') then
    return
end

local Context = require('treesitter-context')
local Config = require('treesitter-context.config')

Context.setup({
    mode = 'topline',
    trim_scope = 'inner',
    line_numbers = false,
    min_window_height = 1,
    zindex = 30,
    enable = true,
    max_lines = vim.opt.scrolloff:get() ~= 0 and vim.opt.scrolloff:get() or 1,
})

---@type HlDict
local hls = {
    ['TreesitterContextLineNumberBottom'] = { underline = true, sp = 'Grey' },
}

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<leader>Cn'] = {
            function()
                Context.goto_context(vim.v.count1)
            end,
            desc('Previous Context'),
        },
    },
}
---@type table<MapModes, RegKeysNamed>
local Names = {
    n = { ['<leader>C'] = { name = '+Context' } },
}

if WK.available() then
    map_dict(Names, 'wk.register', true, nil, 0)
end
map_dict(Keys, 'wk.register', true, nil, 0)

for k, v in next, hls do
    hi(k, v)
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
