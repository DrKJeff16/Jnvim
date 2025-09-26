local User = require('user_api')
local Check = User.check

local Keymaps = require('user_api.config.keymaps')
local exists = Check.exists.module
local hi = User.highlight.hl_from_dict
local desc = User.maps.desc

if not exists('treesitter-context') then
    return
end

local Context = require('treesitter-context')

Context.setup({
    enable = true,
    multiwindow = true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = false,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    zindex = 20,
    separator = nil,

    ---@type nil|fun(buf: integer): boolean
    on_attach = nil,
})

hi({
    TreesitterContextBottom = { underline = true, sp = 'Grey' },
    TreesitterContextLineNumberBottom = { underline = true, sp = 'Grey' },
    TreesitterContextLineNumber = { link = 'LineNr' },
    TreesitterContextSeparator = { link = 'FloatBorder' },
    TreesitterContext = { link = 'NormalFloat' },
})

---@type AllMaps
local Keys = {
    ['<leader>C'] = { group = '+Context' },

    ['<leader>Cs'] = {
        function()
            local msg = Context.enabled() and 'Enabled' or 'Disabled'
            vim.notify(('TS Context ==> %s'):format(msg))
        end,
        desc('Status of TS Context'),
    },
    ['<leader>Cn'] = {
        function()
            Context.go_to_context(vim.v.count1)
        end,
        desc('Go To Current Context'),
    },
    ['<leader>Ct'] = {
        function()
            Context.toggle()
            local msg = Context.enabled() and 'Enabled' or 'Disabled'
            vim.notify(('%s TS Context'):format(msg))
        end,
        desc('Toggle Context'),
    },
}

Keymaps({ n = Keys })

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
