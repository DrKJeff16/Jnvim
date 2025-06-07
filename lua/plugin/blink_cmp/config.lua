---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local has_words_before = Util.has_words_before

local BUtil = require('plugin.blink_cmp.util')
BUtil:gen_providers()

User:register_plugin('plugin.blink_cmp.config')

local Devicons = require('nvim-web-devicons')
local lspkind = require('lspkind')

---@type BlinkCmp.Cfg
local Cfg = {}

---@type BlinkCmp.Cfg.Config
Cfg.config = {}

Cfg.config.keymap = {
    preset = 'super-tab',

    ['<C-Space>'] = {
        function(cmp) return cmp.show({ providers = BUtil:gen_sources() }) end,
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
            if not cmp.is_menu_visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources() })
            end
        end,
        'snippet_forward',
        function(cmp) return cmp.select_next({ auto_insert = true }) end,
        'fallback',
    },
    ['<S-Tab>'] = {
        function(cmp)
            if not cmp.is_menu_visible() and has_words_before() then
                return cmp.show({ providers = BUtil:gen_sources() })
            end
        end,
        'snippet_backward',
        function(cmp) return cmp.select_prev({ auto_insert = true }) end,
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
}

Cfg.config.appearance = {}
Cfg.config.appearance.nerd_font_variant = 'mono'

Cfg.config.completion = {}
Cfg.config.completion.trigger = {}
Cfg.config.completion.trigger.show_in_snippet = true
Cfg.config.completion.trigger.show_on_trigger_character = true
Cfg.config.completion.trigger.show_on_blocked_trigger_characters = { ' ', '\t' }

Cfg.config.completion.documentation = {}
Cfg.config.completion.documentation.auto_show = true
Cfg.config.completion.documentation.auto_show_delay_ms = 1000
Cfg.config.completion.documentation.window = { border = 'rounded' }

Cfg.config.completion.keyword = { range = 'prefix' }

Cfg.config.completion.accept = {}
Cfg.config.completion.accept.auto_brackets = { enabled = false }
Cfg.config.completion.accept.create_undo_point = true

Cfg.config.completion.list = {}
Cfg.config.completion.list.selection = {}
-- Cfg.config.completion.list.selection.preselect = false
Cfg.config.completion.list.selection.preselect = function(ctx)
    return not require('blink.cmp').snippet_active({ direction = 1 })
end
Cfg.config.completion.list.selection.auto_insert = true

Cfg.config.completion.list.cycle = {}
Cfg.config.completion.list.cycle.from_top = true
Cfg.config.completion.list.cycle.from_bottom = true

Cfg.config.completion.menu = {}
-- Don't automatically show the completion menu
Cfg.config.completion.menu.auto_show = true
Cfg.config.completion.menu.border = 'single'

-- nvim-cmp style menu
Cfg.config.completion.menu.draw = {}
Cfg.config.completion.menu.draw.padding = { 0, 1 }
Cfg.config.completion.menu.draw.treesitter = { 'lsp' }

Cfg.config.completion.menu.draw.components = {}
Cfg.config.completion.menu.draw.components.kind_icon = {
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
}

Cfg.config.completion.menu.draw.columns = {
    { 'label', 'label_description', gap = 1 },
    { 'kind_icon', 'kind' },
}

Cfg.config.completion.ghost_text = {}
Cfg.config.completion.ghost_text.enabled = false

Cfg.config.cmdline = {}
Cfg.config.cmdline.enabled = true

Cfg.config.sources = {}
Cfg.config.sources.default = (function() return BUtil:gen_sources() end)()
Cfg.config.sources.per_filetype = {
    lua = { inherit_defaults = true, 'lazydev' },
}
Cfg.config.sources.providers = BUtil.Providers

Cfg.config.fuzzy = {}
-- Cfg.config.fuzzy.implementatio = executable({ 'cargo', 'rustc' }) and 'prefer_rust' or 'lua'
Cfg.config.fuzzy.implementation = 'lua'
Cfg.config.fuzzy.sorts = {
    'exact',
    -- 'label',
    -- 'kind',
    'score',
    'sort_text',
}

Cfg.config.snippets = {}
Cfg.config.snippets.preset = exists('luasnip') and 'luasnip' or 'default'
-- Function to use when expanding LSP provided snippets
Cfg.config.snippets.expand = function(snippet) vim.snippet.expand(snippet) end
-- Function to use when checking if a snippet is active
Cfg.config.snippets.active = function(filter) return vim.snippet.active(filter) end
-- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
Cfg.config.snippets.jump = function(direction) vim.snippet.jump(direction) end

Cfg.config.signature = {}
Cfg.config.signature.enabled = true

Cfg.config.signature.window = {}
Cfg.config.signature.window.show_documentation = true
Cfg.config.signature.window.border = 'double'
Cfg.config.signature.window.scrollbar = true
Cfg.config.signature.window.treesitter_highlighting = true
Cfg.config.signature.window.direction_priority = { 'n', 's' }
-- Cfg.config.signature.window.direction_priority = { 's', 'n' }

Cfg.config.cmdline = {}
Cfg.config.cmdline.enabled = true
-- use 'inherit' to inherit mappings from top level `keymap` config
Cfg.config.cmdline.keymap = { preset = 'cmdline' }
Cfg.config.cmdline.sources = function()
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
end
Cfg.config.cmdline.completion = {}
Cfg.config.cmdline.completion.trigger = {
    show_on_blocked_trigger_characters = {},
    show_on_x_blocked_trigger_characters = {},
}
Cfg.config.cmdline.completion.list = {}
Cfg.config.cmdline.completion.list.selection = {
    -- When `true`, will automatically select the first item in the completion list
    preselect = true,
    -- When `true`, inserts the completion item automatically when selecting it
    auto_insert = true,
}
-- Whether to automatically show the window when new completion items are available
Cfg.config.cmdline.completion.menu = { auto_show = false }
-- Displays a preview of the selected item on the current line
Cfg.config.cmdline.completion.ghost_text = { enabled = true }

---@param O? table
---@return BlinkCmp.Cfg|table
function Cfg.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Cfg })
end

return Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
