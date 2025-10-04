---@diagnostic disable:missing-fields
---@module 'lazy'

---@type LazySpec
return {
    'cameronr/noice.nvim',
    event = 'VeryLazy',
    version = false,
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
        'nvim-mini/mini.nvim',
    },
    enabled = not require('user_api.check').in_console(),
    config = function()
        require('noice').setup({
            throttle = 1000 / 30,
            cmdline = {
                enabled = true,
                view = 'cmdline_popup', ---@type 'cmdline_popup'|'cmdline'
                format = { ---@type NoiceFormatOptions
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    -- title: set to anything or empty string to hide
                    cmdline = { pattern = '^:', icon = '', lang = 'vim' },
                    search_down = {
                        kind = 'search',
                        pattern = '^/',
                        icon = ' ',
                        lang = 'regex',
                    },
                    search_up = {
                        kind = 'search',
                        pattern = '^%?',
                        icon = ' ',
                        lang = 'regex',
                    },
                    filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
                    lua = {
                        pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
                        icon = '',
                        lang = 'lua',
                    },
                    help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
                    input = { view = 'cmdline_input', icon = '󰥻 ' }, -- Used by input()
                },
            },
            messages = {
                enabled = true, -- enables the Noice messages UI
                view = 'notify', -- default view for messages
                view_error = 'notify', -- view for errors
                view_warn = 'notify', -- view for warnings
                view_history = 'messages', -- view for :messages
                view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
            },
            popupmenu = {
                enabled = true, -- enables the Noice popupmenu UI
                backend = 'nui', -- backend to use to show regular cmdline completions
                -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
                kind_icons = false,
                -- kind_icons = { ---@type NoicePopupmenuItemKind|false
                --     Class = ' ',
                --     Color = ' ',
                --     Constant = ' ',
                --     Constructor = ' ',
                --     Enum = '了 ',
                --     EnumMember = ' ',
                --     Field = ' ',
                --     File = ' ',
                --     Folder = ' ',
                --     Function = ' ',
                --     Interface = ' ',
                --     Keyword = ' ',
                --     Method = 'ƒ ',
                --     Module = ' ',
                --     Property = ' ',
                --     Snippet = ' ',
                --     Struct = ' ',
                --     Text = ' ',
                --     Unit = ' ',
                --     Value = ' ',
                --     Variable = ' ',
                -- }, -- set to `false` to disable icons
                opts = {},
            },
            redirect = { ---@type NoiceRouteConfig
                view = 'popup',
                filter = { event = 'msg_show' },
                opts = { ---@type NoiceViewOptions
                    enter = true,
                    format = 'details',
                },
            },
            commands = {
                history = {
                    -- options for the message history that you get with `:Noice`
                    view = 'split',
                    opts = { enter = true, format = 'details' },
                    filter = {
                        any = {
                            { event = 'notify' },
                            { error = true },
                            { warning = true },
                            { event = 'msg_show', kind = { '' } },
                            { event = 'lsp', kind = 'message' },
                        },
                    },
                },
                last = { -- :Noice last
                    view = 'popup',
                    opts = { enter = true, format = 'details' },
                    filter = {
                        any = {
                            { event = 'notify' },
                            { error = true },
                            { warning = true },
                            { event = 'msg_show', kind = { '' } },
                            { event = 'lsp', kind = 'message' },
                        },
                    },
                    filter_opts = { count = 1 },
                },
                errors = { -- `:Noice errors`
                    -- options for the message history that you get with `:Noice`
                    view = 'popup',
                    opts = { enter = true, format = 'details' },
                    filter = { error = true, has = true, warning = true }, ---@type NoiceFilter
                    filter_opts = { reverse = true },
                },
            },
            notify = {
                enabled = true,
                view = 'notify',
                opts = {},
            },
            lsp = {
                progress = {
                    enabled = false,
                    format = 'lsp_progress', ---@type NoiceFormat|string
                    format_done = 'lsp_progress_done', ---@type NoiceFormat|string
                    throttle = 1000 / 30, -- frequency to update lsp progress message
                    view = 'mini',
                    opts = { ---@type NoiceViewOptions
                        enter = false,
                        border = 'rounded',
                        focusable = false,
                    },
                },
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = false,
                },
                message = {
                    enabled = true,
                    view = 'notify',
                    opts = {},
                },
                hover = {
                    enabled = true,
                    silent = false,
                    opts = {}, ---@type NoiceViewOptions
                    view = nil,
                },
                signature = {
                    enabled = true,
                    view = nil,
                    opts = {}, ---@type NoiceViewOptions
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 500,
                    },
                },
                documentation = {
                    view = 'hover',
                    opts = { ---@type NoiceViewOptions
                        lang = 'markdown',
                        replace = true,
                        render = 'plain',
                        format = { '{message}' },
                        win_options = {
                            concealcursor = 'n',
                            conceallevel = 3,
                        },
                    },
                },
            },
            all = {
                view = 'split',
                opts = { enter = true, format = 'details' },
                filter = {},
            },
            markdown = {
                hover = {
                    ['|(%S-)|'] = vim.cmd.help,
                    ['%[.-%]%((%S-)%)'] = require('noice.util').open,
                },
                highlights = {
                    ['|%S-|'] = '@text.reference',
                    ['@%S+'] = '@parameter',
                    ['^%s*(Parameters:)'] = '@text.title',
                    ['^%s*(Return:)'] = '@text.title',
                    ['^%s*(See also:)'] = '@text.title',
                    ['{%S-}'] = '@parameter',
                },
            },
            health = { checker = true },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            views = { ---@type NoiceConfigViews
                split = { enter = true },
            },
            routes = { ---@type NoiceRouteConfig
                -- skip search_count messages instead of showing them as virtual text
                {
                    filter = { event = 'msg_show', kind = 'search_count' },
                    opts = { skip = true },
                },
                -- always route any messages with more than N lines to the split view
                {
                    view = 'split',
                    filter = { event = 'msg_show', min_height = 15 },
                },
            },
            status = {}, ---@type table<string, NoiceFilter>
            format = {}, ---@type NoiceFormatOptions
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
