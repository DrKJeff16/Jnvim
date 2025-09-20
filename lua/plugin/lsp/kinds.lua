local User = require('user_api')
local Check = User.check

local type_not_empty = Check.value.type_not_empty

---@class Lsp.SubMods.Kinds
local Kinds = {}

---@class Lsp.SubMods.Kinds.Icons
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

---@return table|Lsp.SubMods.Kinds|fun()
function Kinds.new()
    return setmetatable({}, {
        __index = Kinds,

        ---@param self Lsp.SubMods.Kinds
        __call = function(self)
            ---@type table<string, string>
            local kinds = vim.lsp.protocol.CompletionItemKind

            for s, kind in next, kinds do
                kinds[s] = type_not_empty('string', self.icons[s]) and self.icons[s] or kind
            end
        end,
    })
end

User.register_plugin('plugin.lsp.kinds')

return Kinds.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
