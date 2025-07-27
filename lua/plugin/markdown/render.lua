local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('render-markdown') then
    return
end

local Render = require('render-markdown')

Render.setup({
    enabled = true,

    on = {
        attach = function() end,
        initial = function() end,
        render = function() end,
        clear = function() end,
    },

    debounce = 100,
    file_types = { 'markdown', 'quarto' },
    render_modes = { 'n', 'c', 't' },

    heading = {
        enabled = true,
        sign = false,
        render_modes = false,
        atx = true,
        setext = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        position = 'overlay',
        signs = { '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '▄',
        below = '▀',
        backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
        },
        foregrounds = {
            'RenderMarkdownH1',
            'RenderMarkdownH2',
            'RenderMarkdownH3',
            'RenderMarkdownH4',
            'RenderMarkdownH5',
            'RenderMarkdownH6',
        },
        custom = {},
    },

    sign = {
        enabled = false,
        highlight = 'RenderMarkdownSign',
    },

    code = {
        enabled = true,
        render_modes = false,
        sign = false,
        conceal_delimiters = true,
        language = true,
        position = 'left',
        language_icon = true,
        language_name = true,
        language_info = true,
        language_pad = 0,
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,

        ---@type 'hide'|'thick'
        border = 'thick',

        language_border = ' ',
        language_left = '',
        language_right = '',
        above = '▄',
        below = '▀',
        inline = true,
        inline_left = '',
        inline_right = '',
        inline_pad = 0,
        highlight = 'RenderMarkdownCode',
        highlight_info = 'RenderMarkdownCodeInfo',
        highlight_language = nil,
        highlight_border = 'RenderMarkdownCodeBorder',
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',

        ---@type 'full'|'normal'|'language'
        style = 'full',
    },

    link = {
        enabled = true,
        render_modes = false,
        footnote = {
            enabled = true,
            superscript = true,
            prefix = '',
            suffix = '',
        },

        image = '󰥶 ',
        email = '󰀓 ',

        hyperlink = '󰌷 ',
        -- hyperlink = '󰌹 ',

        highlight = 'RenderMarkdownLink',
        wiki = {
            icon = '󱗖 ',
            body = function()
                return nil
            end,
            highlight = 'RenderMarkdownWikiLink',
        },
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            discord = { pattern = 'discord%.com', icon = '󰙯 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            google = { pattern = 'google%.com', icon = '󰊭 ' },
            neovim = { pattern = 'neovim%.io', icon = ' ' },
            reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
        },
    },

    dash = {
        enabled = true,
        render_modes = false,
        icon = '─',
        width = 'full',
        left_margin = 0,
        highlight = 'RenderMarkdownDash',
    },

    bullet = {
        enabled = true,
        render_modes = false,
        icons = { '●', '○', '◆', '◇' },

        ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return ('%d.'):format(index > 1 and index or ctx.index)
        end,

        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',

        scope_highlight = {},
    },

    paragraph = {
        enabled = true,
        render_modes = false,
        left_margin = 0,
        indent = 0,
        min_width = 0,
    },

    quote = {
        enabled = true,
        render_modes = false,
        icon = '▋',
        repeat_linebreak = false,
        highlight = {
            'RenderMarkdownQuote1',
            'RenderMarkdownQuote2',
            'RenderMarkdownQuote3',
            'RenderMarkdownQuote4',
            'RenderMarkdownQuote5',
            'RenderMarkdownQuote6',
        },
    },

    checkbox = {
        enabled = true,
        render_modes = false,
        bullet = false,
        right_pad = 1,

        unchecked = {
            icon = '✘ ',
            highlight = 'RenderMarkdownUnchecked',
            scope_highlight = nil,
        },

        checked = {
            icon = '✔ ',
            highlight = 'RenderMarkdownChecked',
            scope_highlight = nil,
        },

        custom = {
            todo = {
                raw = '[-]',
                rendered = '◯ ',
                highlight = 'RenderMarkdownTodo',
                scope_highlight = nil,
            },

            important = {
                raw = '[~]',
                rendered = '󰓎 ',
                highlight = 'DiagnosticWarn',
            },
        },
    },

    pipe_table = {
        enabled = true,
        render_modes = false,
        preset = 'double',

        -- cell = 'padded',
        cell = 'trimmed',

        padding = 1,
        min_width = 0,
        border = {
            '┌',
            '┬',
            '┐',
            '├',
            '┼',
            '┤',
            '└',
            '┴',
            '┘',
            '│',
            '─',
        },
        border_enabled = true,
        border_virtual = false,
        alignment_indicator = '━',
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
        style = 'full',
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

    markdown = {
        disable = true,
        directives = {
            { id = 17, name = 'conceal_lines' },
            { id = 18, name = 'conceal_lines' },
        },
    },

    completions = {
        lsp = { enabled = true },
        blink = { enabled = exists('blink.cmp') },
    },

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

    latex = {
        enabled = true,
        render_modes = false,
        converter = 'latex2text',
        highlight = 'RenderMarkdownMath',
        position = 'above',
        top_pad = 0,
        bottom_pad = 0,
    },

    callout = {
        note = {
            raw = '[!NOTE]',
            rendered = '󰋽 Note',
            highlight = 'RenderMarkdownInfo',
            category = 'github',
        },
        tip = {
            raw = '[!TIP]',
            rendered = '󰌶 Tip',
            highlight = 'RenderMarkdownSuccess',
            category = 'github',
        },
        important = {
            raw = '[!IMPORTANT]',
            rendered = '󰅾 Important',
            highlight = 'RenderMarkdownHint',
            category = 'github',
        },
        warning = {
            raw = '[!WARNING]',
            rendered = '󰀪 Warning',
            highlight = 'RenderMarkdownWarn',
            category = 'github',
        },
        caution = {
            raw = '[!CAUTION]',
            rendered = '󰳦 Caution',
            highlight = 'RenderMarkdownError',
            category = 'github',
        },
        abstract = {
            raw = '[!ABSTRACT]',
            rendered = '󰨸 Abstract',
            highlight = 'RenderMarkdownInfo',
            category = 'obsidian',
        },
        summary = {
            raw = '[!SUMMARY]',
            rendered = '󰨸 Summary',
            highlight = 'RenderMarkdownInfo',
            category = 'obsidian',
        },
        tldr = {
            raw = '[!TLDR]',
            rendered = '󰨸 Tldr',
            highlight = 'RenderMarkdownInfo',
            category = 'obsidian',
        },
        info = {
            raw = '[!INFO]',
            rendered = '󰋽 Info',
            highlight = 'RenderMarkdownInfo',
            category = 'obsidian',
        },
        todo = {
            raw = '[!TODO]',
            rendered = '󰗡 Todo',
            highlight = 'RenderMarkdownInfo',
            category = 'obsidian',
        },
        hint = {
            raw = '[!HINT]',
            rendered = '󰌶 Hint',
            highlight = 'RenderMarkdownSuccess',
            category = 'obsidian',
        },
        success = {
            raw = '[!SUCCESS]',
            rendered = '󰄬 Success',
            highlight = 'RenderMarkdownSuccess',
            category = 'obsidian',
        },
        check = {
            raw = '[!CHECK]',
            rendered = '󰄬 Check',
            highlight = 'RenderMarkdownSuccess',
            category = 'obsidian',
        },
        done = {
            raw = '[!DONE]',
            rendered = '󰄬 Done',
            highlight = 'RenderMarkdownSuccess',
            category = 'obsidian',
        },
        question = {
            raw = '[!QUESTION]',
            rendered = '󰘥 Question',
            highlight = 'RenderMarkdownWarn',
            category = 'obsidian',
        },
        help = {
            raw = '[!HELP]',
            rendered = '󰘥 Help',
            highlight = 'RenderMarkdownWarn',
            category = 'obsidian',
        },
        faq = {
            raw = '[!FAQ]',
            rendered = '󰘥 Faq',
            highlight = 'RenderMarkdownWarn',
            category = 'obsidian',
        },
        attention = {
            raw = '[!ATTENTION]',
            rendered = '󰀪 Attention',
            highlight = 'RenderMarkdownWarn',
            category = 'obsidian',
        },
        failure = {
            raw = '[!FAILURE]',
            rendered = '󰅖 Failure',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        fail = {
            raw = '[!FAIL]',
            rendered = '󰅖 Fail',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        missing = {
            raw = '[!MISSING]',
            rendered = '󰅖 Missing',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        danger = {
            raw = '[!DANGER]',
            rendered = '󱐌 Danger',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        error = {
            raw = '[!ERROR]',
            rendered = '󱐌 Error',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        bug = {
            raw = '[!BUG]',
            rendered = '󰨰 Bug',
            highlight = 'RenderMarkdownError',
            category = 'obsidian',
        },
        example = {
            raw = '[!EXAMPLE]',
            rendered = '󰉹 Example',
            highlight = 'RenderMarkdownHint',
            category = 'obsidian',
        },
        quote = {
            raw = '[!QUOTE]',
            rendered = '󱆨 Quote',
            highlight = 'RenderMarkdownQuote',
            category = 'obsidian',
        },
        cite = {
            raw = '[!CITE]',
            rendered = '󱆨 Cite',
            highlight = 'RenderMarkdownQuote',
            category = 'obsidian',
        },
    },
})

User.register_plugin('plugin.markdown.render')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
