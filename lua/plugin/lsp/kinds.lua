---@diagnostic disable:missing-fields

---@module 'user_api.types.lspconfig'

local User = require('user_api')
local Check = User.check

local is_str = Check.value.is_str
local empty = Check.value.empty

---@type Lsp.SubMods.Kinds
local Kinds = {}

---@type Lsp.SubMods.Kinds.Icons
Kinds.icons = {
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
}

---@param self Lsp.SubMods.Kinds
function Kinds:setup()
    ---@type table<string, string>
    local kinds = vim.lsp.protocol.CompletionItemKind

    for s, kind in next, kinds do
        kinds[s] = (is_str(self.icons[s]) and not empty(self.icons[s])) and self.icons[s] or kind
    end
end

return Kinds

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
