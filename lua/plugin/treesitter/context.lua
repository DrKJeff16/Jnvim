---@module 'user_api.types.user.highlight'
---@module 'user_api.types.user.maps'

local User = require('user_api')
local Keymaps = require('config.keymaps')
local Check = User.check

local exists = Check.exists.module
local hi = User.highlight.hl_from_dict
local desc = User.maps.kmap.desc

if not exists('treesitter-context') then
    return
end

User:register_plugin('plugin.treesitter.context')

local Context = require('treesitter-context')

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

hi(hls)

---@type AllMaps
local Keys = {
    ['<leader>C'] = { group = '+Context' },

    ['<leader>Cn'] = {
        function() pcall(Context.goto_context, vim.v.count1) end,
        desc('Previous Context'),
    },
}

Keymaps:setup({ n = Keys })

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
