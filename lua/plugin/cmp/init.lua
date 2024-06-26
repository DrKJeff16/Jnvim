local User = require('user')
local Check = User.check
local Util = User.util
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun

if not exists('cmp') or not exists('luasnip') then
    return
end

local tbl_contains = vim.tbl_contains
local get_mode = vim.api.nvim_get_mode

local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local Sks = require('plugin.cmp.kinds')
local CmpUtil = require('plugin.cmp.util')
local Sources = require('plugin.cmp.sources').new()

local Luasnip = exists('plugin.cmp.luasnip') and require('plugin.cmp.luasnip') or require('luasnip')
local cmp = require('cmp')
local Compare = require('cmp.config.compare')

local tab_map = CmpUtil.tab_map
local s_tab_map = CmpUtil.s_tab_map
local cr_map = CmpUtil.cr_map

local bs_map = CmpUtil.bs_map
local buffer = Sources.buffer

---@type table<string, cmp.MappingClass|fun(fallback: function):nil>
local Mappings = {
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(), -- Same as `<Esc>`
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping(cr_map),
    ['<Tab>'] = cmp.mapping(tab_map),
    ['<S-Tab>'] = cmp.mapping(s_tab_map),
    ['<BS>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
    ['<Down>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
    ['<Up>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
    ['<Right>'] = cmp.mapping(bs_map, { 'i', 's' }),
    ['<Left>'] = cmp.mapping(bs_map, { 'i', 's' }),
}

---@type cmp.ConfigSchema
local Opts = {
    ---@type fun(): boolean
    enabled = function()
        local disable_ft = {
            'NvimTree',
            'TelescopePrompt',
            'checkhealth',
            'help',
            'lazy',
            'qf',
        }

        local enable_comments = {
            'bash',
            'c',
            'codeowners',
            'cpp',
            'crontab',
            'css',
            'gitattributes',
            'gitconfig',
            'gitignore',
            'html',
            'java',
            'jsonc',
            'less',
            'lisp',
            'lua',
            'markdown',
            'python',
            'scss',
            'sh',
            'vim',
            'yaml',
        }

        ---@type string
        local ft = vim.api.nvim_get_option_value('ft', { scope = 'local' })

        if tbl_contains(disable_ft, ft) then
            return false
        end
        if tbl_contains(enable_comments, ft) then
            return true
        end
        if get_mode().mode == 'c' then
            return true
        end

        local Context = require('cmp.config.context')

        local in_ts_capture = Context.in_treesitter_capture
        local in_syntax_group = Context.in_syntax_group

        return not (in_ts_capture('comment') or in_syntax_group('Comment'))
    end,

    snippet = {
        ---@type fun(args: cmp.SnippetExpansionParams)
        expand = function(args)
            Luasnip.lsp_expand(args.body)
        end,
    },

    sorting = {
        priority_weight = 2,
        comparators = {
            Compare.kind,
            Compare.score,
            Compare.locality,
            Compare.scopes,
            Compare.recently_used,
            Compare.exact,
            Compare.offset,
            Compare.sort_text,
            Compare.length,
            Compare.order,
        },
    },

    experimental = { ghost_text = false },

    completion = {
        completeopt = 'menu,menuone,noselect,noinsert,preview',
        keyword_length = 1,
    },

    view = Sks.view,
    formatting = Sks.formatting,
    window = Sks.window,

    matching = {
        disallow_fullfuzzy_matching = true,
        disallow_fuzzy_matching = false,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = true,
        disallow_symbol_nonprefix_matching = true,
    },

    mapping = cmp.mapping.preset.insert(Mappings),

    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 4 },
        { name = 'nvim_lsp_signature_help', priority = 3 },
        { name = 'luasnip', priority = 2 },
        buffer(1),
    }),
}

cmp.setup(Opts)

Sources.setup()

if is_fun(Sks.vscode) then
    Sks.vscode()
end

-- For debugging.
Util.notify.notify('cmp loaded.', vim.log.levels.INFO)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
