---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local empty = Check.value.empty
local ft_get = Util.ft_get
local au = Util.au.au_repeated_events

local in_tbl = vim.tbl_contains

User:register_plugin('plugin.blink_cmp.util')

---@type BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.Sources = {
    'lsp',
    'path',
    'buffer',
    'snippets',
}

BUtil.curr_ft = ''

---@param self BlinkCmp.Util
function BUtil:reset_sources()
    self.Sources = {
        'lsp',
        'path',
        'buffer',
        'snippets',
    }
end

---@param self BlinkCmp.Util
---@return BlinkCmp.Util.Sources
function BUtil:gen_sources()
    local ft = ft_get()

    if self.curr_ft ~= ft or empty(self.Sources) then
        self:reset_sources()
        self.curr_ft = ft
    end

    if ft == 'lua' and exists('lazydev') then
        if not in_tbl(self.Sources, 'lazydev') then
            table.insert(self.Sources, 1, 'lazydev')
        end

        return self.Sources
    end

    local git_fts = {
        'git',
        'gitcommit',
        'gitattributes',
        'gitrebase',
    }

    if in_tbl(git_fts, ft) and not in_tbl(self.Sources, 'git') then
        table.insert(self.Sources, 1, 'git')
    end

    if ft == 'gitcommit' and not in_tbl(self.Sources, 'conventional_commits') then
        table.insert(self.Sources, 1, 'conventional_commits')
    end

    return self.Sources
end

---@type BlinkCmp.Util.Providers
BUtil.Providers = {}

---@param self BlinkCmp.Util
function BUtil:reset_providers()
    self.Providers = {}

    self.Providers.buffer = {
        score_offset = -20,

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
        score_offset = -10,
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
end

---@param self BlinkCmp.Util
---@param P? table<string, blink.cmp.SourceProviderConfigPartial>
function BUtil:gen_providers(P)
    self:reset_providers()

    if exists('blink-cmp-git') then
        self.Providers.git = {
            module = 'blink-cmp-git',
            name = 'Git',
            enabled = function()
                local git_fts = {
                    'git',
                    'gitcommit',
                    'gitattributes',
                    'gitrebase',
                }

                return in_tbl(git_fts, ft_get())
            end,
        }
    end

    if exists('blink-cmp-conventional-commits') then
        self.Providers.conventional_commits = {
            name = 'Conventional Commits',
            module = 'blink-cmp-conventional-commits',
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

    if not is_tbl(P) or empty(P) then
        return
    end

    for provider, cfg in next, P do
        if is_str(provider) and is_tbl(cfg) and not empty(cfg) then
            self.Providers[provider] = cfg
        end
    end
end

---@param O? table
---@return BlinkCmp.Util|table
function BUtil.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = BUtil })
end

local au_group = vim.api.nvim_create_augroup('BlinkAU', { clear = true })
---@type AuRepeatEvents[]
local au_tbl = {
    {
        events = { 'BufEnter', 'BufNew', 'WinEnter' },
        opts_tbl = {
            {
                group = au_group,
                pattern = '*',
                callback = function() BUtil.curr_ft = ft_get() end,
            },
        },
    },
}

for _, autocmd in next, au_tbl do
    au(autocmd)
end

return BUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
