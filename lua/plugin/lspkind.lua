local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('lspkind') then
    User.deregister_plugin('plugin.lspkind')
    return
end

local Lspkind = require('lspkind')

Lspkind.init({
    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
        Class = '󰠱',
        Color = '󰏘',
        Constant = '󰏿',
        Constructor = '',
        Enum = '',
        EnumMember = '',
        Event = '',
        Field = '󰜢',
        File = '󰈙',
        Folder = '󰉋',
        Function = '󰊕',
        Interface = '',
        Keyword = '󰌋',
        Method = '󰆧',
        Module = '',
        Operator = '󰆕',
        Property = '󰜢',
        Reference = '󰈇',
        Snippet = '',
        Struct = '󰙅',
        Text = '󰉿',
        TypeParameter = '',
        Unit = '󰑭',
        Value = '󰎠',
        Variable = '󰀫',
    },
})

User.register_plugin('plugin.lspkind')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
