---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local types = User.types.autopairs

local mods_exist = Check.exists.modules

if not mods_exist({ 'nvim-autopairs', 'cmp' }) then
    return
end

local cmp = require('cmp')
local cmp_ap = require('nvim-autopairs.completion.cmp')
local handlers = require('nvim-autopairs.completion.handlers')

local cmp_lsp = cmp.lsp
local insp = vim.inspect

local ft_handles = {
    filetypes = {
        -- "*" is a alias to all filetypes
        ['*'] = {
            ['('] = {
                kind = {
                    cmp_lsp.CompletionItemKind.Function,
                    cmp_lsp.CompletionItemKind.Method,
                },
                handler = handlers['*'],
            },
        },
        tex = false,
        text = false,
    },
}

---@type APCmp
local M = {
    on = function()
        cmp.event:on('confirm_done', cmp_ap.on_confirm_done(ft_handles))
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
