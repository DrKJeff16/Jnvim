---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local tbl_values = Check.value.tbl_values
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local ft_get = Util.ft_get
local au = Util.au.au_from_dict

User:register_plugin('plugin.blink_cmp.util')

---@type BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.Sources = {}

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
function BUtil:gen_sources()
    local ft = ft_get()

    if self.curr_ft ~= ft or empty(self.Sources) then
        self:reset_sources()
        self.curr_ft = ft
    end

    if self.curr_ft == 'lua' and exists('lazydev') then
        if not tbl_values({ 'lazydev' }, self.Sources) then
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

    if tbl_values({ self.curr_ft }, git_fts) and not tbl_values({ 'git' }, self.Sources) then
        table.insert(self.Sources, 1, 'git')
    end

    if self.curr_ft == 'gitcommit' and not tbl_values({ 'conventional_commits' }, self.Sources) then
        table.insert(self.Sources, 1, 'conventional_commits')
    end
end

---@type BlinkCmp.Util.Providers
BUtil.Providers = {}

---@param self BlinkCmp.Util
function BUtil:reset_providers()
    self.Providers = {}

    self.Providers.buffer = {
        -- keep case of first char
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
        should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
    }

    self.Providers.lsp = {
        name = 'LSP',
        module = 'blink.cmp.sources.lsp',
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
---@param P? blink.cmp.SourceProviderConfigPartial[]
function BUtil:gen_providers(P)
    self:reset_providers()

    if exists('blink-cmp-git') then
        self.Providers.git = {
            module = 'blink-cmp-git',
            name = 'Git',
            enabled = function()
                ---@type boolean
                local res = tbl_values(
                    { ft_get() },
                    { 'git', 'gitcommit', 'gitattributes', 'gitrebase' }
                )

                return res
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
end

---@param O? table
---@return BlinkCmp.Util|table
function BUtil.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = BUtil })
end

local au_group = vim.api.nvim_create_augroup('BlinkAU', { clear = true })
au({
    ['BufEnter'] = {
        group = au_group,
        callback = function()
            BUtil:reset_sources()
            BUtil.curr_ft = ft_get()
        end,
    },
})

return BUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
