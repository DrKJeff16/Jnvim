---@diagnostic disable:missing-fields

---@module 'user_api.types.lsp'

local User = require('user_api')
local Check = User.check

local is_tbl = Check.value.is_tbl
local type_not_empty = Check.value.type_not_empty

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
        kinds[s] = type_not_empty('string', self.icons[s]) and self.icons[s] or kind
    end
end

---@param O table
---@return Lsp.SubMods.Kinds
function Kinds.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Kinds })
end

return Kinds

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
