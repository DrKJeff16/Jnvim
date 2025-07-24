local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local hi = User.highlight.hl_from_dict
local desc = User.maps.kmap.desc

if not exists('treesitter-context') then
    return
end

local Context = require('treesitter-context')

Context.setup({
    enable = true,

    multiwindow = false,

    ---@type 'topline'|'cursor'
    mode = 'cursor',

    ---@type 'inner'|'outer'
    trim_scope = 'outer',
    line_numbers = true,
    min_window_height = 0,
    zindex = 20,
    multiline_threshold = 20,
    max_lines = 0,

    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline
    separator = nil,

    -- Return false to disable attaching
    ---@type nil|(fun(buf: integer): boolean)
    on_attach = nil,
})

---@type HlDict
local hls = {
    ['TreesitterContextBottom'] = { underline = true, sp = 'Grey' },
    ['TreesitterContextLineNumberBottom'] = { underline = true, sp = 'Grey' },
    ['TreesitterContextLineNumber'] = { link = 'LineNr' },
    ['TreesitterContextSeparator'] = { link = 'FloatBorder' },
    ['TreesitterContext'] = { link = 'NormalFloat' },
}

---@type AllMaps
local Keys = {
    ['<leader>C'] = { group = '+Context' },

    ['<leader>Cn'] = {
        function()
            require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc('Go To Current Context'),
    },

    ['<leader>Ct'] = { Context.toggle, desc('Toggle Context') },
}

Keymaps({ n = Keys })

vim.schedule(function()
    hi(hls)
end)

User.register_plugin('plugin.treesitter.context')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
