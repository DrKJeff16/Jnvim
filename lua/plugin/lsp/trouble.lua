---@diagnostic disable:missing-fields

local Trouble = {} ---@class Lsp.SubMods.Trouble

Trouble.Opts = { ---@type trouble.Config
    auto_close = true,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    auto_jump = true,
    focus = true,
    restore = true,
    follow = true,
    indent_guides = true,
    max_items = 200,
    multiline = true,
    pinned = false,
    warn_no_results = false,
    open_no_results = false,
    win = {}, ---@type trouble.Window.opts
    preview = { type = 'main', scratch = true }, ---@type trouble.Window.opts
    throttle = { ---@type table<string, integer|{ ms: number, debounce?: boolean }>
        refresh = 20,
        update = 10,
        render = 10,
        follow = 100,
        preview = { ms = 100, debounce = true },
    },
    keys = { ---@type table<string, string|trouble.Action>
        -- ['<2-leftmouse>'] = 'jump',
        P = 'toggle_preview',
        R = 'toggle_refresh',
        ['<C-s>'] = 'jump_split',
        ['<C-v>'] = 'jump_vsplit',
        ['<CR>'] = 'jump',
        ['<Esc>'] = 'cancel',
        ['?'] = 'help',
        ['[['] = 'prev',
        [']]'] = 'next',
        ['{'] = 'prev',
        ['}'] = 'next',
        i = 'inspect',
        j = 'next',
        k = 'prev',
        o = 'jump_close',
        p = 'preview',
        q = 'close',
        r = 'refresh',
        zA = 'fold_toggle_recursive',
        zC = 'fold_close_recursive',
        zM = 'fold_close_all',
        zN = 'fold_enable',
        zO = 'fold_open_recursive',
        zR = 'fold_open_all',
        zX = 'fold_update_all',
        za = 'fold_toggle',
        zc = 'fold_close',
        zi = 'fold_toggle_enable',
        zm = 'fold_more',
        zn = 'fold_disable',
        zo = 'fold_open',
        zr = 'fold_reduce',
        zx = 'fold_update',
        gb = { -- example of a custom action that toggles the active view filter
            action = function(view)
                view:filter({ buf = vim.api.nvim_get_current_buf() }, { toggle = true })
            end,
            desc = 'Toggle Current Buffer Filter',
        },
        s = { -- example of a custom action that toggles the severity
            action = function(view)
                local f = view:get_filter('severity')
                local severity = (f and (f.filter.severity + 1) or 1) % 5
                view:filter({ severity = severity }, {
                    id = 'severity',
                    template = '{hl:Title}Filter:{hl} {severity}',
                    del = severity == 0,
                })
            end,
            desc = 'Toggle Severity Filter',
        },
    },
    modes = { ---@type table<string, trouble.Mode>
        -- sources define their own modes, which you can use directly,
        -- or override like in the example below
        lsp_references = {
            -- some modes are configurable, see the source code for more details
            params = {
                include_declaration = true,
            },
        },
        -- The LSP base mode for:
        -- * lsp_definitions, lsp_references, lsp_implementations
        -- * lsp_type_definitions, lsp_declarations, lsp_command
        lsp_base = {
            params = {
                -- don't include the current location in the results
                include_current = true,
            },
        },
        diagnostics = {
            mode = 'diagnostics',
            auto_preview = true,
            auto_refresh = true,
            auto_jump = false,
            follow = true,
            indent_guides = true,
            focus = false,
            auto_open = false,
            auto_close = true,
        },
        test = {
            mode = 'diagnostics',
            preview = {
                type = 'split',
                relative = 'win',
                position = 'right',
                size = 0.3,
            },
        },
        diagnostics_buffer = {
            mode = 'diagnostics',
            filter = { buf = 0 },
        },
        symbols = {
            desc = 'document symbols',
            mode = 'lsp_document_symbols',
            focus = false,
            win = { position = 'right' },
            filter = {
                -- remove Package since luals uses it for control flow structures
                ['not'] = { ft = 'lua', kind = 'Package' },
                any = {
                    -- all symbol kinds for help / markdown files
                    ft = { 'help', 'markdown' },
                    kind = {
                        'Class',
                        'Constructor',
                        'Enum',
                        'Field',
                        'Function',
                        'Interface',
                        'Method',
                        'Module',
                        'Namespace',
                        'Package',
                        'Property',
                        'Struct',
                        'Trait',
                    },
                },
            },
        },
    },
    icons = {
        indent = { ---@type trouble.Indent.symbols
            top = '│ ',
            middle = '├╴',
            last = '╰╴',
            fold_open = ' ',
            fold_closed = ' ',
            ws = '  ',
        },
        folder_closed = ' ',
        folder_open = ' ',
        kinds = {
            Array = ' ',
            Boolean = '󰨙 ',
            Class = ' ',
            Constant = '󰏿 ',
            Constructor = ' ',
            Enum = ' ',
            EnumMember = ' ',
            Event = ' ',
            Field = ' ',
            File = ' ',
            Function = '󰊕 ',
            Interface = ' ',
            Key = ' ',
            Method = '󰊕 ',
            Module = ' ',
            Namespace = '󰦮 ',
            Null = ' ',
            Number = '󰎠 ',
            Object = ' ',
            Operator = ' ',
            Package = ' ',
            Property = ' ',
            String = ' ',
            Struct = '󰆼 ',
            TypeParameter = ' ',
            Variable = '󰀫 ',
        },
    },
}

local desc = require('user_api.maps').desc
Trouble.Keys = { ---@type AllMaps
    ['<leader>lx'] = { group = '+Trouble' },
    ['<leader>lxx'] = {
        function()
            vim.cmd.Trouble(
                'diagnostics toggle filter.buf=' .. tostring(vim.api.nvim_get_current_buf())
            )
        end,
        desc('Toggle Diagnostics'),
    },
    ['<leader>lxs'] = {
        function()
            vim.cmd.Trouble('symbols toggle focus=false')
        end,
        desc('Toggle Symbols'),
    },
    ['<leader>lxl'] = {
        function()
            vim.cmd.Trouble('lsp toggle focus=false')
        end,
        desc('Toggle LSP'),
    },
    ['<leader>lxL'] = {
        function()
            vim.cmd.Trouble('loclist toggle')
        end,
        desc('Toggle Loclist'),
    },
    ['<leader>lxr'] = {
        function()
            vim.cmd.Trouble('lsp_references')
        end,
        desc('Toggle LSP References'),
    },
}

---@return table|Lsp.SubMods.Trouble|fun(override: trouble.Config?)
function Trouble.new()
    return setmetatable({}, {
        __index = Trouble,

        ---@param self Lsp.SubMods.Trouble
        ---@param override? trouble.Config
        __call = function(self, override)
            self.Opts = vim.tbl_deep_extend('force', self.Opts, override or {})
            require('trouble').setup(self.Opts)
            require('user_api.config').keymaps({ n = self.Keys })
        end,
    })
end

return Trouble.new()
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
