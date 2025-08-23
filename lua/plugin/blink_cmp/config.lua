---@module 'blink.cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local executable = Check.exists.executable
local is_tbl = Check.value.is_tbl
local has_words_before = Util.has_words_before

local BUtil = require('plugin.blink_cmp.util')

local gen_sources = BUtil.gen_sources
local gen_providers = BUtil.gen_providers

local validate = vim.validate

---@param key string
---@return fun()
local function gen_termcode_fun(key)
    validate('key', key, 'string', false)

    return function()
        local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(termcode, 'i', false)
    end
end

---@type blink.cmp.CompletionListSelectionConfig
local select_opts = {
    auto_insert = true,
    preselect = false,
}

---@class BlinkCmp.Cfg
local Cfg = {}

---@type blink.cmp.Config
Cfg.Config = {
    keymap = {
        preset = 'super-tab',

        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

        ---Also known as `<Esc>`
        ['<C-e>'] = { 'cancel', 'fallback' },

        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
            function(cmp)
                local visible = cmp.is_menu_visible
                local snip_active = cmp.snippet_active

                if snip_active({ direction = 1 }) then
                    return cmp.snippet_forward()
                end

                if not visible() and has_words_before() then
                    return cmp.show({ providers = gen_sources(true, true) })
                end

                return cmp.select_next(select_opts)
            end,
            'fallback',
        },
        ['<S-Tab>'] = {
            function(cmp)
                local visible = cmp.is_menu_visible
                local snip_active = cmp.snippet_active

                if snip_active({ direction = -1 }) then
                    return cmp.snippet_backward()
                end

                if not visible() and has_words_before() then
                    return cmp.show({ providers = gen_sources(true, true) })
                end

                return cmp.select_prev(select_opts)
            end,
            'fallback',
        },

        ['<Up>'] = {
            function(cmp)
                if cmp.is_menu_visible() then
                    return cmp.cancel({
                        callback = gen_termcode_fun('<Up>'),
                    })
                end
            end,
            'fallback',
        },
        ['<Down>'] = {
            function(cmp)
                if cmp.is_menu_visible() then
                    return cmp.cancel({
                        callback = gen_termcode_fun('<Down>'),
                    })
                end
            end,
            'fallback',
        },
        ['<Left>'] = { 'fallback' },
        ['<Right>'] = { 'fallback' },

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
                if cmp.is_signature_visible() then
                    return cmp.hide_signature()
                end

                return cmp.show_signature()
            end,
            'fallback',
        },
    },

    appearance = {
        nerd_font_variant = 'mono',

        highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),

        ---Sets the fallback highlight groups to nvim-cmp's highlight groups
        ---Useful for when your theme doesn't support blink.cmp
        ---Will be removed in a future release
        use_nvim_cmp_as_default = false,

        kind_icons = require('lspkind').symbol_map,
    },

    completion = {
        trigger = {
            show_in_snippet = true,
            show_on_trigger_character = true,
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            update_delay_ms = 100,

            treesitter_highlighting = true,

            window = {
                border = 'rounded',
                winblend = 0,

                winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',

                ---Note that the gutter will be disabled when `border ~= 'none'`
                scrollbar = false,

                ---Which directions to show the documentation window,
                ---for each of the possible menu window directions,
                ---falling back to the next direction when there's not enough space
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
                preselect = function(ctx)
                    ctx = is_tbl(ctx) and ctx or {}

                    return require('blink.cmp').snippet_active({ direction = 1 })
                end,

                auto_insert = true,
            },

            cycle = {
                from_top = true,
                from_bottom = true,
            },
        },

        menu = {
            ---Don't automatically show the completion menu
            auto_show = true,

            border = 'single',

            ---`nvim-cmp`-style menu
            draw = {
                padding = { 0, 1 },
                treesitter = { 'lsp' },

                columns = {
                    { 'label', 'label_description', gap = 1 },
                    { 'kind_icon', 'kind' },
                    { 'source_name', gap = 1 },
                },
            },
        },

        ghost_text = { enabled = false },
    },

    cmdline = {
        enabled = false,

        keymap = {
            preset = 'cmdline',

            ['<Right>'] = { 'fallback' },
            ['<Left>'] = { 'fallback' },
            ['<C-p>'] = { 'fallback' },
            ['<C-n>'] = { 'fallback' },
        },

        sources = function()
            local type = vim.fn.getcmdtype()
            local res = {}
            -- Search forward and backward
            if type == '/' or type == '?' then
                res = { 'buffer' }
            end

            -- Commands
            if type == ':' or type == '@' then
                res = { 'cmdline', 'buffer' }
            end

            return res
        end,
    },

    sources = {
        default = function()
            return gen_sources(true, true)
        end,

        ---Function to use when transforming the items before they're returned for all providers
        ---The default will lower the score for snippets to sort them lower in the list
        transform_items = function(_, items)
            return items
        end,

        providers = gen_providers(),
    },

    fuzzy = {
        implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust_with_warning' or 'lua',

        ---@param keyword string
        ---@return integer
        max_typos = function(keyword)
            return math.floor(#keyword / 3)
        end,

        sorts = {
            'exact',
            -- 'label',
            -- 'kind',
            'score',
            'sort_text',
        },
    },

    snippets = {
        preset = exists('luasnip') and 'luasnip' or 'default',

        ---Function to use when expanding LSP provided snippets
        expand = function(snippet)
            vim.snippet.expand(snippet)
        end,

        ---Function to use when checking if a snippet is active
        active = function(filter)
            return vim.snippet.active(filter)
        end,

        ---Function to use when jumping between tab stops in a snippet,
        ---where direction can be negative or positive
        jump = function(direction)
            vim.snippet.jump(direction) ---@diagnostic disable-line:param-type-mismatch
        end,
    },

    signature = {
        enabled = true,

        trigger = {
            ---Show the signature help automatically
            enabled = true,

            ---Show the signature help window after typing any of alphanumerics, `-` or `_`
            show_on_keyword = false,

            blocked_trigger_characters = {},
            blocked_retrigger_characters = {},

            ---Show the signature help window after typing a trigger character
            show_on_trigger_character = true,

            ---Show the signature help window when entering insert mode
            show_on_insert = false,

            ---Show the signature help window when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
        },

        window = {
            treesitter_highlighting = true,
            show_documentation = true,
            border = 'single',
            scrollbar = false,
            direction_priority = { 'n', 's' },
            -- direction_priority = { 's', 'n' },
        },
    },

    term = { enabled = false },
}

return Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
