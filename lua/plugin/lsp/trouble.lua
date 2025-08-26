---@diagnostic disable:missing-fields

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.desc

local copy = vim.deepcopy
local d_extend = vim.tbl_deep_extend

if not exists('trouble') then
    User.deregister_plugin('plugin.lsp.trouble')
    return
end

local trouble = require('trouble')

---@class Lsp.SubMods.Trouble
local Trouble = {}

---@type trouble.Config
Trouble.Opts = {
    auto_close = true, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = true, -- auto jump to the item when there's only one
    focus = true, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = true, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = false, -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results

    ---@type trouble.Window.opts
    win = {}, -- window options for the results window. Can be a split or a floating window

    -- Window options for the preview window. Can be a split, floating window,
    -- or `main` to show the preview in the main editor window
    ---@type trouble.Window.opts
    preview = {
        type = 'main',
        -- when a buffer is not yet loaded, the preview window will be created
        -- in a scratch buffer with only syntax highlighting enabled.
        -- Set to false, if you want the preview to always be a real loaded buffer
        scratch = false,
    },
    --- Throttle/Debounce settings. Should usually not be changed
    ---@type table<string, number|{ ms: number, debounce?: boolean }>
    throttle = {
        refresh = 20, -- fetches new data when needed
        update = 10, -- updates the window
        render = 10, -- renders the window
        follow = 100, -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
    },
    -- Key mappings can be set to the name of a builtin action,
    -- or you can define your own custom action
    ---@type table<string, string|trouble.Action>
    keys = {
        ['?'] = 'help',
        r = 'refresh',
        R = 'toggle_refresh',
        q = 'close',
        o = 'jump_close',
        ['<Esc>'] = 'cancel',
        ['<CR>'] = 'jump',
        ['<2-leftmouse>'] = 'jump',
        ['<C-s>'] = 'jump_split',
        ['<C-v>'] = 'jump_vsplit',
        -- go down to next item (accepts count)
        j = 'next',
        ['}'] = 'next',
        [']]'] = 'next',
        -- go up to prev item (accepts count)
        k = 'prev',
        ['{'] = 'prev',
        ['[['] = 'prev',
        i = 'inspect',
        p = 'preview',
        P = 'toggle_preview',
        zo = 'fold_open',
        zO = 'fold_open_recursive',
        zc = 'fold_close',
        zC = 'fold_close_recursive',
        za = 'fold_toggle',
        zA = 'fold_toggle_recursive',
        zm = 'fold_more',
        zM = 'fold_close_all',
        zr = 'fold_reduce',
        zR = 'fold_open_all',
        zx = 'fold_update',
        zX = 'fold_update_all',
        zn = 'fold_disable',
        zN = 'fold_enable',
        zi = 'fold_toggle_enable',
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
    ---@type table<string, trouble.Mode>
    modes = {
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
                include_current = false,
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
                    -- default set of symbol kinds
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
        ---@type trouble.Indent.symbols
        indent = {
            top = '│ ',
            middle = '├╴',
            -- last        = "└╴",
            -- last          = "-╴",
            last = '╰╴', -- rounded
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

---@type AllMaps
Trouble.Keys = {
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
            self.Opts = d_extend('force', copy(self.Opts), override or {})

            trouble.setup(self.Opts)

            Keymaps({ n = self.Keys })
        end,
    })
end

User.register_plugin('plugin.lsp.trouble')

return Trouble.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
