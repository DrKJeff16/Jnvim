---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('noice') then
    return
end

local Noice = require('noice')

Noice.setup({
    cmdline = {
        enabled = true,
        ---@type 'cmdline_popup'|'cmdline'
        view = 'cmdline_popup',
        ---@type NoiceFormatOptions
        format = {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
            input = { view = 'cmdline_input', icon = '󰥻 ' }, -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
        },
    },
    messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        view = 'mini', -- default view for messages
        view_error = 'notify', -- view for errors
        view_warn = 'notify', -- view for warnings
        view_history = 'messages', -- view for :messages
        view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
    },
    popupmenu = {
        enabled = true, -- enables the Noice popupmenu UI
        ---@type 'nui'|'cmp'
        backend = exists('cmp') and 'cmp' or 'nui', -- backend to use to show regular cmdline completions
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        ---@type NoicePopupmenuItemKind|false
        kind_icons = {
            Class = ' ',
            Color = ' ',
            Constant = ' ',
            Constructor = ' ',
            Enum = '了 ',
            EnumMember = ' ',
            Field = ' ',
            File = ' ',
            Folder = ' ',
            Function = ' ',
            Interface = ' ',
            Keyword = ' ',
            Method = 'ƒ ',
            Module = ' ',
            Property = ' ',
            Snippet = ' ',
            Struct = ' ',
            Text = ' ',
            Unit = ' ',
            Value = ' ',
            Variable = ' ',
        }, -- set to `false` to disable icons
        opts = {
            win_options = {
                concealcursor = '',
                conceallevel = 3,
                winhighlight = {
                    Normal = 'NormalFloat',
                    FloatBorder = 'FloatBorder',
                },
            },
        },
    },
    -- default options for require('noice').redirect
    -- see the section on Command Redirection
    ---@type NoiceRouteConfig
    redirect = {
        view = 'popup',
        filter = { event = 'msg_show' },
        ---@type NoiceViewOptions
        opts = {
            enter = true,
            format = 'details',
            win_options = {
                concealcursor = '',
                conceallevel = 3,
                winhighlight = {
                    Normal = 'NormalFloat',
                    FloatBorder = 'FloatBorder',
                },
            },
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
        -- :Noice last
        last = {
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
        -- `:Noice errors`
        errors = {
            -- options for the message history that you get with `:Noice`
            view = 'notify',
            opts = { enter = false, format = 'details' },
            ---@type NoiceFilter
            filter = { error = true, has = true, warning = true },
            filter_opts = { reverse = true },
        },
    },
    notify = {
        enabled = exists('notify'),
        view = 'notify',
        opts = {
            win_options = {
                concealcursor = '',
                conceallevel = 3,
                winhighlight = {
                    Normal = 'NormalFloat',
                    FloatBorder = 'FloatBorder',
                },
            },
        },
    },
    lsp = {
        progress = {
            enabled = false,
            -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
            -- See the section on formatting for more details on how to customize.
            --- @type NoiceFormat|string
            format = 'lsp_progress',
            --- @type NoiceFormat|string
            format_done = 'lsp_progress_done',
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = 'mini',
            ---@type NoiceViewOptions
            opts = {
                enter = false,
                border = 'rounded',
                focusable = false,
                win_options = {
                    concealcursor = '',
                    conceallevel = 3,
                    winhighlight = {
                        Normal = 'NormalFloat',
                        FloatBorder = 'FloatBorder',
                    },
                },
            },
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
        },
        message = {
            enabled = true,
            view = 'notify',
            opts = {
                win_options = {
                    concealcursor = '',
                    conceallevel = 3,
                    winhighlight = {
                        Normal = 'NormalFloat',
                        FloatBorder = 'FloatBorder',
                    },
                },
            },
        },
        hover = {
            enabled = true,
            silent = true,
            view = nil,
            ---@type NoiceViewOptions
            opts = {
                border = 'solid',
                merge = true,
                zindex = 100,
                timeout = 3500,
                scrollbar = true,
                enter = false,
                win_options = {
                    concealcursor = '',
                    conceallevel = 3,
                    winhighlight = {
                        Normal = 'NormalFloat',
                        FloatBorder = 'FloatBorder',
                    },
                },
            },
        },
        signature = {
            enabled = true,
            auto_open = {
                enabled = true,
                trigger = true,
                luasnip = true,
                throttle = 500,
            },
            view = nil,
            ---@type NoiceViewOptions
            opts = {
                win_options = {
                    concealcursor = '',
                    conceallevel = 3,
                    winhighlight = {
                        Normal = 'NormalFloat',
                        FloatBorder = 'FloatBorder',
                    },
                },
            },
        },
        documentation = {
            view = 'hover',
            ---@type NoiceViewOptions
            opts = {
                lang = 'markdown',
                replace = true,
                render = 'plain',
                format = { '{message}' },
                win_options = {
                    concealcursor = '',
                    conceallevel = 3,
                    winhighlight = {
                        Normal = 'NormalFloat',
                        FloatBorder = 'FloatBorder',
                    },
                },
            },
        },
    },
    all = {
        view = 'popup',
        opts = { enter = false, format = 'details' },
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
        inc_rename = exists('inc_rename'), -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    throttle = 1000 / 30,
    ---@type NoiceConfigViews
    views = {
        split = {
            enabled = true,
        },
    }, ---@see section on views
    ---@type NoiceRouteConfig
    routes = {
        {
            filter = { event = 'msg_show', kind = 'search_count' },
            opts = { skip = true },
        },
        {
            view = 'split',
            filter = { event = 'msg_show', min_height = 14 },
        },
    }, ---@see section on routes
    ---@type table<string, NoiceFilter>
    status = {}, ---@see section on statusline components
    ---@type NoiceFormatOptions
    format = {}, ---@see section on formatting
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
