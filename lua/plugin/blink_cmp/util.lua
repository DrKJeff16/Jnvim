---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_bool = Check.value.is_bool
local empty = Check.value.empty
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

    if not snipps then
        table.insert(self.Sources, 'snippets')
    end
    if not buf then
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
    self.Providers = {}

    self.Providers.buffer = {
        score_offset = -100,

        max_items = 10,

        -- keep case of first char
        ---@param a blink.cmp.Context
        ---@param items blink.cmp.CompletionItem[]
        ---@return blink.cmp.CompletionItem[]
        transform_items = function(a, items)
            local keyword = a.get_keyword()
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
    }

    self.Providers.snippets = {
        name = 'Snip',
        score_offset = -70,
        max_items = 7,
        should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
    }

    self.Providers.lsp = {
        name = 'LSP',
        module = 'blink.cmp.sources.lsp',
        score_offset = 100,
        transform_items = function(_, items)
            return vim.tbl_filter(
                function(item)
                    return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                end,
                items
            )
        end,
    }

    if exists('blink-cmp-git') then
        self.Providers.git = {
            module = 'blink-cmp-git',
            name = 'Git',
            score_offset = 40,
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
            score_offset = 60,
            enabled = function() return vim.bo.filetype == 'gitcommit' end,

            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {}, -- none so far
        }
    end

    if exists('lazydev') then
        self.Providers.lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
            enabled = function() return vim.bo.filetype == 'lua' end,
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
