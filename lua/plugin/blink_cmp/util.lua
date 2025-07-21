---@diagnostic disable:missing-fields

---@module 'blink.cmp'

---@alias BlinkCmp.Util.Sources ('lsp'|'path'|'snippets'|'buffer'|string)[]
---@alias BlinkCmp.Util.Providers table<string, blink.cmp.SourceProviderConfigPartial>

---@class BlinkCmp.Util
---@field curr_ft string
---@field Sources BlinkCmp.Util.Sources
---@field Providers BlinkCmp.Util.Providers
---@field reset_sources fun(self: BlinkCmp.Util, snipps: boolean?, buf: boolean?)
---@field reset_providers fun(self: BlinkCmp.Util)
---@field gen_sources fun(self: BlinkCmp.Util, snipps: boolean?, buf: boolean?): BlinkCmp.Util.Sources
---@field gen_providers fun(self: BlinkCmp.Util, P: BlinkCmp.Util.Providers?): BlinkCmp.Util.Providers
---@field new fun(O: table?): table|BlinkCmp.Util

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_bool = Check.value.is_bool
local type_not_empty = Check.value.type_not_empty

local in_tbl = vim.tbl_contains

---@type BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.Sources = {}

---@type BlinkCmp.Util.Providers
BUtil.Providers = {}

BUtil.curr_ft = ''

---@param self BlinkCmp.Util
---@param snipps? boolean
---@param buf? boolean
function BUtil:reset_sources(snipps, buf)
    snipps = is_bool(snipps) and snipps or false
    buf = is_bool(buf) and buf or true

    self.Sources = {
        'lsp',
        'path',
    }

    if snipps then
        table.insert(self.Sources, 'snippets')
    end
    if buf then
        table.insert(self.Sources, 'buffer')
    end

    if vim.bo.filetype == 'lua' then
        table.insert(self.Sources, 1, 'lazydev')
    end

    local git_fts = {
        'git',
        'gitcommit',
        'gitattributes',
        'gitrebase',
    }

    if in_tbl(git_fts, vim.bo.filetype) then
        table.insert(self.Sources, 1, 'git')
    end

    if vim.bo.filetype == 'gitcommit' then
        table.insert(self.Sources, 1, 'conventional_commits')
    end
end

---@param self BlinkCmp.Util
---@param snipps? boolean
---@param buf? boolean
---@return BlinkCmp.Util.Sources
function BUtil:gen_sources(snipps, buf)
    snipps = is_bool(snipps) and snipps or false
    buf = is_bool(buf) and buf or true

    self:reset_sources(snipps, buf)

    return self.Sources
end

---@param self BlinkCmp.Util
function BUtil:reset_providers()
    self.Providers = {
        buffer = {
            score_offset = -20,

            max_items = 8,

            -- keep case of first char
            ---@param ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@return blink.cmp.CompletionItem[]
            transform_items = function(ctx, items)
                local keyword = ctx.get_keyword()
                local correct = ''

                ---@type fun(s: string|number): string
                local case

                if keyword:match('^%l') then
                    correct = '^%u%l+$'
                    case = string.lower
                elseif keyword:match('^%u') then
                    correct = '^%l+$'
                    case = string.upper
                else
                    return items
                end

                -- avoid duplicates from the corrections
                local seen = {}
                local out = {}

                for _, item in next, items do
                    ---@type string
                    local raw = item.insertText

                    if raw:match(correct) then
                        local text = case(raw:sub(1, 1)) .. raw:sub(2)
                        item.insertText = text
                        item.label = text
                    end
                    if not seen[item.insertText] then
                        seen[item.insertText] = true
                        table.insert(out, item)
                    end
                end

                return out
            end,
        },

        path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 30,

            fallbacks = { 'buffer' },

            ---@type blink.cmp.PathOpts
            opts = {
                label_trailing_slash = true,
                show_hidden_files_by_default = true,
                trailing_slash = false,
            },
        },

        snippets = {
            name = 'Snippet',
            score_offset = -50,
            max_items = 7,

            ---@param ctx blink.cmp.Context
            should_show_items = function(ctx)
                return ctx.trigger.initial_kind ~= 'trigger_character'
            end,
        },

        lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
            fallbacks = { 'lsp' },
        },

        lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            score_offset = 60,

            ---@param _ blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@return blink.cmp.CompletionItem[]
            transform_items = function(_, items)
                return vim.tbl_filter(
                    ---@param value blink.cmp.CompletionItem
                    ---@return boolean
                    function(value)
                        return value.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                    end,
                    items
                )
            end,

            fallbacks = {},
        },
    }

    if exists('blink-cmp-git') then
        self.Providers.git = {
            name = 'Git',
            module = 'blink-cmp-git',

            enabled = function()
                local git_fts = {
                    'git',
                    'gitcommit',
                    'gitattributes',
                    'gitrebase',
                }

                return in_tbl(git_fts, vim.bo.filetype)
            end,
        }
    end

    if exists('blink-cmp-conventional-commits') then
        self.Providers.conventional_commits = {
            name = 'CC',
            module = 'blink-cmp-conventional-commits',
            score_offset = 100,
            enabled = function()
                return vim.bo.filetype == 'gitcommit'
            end,

            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {}, -- none so far
        }
    end

    if exists('orgmode') then
        self.Providers.orgmode = {
            name = 'Orgmode',
            module = 'orgmode.org.autocompletion.blink',
            fallbacks = { 'buffer' },
        }
    end
end

---@param self BlinkCmp.Util
---@param P? BlinkCmp.Util.Providers
---@return BlinkCmp.Util.Providers
function BUtil:gen_providers(P)
    self:reset_providers()

    if type_not_empty('table', P) then
        self.Providers = vim.tbl_deep_extend('keep', P, self.Providers)
    end

    return self.Providers
end

---@param O? table
---@return BlinkCmp.Util|table
function BUtil.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = BUtil })
end

User:register_plugin('plugin.blink_cmp.util')

return BUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
