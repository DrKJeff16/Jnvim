---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local tbl_values = Check.value.tbl_values
local ft_get = Util.ft_get
local au = Util.au.au_from_dict

User:register_plugin('plugin.blink_cmp.util')

---@module 'user_api.types.blink_cmp'

---@type BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.sources = {
    'lsp',
    'path',
    'buffer',
    'snippets',
}

BUtil.curr_ft = ''

---@param self BlinkCmp.Util
function BUtil:reset_sources()
    self.sources = {
        'lsp',
        'path',
        'buffer',
        'snippets',
    }
end

---@param self BlinkCmp.Util
---@return BlinkCmp.Util.Sources
function BUtil:get_sources()
    local ft = ft_get()

    if self.curr_ft ~= ft then
        self:reset_sources()
        self.curr_ft = ft
    end

    if self.curr_ft == 'lua' and exists('lazydev') then
        if not tbl_values({ 'lazydev' }, self.sources) then
            table.insert(self.sources, 1, 'lazydev')
        end

        return self.sources
    end

    local git_fts = {
        'git',
        'gitcommit',
        'gitattributes',
        'gitrebase',
    }

    if tbl_values({ self.curr_ft }, git_fts) and not tbl_values({ 'git' }, self.sources) then
        table.insert(self.sources, 1, 'git')
    end

    if self.curr_ft == 'gitcommit' and not tbl_values({ 'conventional_commits' }, self.sources) then
        table.insert(self.sources, 1, 'conventional_commits')
    end

    return self.sources
end

---@type BlinkCmp.Util.Providers
BUtil.Providers = {}

BUtil.Providers.buffer = {
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

BUtil.Providers.snippets = {
    should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
}

BUtil.Providers.lsp = {
    name = 'LSP',
    module = 'blink.cmp.sources.lsp',
    transform_items = function(_, items)
        return vim.tbl_filter(
            function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword end,
            items
        )
    end,
}

if exists('blink-cmp-git') then
    BUtil.Providers.git = {
        module = 'blink-cmp-git',
        name = 'Git',
        enabled = function()
            local ft = ft_get()
            return tbl_values({ ft }, { 'git', 'gitcommit', 'gitattributes', 'gitrebase' })
        end,
    }
end

if exists('blink-cmp-conventional-commits') then
    BUtil.Providers.conventional_commits = {
        name = 'Conventional Commits',
        module = 'blink-cmp-conventional-commits',
        enabled = function() return vim.bo.filetype == 'gitcommit' end,

        ---@module 'blink-cmp-conventional-commits'
        ---@type blink-cmp-conventional-commits.Options
        opts = {}, -- none so far
    }
end

if exists('lazydev') then
    BUtil.Providers.lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
        enabled = function() return vim.bo.filetype == 'lua' end,
    }
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
