---@diagnostic disable:missing-fields

---@module 'blink.cmp'

---@alias BlinkCmp.Cfg.Config blink.cmp.Config

---@class BlinkCmp.Cfg
---@field Config BlinkCmp.Cfg.Config
---@field new fun(O: table?): table|BlinkCmp.Cfg

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local executable = Check.exists.executable
local is_tbl = Check.value.is_tbl
local has_words_before = Util.has_words_before

local BUtil = require('plugin.blink_cmp.util')

---@param key string
---@return fun()
local function gen_termcode_fun(key)
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

    -- Also known as `<Esc>`
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
            return cmp.snippet_active({ direction = 1 }) and cmp.snippet_forward() or nil
        end,

        function(cmp)
            local visible = cmp.is_menu_visible

            return (not visible() and has_words_before())
                    and cmp.show({ providers = BUtil:gen_sources(true, true) })
                or nil
        end,

        function(cmp)
            return cmp.select_next({ auto_insert = true, preselect = false })
        end,
        'fallback',
    },
    ['<S-Tab>'] = {
        function(cmp)
            return cmp.snippet_active({ direction = -1 }) and cmp.snippet_backward() or nil
        end,

        function(cmp)
            local visible = cmp.is_menu_visible

            return (not visible() and has_words_before())
                    and cmp.show({ providers = BUtil:gen_sources(true, true) })
                or nil
        end,

        function(cmp)
            return cmp.select_prev({ auto_insert = true, preselect = false })
        end,

        'fallback',
    },

    ['<Up>'] = {
        function(cmp)
            return (cmp.is_active() or cmp.is_visible())
                    and cmp.cancel({
                        callback = gen_termcode_fun('<Up>'),
                    })
                or nil
        end,
        'fallback',
    },
    ['<Down>'] = {
        function(cmp)
            return (cmp.is_active() or cmp.is_visible())
                    and cmp.cancel({
                        callback = gen_termcode_fun('<Down>'),
                    })
                or nil
        end,
        'fallback',
    },

    ['<C-p>'] = { 'fallback' },
    ['<C-n>'] = { 'fallback' },

    ['<C-b>'] = {
        function(cmp)
            return cmp.is_documentation_visible() and cmp.scroll_documentation_up(4) or nil
        end,
        'fallback',
    },
    ['<C-f>'] = {
        function(cmp)
            return cmp.is_documentation_visible() and cmp.scroll_documentation_down(4) or nil
        end,
        'fallback',
    },
    ['<C-k>'] = {
        function(cmp)
            return not cmp.is_signature_visible() and cmp.show_signature() or cmp.hide_signature()
        end,
        'fallback',
    },
}

Cfg.Config.appearance = {
    nerd_font_variant = 'mono',

    highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    -- Useful for when your theme doesn't support blink.cmp
    -- Will be removed in a future release
    use_nvim_cmp_as_default = true,

    kind_icons = require('lspkind').symbol_map,
}

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
        -- Don't automatically show the completion menu
        auto_show = true,

        border = 'single',

        -- nvim-cmp style menu
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
}

Cfg.Config.cmdline = {
    enabled = false,

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
}

Cfg.Config.sources = {
    default = function()
        return BUtil:gen_sources(true, true)
    end,

    -- Function to use when transforming the items before they're returned for all providers
    -- The default will lower the score for snippets to sort them lower in the list
    transform_items = function(_, items)
        return items
    end,

    providers = BUtil:gen_providers(),
}

Cfg.Config.fuzzy = {
    -- implementation = 'lua',
    implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust_with_warning' or 'lua',

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
        ---@diagnostic disable-next-line:param-type-mismatch
        vim.snippet.jump(direction)
    end,
}

Cfg.Config.signature = {
    enabled = true,

    trigger = {
        -- Show the signature help automatically
        enabled = true,

        -- Show the signature help window after typing any of alphanumerics, `-` or `_`
        show_on_keyword = false,

        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},

        -- Show the signature help window after typing a trigger character
        show_on_trigger_character = true,

        -- Show the signature help window when entering insert mode
        show_on_insert = false,

        -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
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
}

Cfg.Config.cmdline = {
    enabled = true,

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
        ghost_text = { enabled = false },
    },
}

Cfg.Config.term = { enabled = false }

---@param O? table
---@return BlinkCmp.Cfg|table
function Cfg.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Cfg })
end

User.register_plugin('plugin.blink_cmp.config')

return Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
