---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check

local in_console = Check.in_console
local exists = Check.exists.module

if not exists('which-key') then
    return
end

local WK = require('which-key')

WK.setup({
    ---@type false|'classic'|'modern'|'helix'
    preset = 'modern',

    -- Delay before showing the popup. Can be a number or a function that returns a number.
    ---@type number|fun(ctx: { keys: string, mode: string, plugin?: string }): number
    delay = function(ctx)
        return ctx.plugin and 0 or 100
    end,

    --- You can add any mappings here, or use `require('which-key').add()` later
    ---@type wk.Spec
    spec = {
        {
            '<leader>?',
            function()
                WK.show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which_key)',
        },
    },

    -- Start hidden and wait for a key to be pressed before showing the popup
    -- Only used by enabled xo mapping modes.
    ---@param ctx { mode: string, operator: string }
    defer = function(ctx)
        if vim.list_contains({ 'd', 'y' }, ctx.operator) then
            return true
        end

        local deferred_ops = {
            'o',
            'v',
            'V',
            '<C-v>',
            '<C-V>',
        }
        return not vim.tbl_contains(deferred_ops, ctx.operator)
    end,

    ---@param mapping wk.Mapping
    filter = function(mapping)
        -- example to exclude mappings without a description
        return mapping.desc and mapping.desc ~= ''
    end,

    -- show a warning when issues were detected with your mappings
    notify = true,

    -- Enable/disable WhichKey for certain mapping modes
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 10, -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },

    ---@type wk.Win
    win = {
        no_overlap = true,

        border = 'rounded',
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        title = true,
        title_pos = 'center',
        zindex = 1000,
        -- Additional vim.wo and vim.bo options
        bo = {
            modifiable = false,
        },
        wo = {
            winblend = in_console() and 0 or 35, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
    },

    layout = {
        width = { min = 20, max = math.floor(vim.opt_local.columns:get() * 3 / 4) }, -- min and max width of the columns
        spacing = 1, -- spacing between columns
        align = 'center', -- align columns left, center or right
    },

    keys = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },

    --- Mappings are sorted using configured sorters and natural sort of the keys
    --- Available sorters:
    --- * local: buffer-local mappings first
    --- * order: order of the items (Used by plugins like marks / registers)
    --- * group: groups last
    --- * alphanum: alpha-numerical first
    --- * mod: special modifier keys last
    --- * manual: the order the mappings were added
    --- * case: lower-case first
    ---@type (string|wk.Sorter)[]
    sort = { 'alphanum', 'case', 'group', 'local', 'mod' },

    -- expand = 0, -- expand groups when <= n mappings

    expand = function(node)
        return not node.desc -- expand all nodes without a description
    end,

    ---@type table<string, ({ [1]: string, [2]: string }|fun(str: string): string)[]>
    replace = {
        key = {
            function(key)
                return require('which-key.view').format(key)
            end,
            { '<Space>', 'SPC' },
        },
        desc = {
            { '<Plug>%((.*)%)', '%1' },
            { '^%+', '' },
            { '<[cC]md>', '' },
            { '<[cC][rR]>', '' },
            { '<[sS]ilent>', '' },
            { '^lua%s+', '' },
            { '^call%s+', '' },
            { '^:%s*', '' },
        },
    },

    icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
        ellipsis = '…',

        mappings = true,

        --- See `lua/which-key/icons.lua` for more details
        --- Set to `false` to disable keymap icons
        ---@type wk.IconRule[]|false
        rules = {
            { pattern = 'toggleterm', icon = ' ', color = 'cyan' },
            { pattern = 'lsp', icon = ' ', color = 'purple' },
        },

        -- use the highlights from mini.icons
        -- When `false`, it will use `WhichKeyIcon` instead
        colors = true,

        -- used by key format
        keys = {
            Up = '',
            Down = '',
            Left = '',
            Right = '',
            -- C = '󰘴 ',
            C = 'CTRL-',
            M = '󰘵 ',
            S = '󰘶 ',
            -- CR = '󰌑 ',
            CR = '<CR>',
            -- Esc = '󱊷 ',
            Esc = 'ESC ',
            ScrollWheelDown = '󱕐 ',
            ScrollWheelUp = '󱕑 ',
            -- NL = '󰌑 ',
            NL = '\\n ',
            BS = '⌫ ',
            -- Space = '󱁐 ',
            Space = 'SPC ',
            -- Tab = '󰌒 ',
            Tab = 'TAB ',
            F1 = '󱊫',
            F2 = '󱊬',
            F3 = '󱊭',
            F4 = '󱊮',
            F5 = '󱊯',
            F6 = '󱊰',
            F7 = '󱊱',
            F8 = '󱊲',
            F9 = '󱊳',
            F10 = '󱊴',
            F11 = '󱊵',
            F12 = '󱊶',
        },
    },

    show_help = true, -- show a help message in the command line for using WhichKey

    show_keys = true, -- show the currently pressed key and its label as a message in the command line

    -- Which-key automatically sets up triggers for your mappings.
    -- But you can disable this and setup the triggers yourself.
    -- Be aware, that triggers are not needed for visual and operator pending mode.
    ---@type wk.Spec
    triggers = {
        { '<auto>', mode = 'nxso' },
        { '<leader>', mode = { 'n', 'v' } },
        { 'a', mode = { 'n', 'v' } },
    },

    disable = {
        -- disable WhichKey for certain buf types and file types.
        ft = {},
        bt = {},

        -- -- disable a trigger for a certain context by returning true
        -- ---@type fun(ctx: { keys: string, mode: string, plugin?: string }):boolean?
        -- trigger = function(ctx) return false end,
    },

    debug = false,
})

User.register_plugin('plugin.which_key')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
