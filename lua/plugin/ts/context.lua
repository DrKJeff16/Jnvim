local User = require('user_api')
local Check = User.check

local Keymaps = require('user_api.config.keymaps')
local exists = Check.exists.module
local hi = User.highlight.hl_from_dict
local desc = User.maps.desc

if not exists('treesitter-context') then
    User.deregister_plugin('plugin.ts.context')
    return
end

local Context = require('treesitter-context')

Context.setup({
    enable = true,
    multiwindow = true,
    mode = 'cursor',
    trim_scope = 'inner',
    line_numbers = true,
    min_window_height = 0,
    zindex = 50,
    multiline_threshold = 20,
    max_lines = 0,

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

    ['<leader>Cs'] = {
        function()
            local msg = Context.enabled() and 'Enabled' or 'Disabled'
            vim.notify('TS Context ==> ' .. msg)
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

            local msg = Context.enabled() and 'En' or 'Dis'
            vim.notify(msg .. 'abled TS Context')
        end,
        desc('Toggle Context'),
    },
}

Keymaps({ n = Keys })

hi(hls)

User.register_plugin('plugin.ts.context')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
