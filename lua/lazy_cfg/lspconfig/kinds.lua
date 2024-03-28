---@class LspKindsIconsMod
---@field Class? string
---@field Color? string
---@field Constant? string
---@field Constructor? string
---@field Enum? string
---@field EnumMember? string
---@field Field? string
---@field File? string
---@field Folder? string
---@field Function? string
---@field Interface? string
---@field Keyword? string
---@field Method? string
---@field Module? string
---@field Property? string
---@field Snippet? string
---@field Struct? string
---@field Text? string
---@field Unit? string
---@field Value? string
---@field Variable? string

---@class LspKindsMod
---@field icons LspKindsIconsMod
---@field setup fun(...)
local M = {}

M.icons = {
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Enum = " ",
	EnumMember = " ",
	Field = "󰄶 ",
	File = " ",
	Folder = " ",
	Function = " ",
	Interface = "󰜰",
	Keyword = "󰌆 ",
	Method = "ƒ ",
	Module = "󰏗 ",
	Property = " ",
	Snippet = "󰘍 ",
	Struct = " ",
	Text = " ",
	Unit = " ",
	Value = "󰎠 ",
	Variable = " ",
}


function M.setup()
	local kinds = vim.lsp.protocol.CompletionItemKind
	for i, kind in next, kinds do
		kinds[i] = M.icons[kind] or kind
	end
end

return M
