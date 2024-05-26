---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local utypes = User.types.cmp

local mods_exist = Check.exists.modules
local hl = User.highlight.hl

local api = vim.api

local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local cmp = require('cmp')
local LK = require('lspkind')

---@type FmtKindIcons
local kind_icons = {
	Class = '󰠱',
	Color = '󰏘',
	Constant = '󰏿',
	Constructor = '',
	Enum = '',
	EnumMember = '',
	Event = '',
	Field = '󰇽',
	File = '󰈙',
	Folder = '󰉋',
	Function = '󰊕',
	Interface = '',
	Keyword = '󰌋',
	Method = '󰆧',
	Module = '',
	Operator = '󰆕',
	Property = '󰜢',
	Reference = '',
	Snippet = '',
	Struct = '',
	Text = '',
	TypeParameter = '󰅲',
	Unit = '',
	Value = '󰎠',
	Variable = '󰂡',
}

---@type FmtKindIcons
local kind_codicons = {
	Class = '  ',
	Color = '  ',
	Constant = '  ',
	Constructor = '  ',
	Enum = '  ',
	EnumMember = '  ',
	Event = '  ',
	Field = '  ',
	File = '  ',
	Folder = '  ',
	Function = '  ',
	Interface = '  ',
	Keyword = '  ',
	Method = '  ',
	Module = '  ',
	Operator = '  ',
	Property = '  ',
	Reference = '  ',
	Snippet = '  ',
	Struct = '  ',
	Text = '  ',
	TypeParameter = '  ',
	Unit = '  ',
	Value = '  ',
	Variable = '  ',
}

local function vscode()
	---@type HlDict
	local vscode_hls = {
		-- gray
		CmpItemAbbrDeprecated = { bg = 'NONE', strikethrough = true, fg = '#808080' },
		-- blue
		CmpItemAbbrMatch = { bg = 'NONE', fg = '#569CD6' },
		CmpItemAbbrMatchFuzzy = { link = 'CmpIntemAbbrMatch' },
		-- light blue
		CmpItemKindVariable = { bg = 'NONE', fg = '#9CDCFE' },
		CmpItemKindInterface = { link = 'CmpItemKindVariable' },
		CmpItemKindText = { link = 'CmpItemKindVariable' },
		-- pink
		CmpItemKindFunction = { bg = 'NONE', fg = '#C586C0' },
		CmpItemKindMethod = { link = 'CmpItemKindFunction' },
		-- front
		CmpItemKindKeyword = { bg = 'NONE', fg = '#D4D4D4' },
		CmpItemKindProperty = { link = 'CmpItemKindKeyword' },
		CmpItemKindUnit = { link = 'CmpItemKindKeyword' },
	}

	for n, o in next, vscode_hls do
		hl(n, o)
	end
end

---@param entry cmp.Entry
---@param vim_item vim.CompletedItem
local function vscode_fmt(entry, vim_item)
	vim_item.kind = kind_codicons[vim_item.kind] or ''
	return vim_item
end

---@param entry cmp.Entry
---@param vim_item vim.CompletedItem
local function fmt(entry, vim_item)
	return LK.cmp_format({ with_text = false })(entry, vim_item)
end

---@type HlDict
local extra_hls = {
	PmenuSel = { bg = '#282C34', fg = 'NONE' },
	Pmenu = { fg = '#C5CDD9', bg = '#22252A' },

	CmpItemAbbrDeprecated = { fg = '#7E8294', bg = 'NONE', strikethrough = true },
	CmpItemAbbrMatch = { fg = '#82AAFF', bg = 'NONE', bold = true },
	CmpItemAbbrMatchFuzzy = { fg = '#82AAFF', bg = 'NONE', bold = true },
	CmpItemMenu = { fg = '#C792EA', bg = 'NONE', italic = true },

	CmpItemKindField = { fg = '#EED8DA', bg = '#B5585F' },
	CmpItemKindProperty = { fg = '#EED8DA', bg = '#B5585F' },
	CmpItemKindEvent = { fg = '#EED8DA', bg = '#B5585F' },

	CmpItemKindText = { fg = '#C3E88D', bg = '#9FBD73' },
	CmpItemKindEnum = { fg = '#C3E88D', bg = '#9FBD73' },
	CmpItemKindKeyword = { fg = '#C3E88D', bg = '#9FBD73' },

	CmpItemKindConstant = { fg = '#FFE082', bg = '#D4BB6C' },
	CmpItemKindConstructor = { fg = '#FFE082', bg = '#D4BB6C' },
	CmpItemKindReference = { fg = '#FFE082', bg = '#D4BB6C' },

	CmpItemKindFunction = { fg = '#EADFF0', bg = '#A377BF' },
	CmpItemKindStruct = { fg = '#EADFF0', bg = '#A377BF' },
	CmpItemKindClass = { fg = '#EADFF0', bg = '#A377BF' },
	CmpItemKindModule = { fg = '#EADFF0', bg = '#A377BF' },
	CmpItemKindOperator = { fg = '#EADFF0', bg = '#A377BF' },

	CmpItemKindVariable = { fg = '#C5CDD9', bg = '#7E8294' },
	CmpItemKindFile = { fg = '#C5CDD9', bg = '#7E8294' },

	CmpItemKindUnit = { fg = '#F5EBD9', bg = '#D4A959' },
	CmpItemKindSnippet = { fg = '#F5EBD9', bg = '#D4A959' },
	CmpItemKindFolder = { fg = '#F5EBD9', bg = '#D4A959' },

	CmpItemKindMethod = { fg = '#DDE5F5', bg = '#6C8ED4' },
	CmpItemKindValue = { fg = '#DDE5F5', bg = '#6C8ED4' },
	CmpItemKindEnumMember = { fg = '#DDE5F5', bg = '#6C8ED4' },

	CmpItemKindInterface = { fg = '#D8EEEB', bg = '#58B5A8' },
	CmpItemKindColor = { fg = '#D8EEEB', bg = '#58B5A8' },
	CmpItemKindTypeParameter = { fg = '#D8EEEB', bg = '#58B5A8' },
}

---@type CmpKindMod
local M = {
	---@protected
	kind_icons = kind_icons,
	kind_codicons = kind_codicons,
	formatting = {
		expandable_indicator = true,
		fields = { 'abbr', 'kind', 'menu' },
		format = fmt,
	},
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
	},
	view = {
		entries = { name = 'custom', selection_order = 'top_down' },
		docs = { auto_open = true },
	},
	vscode = vscode,
	extra_hls = extra_hls,
}

function M.hilite()
	for n, o in next, M.extra_hls do
		hl(n, o)
	end
end

return M
