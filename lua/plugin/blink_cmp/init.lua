local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local tbl_values = Check.value.tbl_values
local executable = Check.exists.executable
local has_words_before = Util.has_words_before

User:register_plugin('plugin.blink_cmp')

local Blink = require('blink.cmp')
local Devicons = require('nvim-web-devicons')
local lspkind = require('lspkind')

local DEFAULT_SRCS = {
    'lsp',
    'path',
    'snippets',
    'buffer',
}

---@param T string[]?
---@return string[]
local function get_sources(T)
    T = is_tbl(T) and T or DEFAULT_SRCS

    local ft = Util.ft_get()

    if ft == 'lua' then
        table.insert(T, 1, 'lazydev')
    end
    if
        tbl_values({ ft }, {
            'git',
            'gitcommit',
            'gitattributes',
            'gitrebase',
        }) and not tbl_values({ 'git' }, T)
    then
        table.insert(T, 1, 'git')

        if
            tbl_values({ ft }, { 'gitcommit' }) and not tbl_values({ 'conventional_commits' }, T)
        then
            table.insert(T, 1, 'conventional_commits')
        end
    end

    return T
end

---@type table<string, blink.cmp.SourceProviderConfigPartial>
local providers = {}

providers.snippets = {
    -- preset = 'default',
    should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
}

providers.git = {
    module = 'blink-cmp-git',
    name = 'Git',
}

providers.conventional_commits = {
    name = 'Conventional Commits',
    module = 'blink-cmp-conventional-commits',
    enabled = function() return vim.bo.filetype == 'gitcommit' end,
    ---@module 'blink-cmp-conventional-commits'
    ---@type blink-cmp-conventional-commits.Options
    opts = {}, -- none so far
}

if exists('luasnip.loaders.from_vscode') then
    require('luasnip.loaders.from_vscode').lazy_load()
end

if exists('lazydev') then
    if not Check.value.tbl_values({ 'lazydev' }, DEFAULT_SRCS) then
        table.insert(DEFAULT_SRCS, 1, 'lazydev')
    end

    providers.lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
    }
end

---@type blink.cmp.Config
local M = {
    keymap = {
        preset = 'super-tab',

        ['<C-Space>'] = {
            function(cmp)
                if not cmp.is_menu_visible() then
                    return cmp.show({ providers = get_sources() })
                end
            end,
            'show_documentation',
            'hide_documentation',
        },
        ['<C-e>'] = {
            'cancel',
            'fallback',
        },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
            function(cmp)
                if not cmp.is_menu_visible() then
                    return has_words_before() and cmp.show({ providers = get_sources() }) or nil
                end
            end,
            function(cmp) return cmp.select_next({ auto_insert = false }) end,
            'snippet_forward',
            'fallback',
        },
        ['<S-Tab>'] = {
            function(cmp)
                if not cmp.is_menu_visible() then
                    return has_words_before() and cmp.show({ providers = get_sources() }) or nil
                end
            end,
            function(cmp) return cmp.select_prev({ auto_insert = false }) end,
            'snippet_backward',
            'fallback',
        },

        ['<Up>'] = { 'fallback' },
        ['<Down>'] = { 'fallback' },
        ['<C-p>'] = { 'fallback' },
        ['<C-n>'] = { 'fallback' },

        ['<C-b>'] = {
            function(cmp)
                if cmp.is_active() then
                    return cmp.scroll_documentation_up(4)
                end
            end,
            'fallback',
        },
        ['<C-f>'] = {
            function(cmp)
                if cmp.is_active() then
                    return cmp.scroll_documentation_down(4)
                end
            end,
            'fallback',
        },

        ['<C-k>'] = {
            'show_signature',
            'hide_signature',
            'fallback',
        },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        trigger = {
            show_in_snippet = true,
        },

        documentation = {
            auto_show = true,
            window = { border = 'double' },
        },

        keyword = { range = 'prefix' },

        accept = {
            auto_brackets = { enabled = true },
            create_undo_point = true,
        },

        list = {
            selection = {
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
                    {
                        'label',
                        'label_description',
                        gap = 1,
                    },
                    { 'kind_icon', 'kind' },
                },
            },
        },

        ghost_text = { enabled = false },
    },

    cmdline = { enabled = true },

    sources = {
        default = DEFAULT_SRCS,
        providers = providers,
    },

    fuzzy = {
        implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust' or 'lua',
        sorts = {
            'exact',
            'score',
            'kind',
            'label',
            'sort_text',
        },
    },

    snippets = {
        preset = exists('luasnip') and 'luasnip' or 'default',
    },

    signature = {
        enabled = true,

        window = {
            show_documentation = true,
        },
    },
}

Blink.setup(M)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
