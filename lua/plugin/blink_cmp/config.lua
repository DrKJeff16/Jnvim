---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local has_words_before = Util.has_words_before

local replace_termcodes = vim.api.nvim_replace_termcodes
local feedkeys = vim.api.nvim_feedkeys

local BUtil = require('plugin.blink_cmp.util')

User:register_plugin('plugin.blink_cmp.config')

local Devicons = require('nvim-web-devicons')
local lspkind = require('lspkind')

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
    ['<C-e>'] = { 'cancel', 'fallback' },

    ['<CR>'] = { 'accept', 'fallback' },

    ['<Tab>'] = {
        function(cmp)
            local visible = cmp.is_menu_visible

            if not visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources(false, false) })
            end
        end,

        function(cmp)
            if cmp.snippet_active({ direction = 1 }) then
                return cmp.snippet_forward()
            end
        end,

        function(cmp) return cmp.select_next({ auto_insert = true, preselect = false }) end,
        'fallback',
    },
    ['<S-Tab>'] = {
        function(cmp)
            local visible = cmp.is_menu_visible

            if not visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources(true, true) })
            end
        end,

        function(cmp)
            if cmp.snippet_active({ direction = -1 }) then
                return cmp.snippet_backward()
            end
        end,

        function(cmp) return cmp.select_prev({ auto_insert = true, preselect = false }) end,

        'fallback',
    },

    ['<Up>'] = {
        function(cmp)
            if cmp.is_active() or cmp.is_visible() then
                return cmp.cancel({
                    callback = function()
                        local termcode = replace_termcodes('<Up>', true, false, true)
                        feedkeys(termcode, 'i', false)
                    end,
                })
            end
        end,
        'fallback',
    },
    ['<Down>'] = {
        function(cmp)
            if cmp.is_visible() or cmp.is_active() then
                return cmp.cancel({
                    callback = function()
                        local termcode = replace_termcodes('<Down>', true, false, true)
                        feedkeys(termcode, 'i', false)
                    end,
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
        window = { border = 'rounded' },
    },

    keyword = { range = 'prefix' },

    accept = {
        auto_brackets = { enabled = false },
        create_undo_point = true,
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

            components = {
                kind_icon = {
                    text = function(ctx)
                        local icon = ctx.kind_icon

                        if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                            local dev_icon, _ = Devicons.get_icon(ctx.label)
                            if dev_icon then
                                icon = dev_icon
                            end
                        else
                            icon = lspkind.symbolic(ctx.kind, {
                                mode = 'symbol',
                            })
                        end

                        return icon .. ctx.icon_gap
                    end,

                    -- Optionally, use the highlight groups from nvim-web-devicons
                    -- You can also add the same function for `kind.highlight` if you want to
                    -- keep the highlight groups in sync with the icons.
                    highlight = function(ctx)
                        local hl = ctx.kind_hl
                        if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                            local dev_icon, dev_hl = Devicons.get_icon(ctx.label)
                            if dev_icon then
                                hl = dev_hl
                            end
                        end
                        return hl
                    end,
                },
            },

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
        preset = 'inherit',

        ['<Right>'] = { 'fallback' },
        ['<Left>'] = { 'fallback' },
        ['<C-p>'] = { 'fallback' },
        ['<C-n>'] = { 'fallback' },
    },
}

Cfg.Config.sources = {
    default = (function() return BUtil:gen_sources(true, false) end)(),

    per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
    },

    providers = BUtil:gen_providers(),
}

Cfg.Config.fuzzy = {
    -- implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust' or 'lua',
    implementation = 'lua',

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
    expand = function(snippet) vim.snippet.expand(snippet) end,

    -- Function to use when checking if a snippet is active
    active = function(filter) return vim.snippet.active(filter) end,

    -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    ---@diagnostic disable-next-line
    jump = function(direction) vim.snippet.jump(direction) end,
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

return Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
