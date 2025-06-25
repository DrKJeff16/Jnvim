local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local hi = User.highlight.hl_from_dict
local desc = User.maps.kmap.desc

if not exists('treesitter-context') then
    return
end

local Context = require('treesitter-context')

---@type integer

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
    max_lines = 4,

    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline
    separator = nil,

    -- Return false to disable attaching
    ---@type nil|(fun(buf: integer): boolean)
    on_attach = nil,
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

User:register_plugin('plugin.treesitter.context')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
