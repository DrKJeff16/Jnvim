---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

local User = require('user')
local Check = User.check
local types = User.types.lspconfig

local is_str = Check.value.is_str
local empty = Check.value.empty

---@type LspKindsMod
local M = {
    icons = {
        Class = ' ',
        Color = ' ',
        Constant = ' ',
        Constructor = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Field = '󰄶 ',
        File = ' ',
        Folder = ' ',
        Function = ' ',
        Interface = '󰜰',
        Keyword = '󰌆 ',
        Method = 'ƒ ',
        Module = '󰏗 ',
        Property = ' ',
        Snippet = '󰘍 ',
        Struct = ' ',
        Text = ' ',
        Unit = ' ',
        Value = '󰎠 ',
        Variable = ' ',
    },
}

function M.setup()
    ---@type table<string, string>
    local kinds = vim.lsp.protocol.CompletionItemKind

    for s, kind in next, kinds do
        kinds[s] = (is_str(M.icons[s]) and not empty(M.icons[s])) and M.icons[s] or kind
    end
end

return M
