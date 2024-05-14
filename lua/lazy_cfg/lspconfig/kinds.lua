---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

local User = require('user')
local types = User.types.lspconfig

local lsp = vim.lsp

---@type LspKindsMod
local M = {
	icons = {
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
	},
}

function M.setup()
	local ptc = lsp.protocol

	---@type table<string, string>
	local kinds = ptc.CompletionItemKind

	for s, kind in next, kinds do
		kinds[s] =  M.icons[s] or kind
	end
end

return M
