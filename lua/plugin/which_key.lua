---@module 'lazy'

---@type LazySpec
return {
    'folke/which-key.nvim',
    lazy = false,
    priority = 1000,
    version = false,
    enabled = require('user_api.check.exists').vim_has('nvim-0.10'),
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        ---@type integer|fun(ctx: { keys: string, mode: string, plugin?: string }): integer
        delay = function(ctx)
            return ctx.plugin and 0 or 50
        end,
        preset = 'helix', ---@type false|'classic'|'modern'|'helix'
        notify = true,
        keys = { scroll_down = '<C-d>', scroll_up = '<C-u>' },
        show_help = true,
        show_keys = true,
        debug = false,
        disable = { ft = {}, bt = {} },
        -- expand = 0,
        spec = { ---@type wk.Spec
            {
                '<leader>?',
                function()
                    require('which-key').show({ global = false })
                end,
                desc = 'Buffer Local Keymaps (which_key)',
            },
        },
        defer = function(ctx) ---@param ctx { mode: string, operator: string }
            local deferred_ops = {
                'o',
                'v',
                'V',
                '<C-v>',
                '<C-V>',
            }
            return not vim.list_contains(deferred_ops, ctx.operator)
        end,
        filter = function(mapping) ---@param mapping wk.Mapping
            return (mapping.desc and mapping.desc ~= '')
        end,
        plugins = {
            marks = true,
            registers = true,
            spelling = { enabled = false },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        ---@diagnostic disable-next-line:missing-fields
        win = { ---@type wk.Win
            no_overlap = true,
            border = 'single',
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
            title = true,
            title_pos = 'center',
            zindex = 1000,
            bo = { modifiable = false },
            wo = { winblend = require('user_api.check').in_console() and 0 or 45 },
        },
        layout = {
            width = { min = 20, max = math.floor(vim.o.columns * 3 / 4) },
            spacing = 1,
            align = 'center',
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
        sort = { 'alphanum', 'case', 'mod', 'group', 'order', 'local' },
        expand = function(node)
            return not node.desc
        end,
        replace = { ---@type table<string, ({ [1]: string, [2]: string }|fun(str: string): string)[]>
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
            breadcrumb = '»',
            separator = '➜',
            group = '+',
            ellipsis = '…',
            mappings = true,
            colors = true,
            rules = { ---@type wk.IconRule[]|false
                { pattern = 'toggleterm', icon = ' ', color = 'cyan' },
                { pattern = 'lsp', icon = ' ', color = 'purple' },
            },
            keys = {
                Up = '',
                Down = '',
                Left = '',
                Right = '',
                -- C = '󰘴 ',
                C = 'CTRL-',
                -- M = '󰘵 ',
                M = 'META-',
                -- S = '󰘶 ',
                S = 'SHIFT-',
                -- CR = '󰌑 ',
                CR = '<CR>',
                -- Esc = '󱊷 ',
                Esc = '<ESC>',
                ScrollWheelDown = '󱕐 ',
                ScrollWheelUp = '󱕑 ',
                NL = '󰌑 ',
                BS = '⌫ ',
                Space = '󱁐 ',
                Tab = '󰌒 ',
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
        triggers = { ---@type wk.Spec
            { '<auto>', mode = 'nxso' },
            { '<leader>', mode = { 'n', 'v' } },
            { 'a', mode = { 'n', 'v' } },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
