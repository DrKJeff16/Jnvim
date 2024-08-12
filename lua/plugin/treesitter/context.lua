---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
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
local hi = User.highlight.hl_from_dict
local desc = kmap.desc
local map_dict = Maps.map_dict

if not exists('treesitter-context') then
    return
end

local Context = require('treesitter-context')
local Config = require('treesitter-context.config')

Context.setup({
    enable = true,
    ---@type 'topline'|'cursor'
    mode = 'cursor',
    ---@type 'inner'|'outer'
    trim_scope = 'outer',
    line_numbers = true,
    min_window_height = 0,
    zindex = 20,
    multiline_threshold = 20,
    max_lines = vim.opt.scrolloff:get() ~= 0 and vim.opt.scrolloff:get() + 1 or 3,
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline
    separator = nil,
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

---@type HlDict
local hls = {
    ['TreesitterContextBottom'] = { link = 'FloatBorder' },
    ['TreesitterContextLineNumberBottom'] = { underline = true, sp = 'Grey' },
    ['TreesitterContext'] = { link = 'PmenuSel' },
}

---@type KeyMapDict
local Keys = {
    ['<leader>Cn'] = {
        function() pcall(Context.goto_context, vim.v.count1) end,
        desc('Previous Context'),
    },
}
---@type RegKeysNamed
local Names = {
    ['<leader>C'] = { group = '+Context' },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n', 0)
end
map_dict(Keys, 'wk.register', false, 'n', 0)
hi(hls)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
