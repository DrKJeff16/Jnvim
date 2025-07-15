---@diagnostic disable:missing-fields

---@module 'blink.cmp'
---@module 'plugin._types.blink_cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local executable = Check.exists.executable
local is_tbl = Check.value.is_tbl
local has_words_before = Util.has_words_before

local BUtil = require('plugin.blink_cmp.util')

---@type table<string, blink.cmp.DrawComponent>
local mini_kinds = {
    kind_icon = {
        ---@type blink.cmp.DrawItemContext
        text = function(ctx)
            local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
            return kind_icon
        end,

        -- (optional) use highlights from mini.icons
        ---@type blink.cmp.DrawItemContext
        highlight = function(ctx)
            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
            return hl
        end,
    },
    kind = {
        -- (optional) use highlights from mini.icons
        ---@type blink.cmp.DrawItemContext
        highlight = function(ctx)
            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
            return hl
        end,
    },
}

---@type table<string, blink.cmp.DrawComponent>
local devicon_kinds = {
    kind_icon = {
        ---@type blink.cmp.DrawItemContext
        text = function(ctx)
            local Devicons = require('nvim-web-devicons')
            local lspkind = require('lspkind')

            if vim.tbl_contains({ 'Path', 'LSP' }, ctx.source_name) then
                local dev_icon, _ = Devicons.get_icon(ctx.label)
                if dev_icon then
                    ctx.kind_icon = dev_icon
                end
            else
                ctx.kind_icon = lspkind.symbolic(ctx.kind, {
                    mode = 'symbol',
                })
            end

            return ctx.kind_icon .. ctx.icon_gap
        end,

        -- Optionally, use the highlight groups from nvim-web-devicons
        -- You can also add the same function for `kind.highlight` if you want to
        -- keep the highlight groups in sync with the icons.
        ---@type blink.cmp.DrawItemContext
        highlight = function(ctx)
            local Devicons = require('nvim-web-devicons')

            if vim.tbl_contains({ 'Path', 'LSP' }, ctx.source_name) then
                local dev_icon, dev_hl = Devicons.get_icon(ctx.label)
                if dev_icon then
                    ctx.kind_hl = dev_hl
                end
            end

            return ctx.kind_hl
        end,
    },

    kind = {
        -- Optionally, use the highlight groups from nvim-web-devicons
        -- You can also add the same function for `kind.highlight` if you want to
        -- keep the highlight groups in sync with the icons.
        ---@type blink.cmp.DrawItemContext
        highlight = function(ctx)
            local Devicons = require('nvim-web-devicons')

            if vim.tbl_contains({ 'Path', 'LSP' }, ctx.source_name) then
                local dev_icon, dev_hl = Devicons.get_icon(ctx.label)
                if dev_icon then
                    ctx.kind_hl = dev_hl
                end
            end

            return ctx.kind_hl
        end,
    },
}

---@param key string
---@return fun()
local function gen_termcode(key)
    return function()
        local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(termcode, 'i', false)
    end
end

---@type BlinkCmp.Cfg
local Cfg = {}

---@type BlinkCmp.Cfg.Config
Cfg.Config = {}

Cfg.Config.keymap = {
    preset = 'super-tab',

    ['<C-Space>'] = {
        function(cmp)
            if cmp.is_documentation_visible() then
                cmp.hide_documentation()
            else
                cmp.show_documentation()
            end

            return cmp.show({ providers = BUtil:gen_sources(true, true) })
        end,
        'fallback',
    },

    --- Also known as `<Esc>`
    ['<C-e>'] = {
        function(cmp)
            if cmp.is_documentation_visible() then
                cmp.hide_documentation()
            end
            if cmp.is_signature_visible() then
                cmp.hide_signature()
            end
            if cmp.snippet_active() or cmp.is_active() or cmp.is_menu_visible() then
                return cmp.cancel()
            end
        end,
        'fallback',
    },

    ['<CR>'] = { 'accept', 'fallback' },

    ['<Tab>'] = {
        function(cmp)
            if cmp.snippet_active({ direction = 1 }) then
                return cmp.snippet_forward()
            end
        end,

        function(cmp)
            local visible = cmp.is_menu_visible

            if not visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources(true, true) })
            end
        end,

        function(cmp)
            return cmp.select_next({ auto_insert = true, preselect = false })
        end,
        'fallback',
    },
    ['<S-Tab>'] = {
        function(cmp)
            if cmp.snippet_active({ direction = -1 }) then
                return cmp.snippet_backward()
            end
        end,

        function(cmp)
            local visible = cmp.is_menu_visible

            if not visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources(true, true) })
            end
        end,

        function(cmp)
            return cmp.select_prev({ auto_insert = true, preselect = false })
        end,

        'fallback',
    },

    ['<Up>'] = {
        function(cmp)
            if cmp.is_active() or cmp.is_visible() then
                return cmp.cancel({
                    callback = gen_termcode('<Up>'),
                })
            end
        end,
        'fallback',
    },
    ['<Down>'] = {
        function(cmp)
            if cmp.is_visible() or cmp.is_active() then
                return cmp.cancel({
                    callback = gen_termcode('<Down>'),
                })
            end
        end,
        'fallback',
    },

    ['<C-p>'] = { 'fallback' },
    ['<C-n>'] = { 'fallback' },

    ['<C-b>'] = {
        function(cmp)
            if cmp.is_documentation_visible() then
                return cmp.scroll_documentation_up(4)
            end
        end,
        'fallback',
    },
    ['<C-f>'] = {
        function(cmp)
            if cmp.is_documentation_visible() then
                return cmp.scroll_documentation_down(4)
            end
        end,
        'fallback',
    },
    ['<C-k>'] = {
        function(cmp)
            if not cmp.is_active() then
                return
            end

            if not cmp.is_signature_visible() then
                return cmp.show_signature()
            end

            return cmp.hide_signature()
        end,
        'fallback',
    },
}

Cfg.Config.appearance = {}
Cfg.Config.appearance.nerd_font_variant = 'mono'

Cfg.Config.completion = {
    trigger = {
        show_in_snippet = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { ' ', '\t' },
    },

    documentation = {
        auto_show = true,
        auto_show_delay_ms = 1000,
        update_delay_ms = 100,

        treesitter_highlighting = true,

        window = {
            border = 'rounded',
            winblend = 0,

            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',

            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = false,

            -- Which directions to show the documentation window,
            -- for each of the possible menu window directions,
            -- falling back to the next direction when there's not enough space
            direction_priority = {
                menu_north = { 'e', 'w', 'n', 's' },
                menu_south = { 'e', 'w', 's', 'n' },
            },
        },
    },

    keyword = { range = 'full' },

    accept = {
        auto_brackets = { enabled = false },
        create_undo_point = true,
        dot_repeat = true,
    },

    list = {
        selection = {
            -- preselect = function(ctx)
            --     ctx = is_tbl(ctx) and ctx or {}
            --
            --     return not require('blink.cmp').snippet_active({ direction = 1 })
            -- end,
            preselect = false,

            auto_insert = true,
        },

        cycle = {
            from_top = true,
            from_bottom = true,
        },
    },

    menu = {
        -- Don't automatically show the completion menu
        auto_show = true,

        border = 'single',

        -- nvim-cmp style menu
        draw = {
            padding = { 0, 1 },
            treesitter = { 'lsp' },

            components = exists('nvim-web-devicons') and devicon_kinds or mini_kinds,

            columns = {
                { 'label', 'label_description', gap = 1 },
                { 'kind_icon', 'kind' },
            },
        },
    },

    ghost_text = { enabled = false },
}

Cfg.Config.cmdline = {
    enabled = true,

    keymap = {
        preset = 'cmdline',

        ['<Right>'] = { 'fallback' },
        ['<Left>'] = { 'fallback' },
        ['<C-p>'] = { 'fallback' },
        ['<C-n>'] = { 'fallback' },
    },

    -- OR explicitly configure per cmd type
    -- This ends up being equivalent to above since the sources disable themselves automatically
    -- when not available. You may override their `enabled` functions via
    -- `sources.providers.cmdline.override.enabled = function() return your_logic end`

    sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == '/' or type == '?' then
            return { 'buffer' }
        end
        -- Commands
        if type == ':' or type == '@' then
            return { 'cmdline', 'buffer' }
        end

        return {}
    end,
}

Cfg.Config.sources = {
    default = function()
        return BUtil:gen_sources(true, true)
    end,

    per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
        org = { 'orgmode', 'buffer', 'path', 'snippets' },
    },

    providers = BUtil:gen_providers(),
}

Cfg.Config.fuzzy = {
    -- implementation = 'lua',
    implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust' or 'lua',

    sorts = {
        'exact',
        -- 'label',
        -- 'kind',
        'score',
        'sort_text',
    },
}

Cfg.Config.snippets = {
    preset = exists('luasnip') and 'luasnip' or 'default',

    -- Function to use when expanding LSP provided snippets
    expand = function(snippet)
        vim.snippet.expand(snippet)
    end,

    -- Function to use when checking if a snippet is active
    active = function(filter)
        return vim.snippet.active(filter)
    end,

    -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    jump = function(direction)
        vim.snippet.jump(direction) ---@diagnostic disable-line
    end,
}

Cfg.Config.signature = {
    enabled = true,

    window = {
        show_documentation = true,
        border = 'single',
        scrollbar = true,
        treesitter_highlighting = true,
        direction_priority = { 'n', 's' },
        -- direction_priority = { 's', 'n' },
    },
}

Cfg.Config.cmdline = {
    enabled = false,

    -- use 'inherit' to inherit mappings from top level `keymap` config
    keymap = { preset = 'cmdline' },

    sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == '/' or type == '?' then
            return { 'buffer' }
        end
        -- Commands
        if type == ':' or type == '@' then
            return { 'cmdline' }
        end
        return {}
    end,

    completion = {
        trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
        },

        list = {
            selection = {
                -- When `true`, will automatically select the first item in the completion list
                preselect = false,

                -- When `true`, inserts the completion item automatically when selecting it
                auto_insert = true,
            },
        },

        -- Whether to automatically show the window when new completion items are available
        menu = { auto_show = true },

        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = true },
    },
}

Cfg.Config.term = { enabled = false }

---@param O? table
---@return BlinkCmp.Cfg|table
function Cfg.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Cfg })
end

User:register_plugin('plugin.blink_cmp.config')

return Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
