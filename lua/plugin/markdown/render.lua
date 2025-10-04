---@module 'lazy'

---@type LazySpec
return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-mini/mini.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    cond = not require('user_api.check').in_console(),
    ---@module 'render-markdown'

    ---@type render.md.UserConfig
    opts = {
        enabled = true,
        completions = { lsp = { enabled = true } },
        render_modes = { 'n', 'c', 't' },
        max_file_size = 10.0,
        debounce = 100,
        restart_highlighter = true,

        win_options = {
            conceallevel = { default = vim.o.conceallevel, rendered = 3 },
            concealcursor = { default = vim.o.concealcursor, rendered = '' },
        },

        overrides = {
            buflisted = {},
            buftype = {
                nofile = {
                    code = { left_pad = 0, right_pad = 0 },
                },
            },
            filetype = {},
        },

        markdown = {
            disable = true,
            directives = {
                { id = 17, name = 'conceal_lines' },
                { id = 18, name = 'conceal_lines' },
            },
        },

        injections = {
            gitcommit = {
                enabled = true,
                query = [[
                ((message) @injection.content
                    (#set! injection.combined)
                    (#set! injection.include-children)
                    (#set! injection.language "markdown"))
            ]],
            },
        },

        anti_conceal = {
            enabled = true,
            disabled_modes = false,
            above = 0,
            below = 0,
            -- Which elements to always show, ignoring anti conceal behavior. Values can either be
            -- booleans to fix the behavior or string lists representing modes where anti conceal
            -- behavior will be ignored. Valid values are:
            --   bullet
            --   callout
            --   check_icon, check_scope
            --   code_background, code_border, code_language
            --   dash
            --   head_background, head_border, head_icon
            --   indent
            --   link
            --   quote
            --   sign
            --   table_border
            --   virtual_lines
            ignore = {
                code_background = true,
                indent = true,
                sign = true,
                virtual_lines = true,
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
