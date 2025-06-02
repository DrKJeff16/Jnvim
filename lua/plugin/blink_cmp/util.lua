---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local tbl_values = Check.value.tbl_values
local ft_get = Util.ft_get

User:register_plugin('plugin.blink_cmp.util')

---@module 'user_api.types.blink_cmp'

---@type BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.DEFAULT_SRCS = {
    'lsp',
    'path',
    'buffer',
    'snippets',
}

---@param self BlinkCmp.Util
---@param T? BlinkCmp.Util.Sources
---@return BlinkCmp.Util.Sources
function BUtil:get_sources(T)
    local res = is_tbl(T) and T or self.DEFAULT_SRCS

    local ft = ft_get()

    if ft == 'lua' then
        if exists('lazydev') then
            if not Check.value.tbl_values({ 'lazydev' }, res) then
                table.insert(res, 1, 'lazydev')
            end
        end
    end
    if
        tbl_values({ ft }, {
            'git',
            'gitcommit',
            'gitattributes',
            'gitrebase',
        }) and not tbl_values({ 'git' }, res)
    then
        table.insert(res, 1, 'git')

        if
            tbl_values({ ft }, { 'gitcommit' }) and not tbl_values({ 'conventional_commits' }, res)
        then
            table.insert(res, 1, 'conventional_commits')
        end
    end

    return res
end

---@type BlinkCmp.Util.Providers
BUtil.Providers = {}

BUtil.Providers.snippets = {
    preset = 'default',
    should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
}

BUtil.Providers.git = {
    module = 'blink-cmp-git',
    name = 'Git',
    enabled = function()
        local ft = ft_get()
        return tbl_values({ ft }, { 'git', 'gitcommit', 'gitattributes', 'gitrebase' })
    end,
}

BUtil.Providers.conventional_commits = {
    name = 'Conventional Commits',
    module = 'blink-cmp-conventional-commits',
    enabled = function() return vim.bo.filetype == 'gitcommit' end,
    ---@module 'blink-cmp-conventional-commits'
    ---@type blink-cmp-conventional-commits.Options
    opts = {}, -- none so far
}

BUtil.Providers.lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
    enabled = function() return vim.bo.filetype == 'lua' end,
}

return BUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
