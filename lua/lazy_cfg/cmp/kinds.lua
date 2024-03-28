---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

local t = require('cmp.types')
local Config = require('cmp').config

require('cmp.types')
require('cmp.types.cmp')

local pfx = 'lazy_cfg.cmp.'

local api = vim.api

local hi = api.nvim_set_hl

---@alias HlTbl vim.api.keyset.highlight

---@param name string
---@param tbl HlTbl
local hl = function(name, tbl)
	hi(0, name, tbl)
end

local M = {}

M.lspkind = require('lspkind')

M.formatting = {
	fields = { 'kind', 'menu', 'abbr' }
}

M.window = {
	documentation = Config.window.bordered(),
	completion = Config.window.bordered(),
}

---@param toggle? boolean
function M.setup(toggle)
	toggle = toggle or false

	local res = {
		lspkind = M.lspkind,
		window = M.window,
		formatting = M.formatting,
	}

	if toggle then
		res.window.completion = {
			completion = {
				winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
				col_offset = -3,
				side_padding = 0,
			},
		}

		res.formatting.fields = { 'kind', 'abbr', 'menu' }
		res.formatting.fortmat = function(entry, vim_item)
			local kind = M.lspkind().cmp_format({
				with_text = false,
				mode = 'symbol_text',
				maxwidth = 20,
			})(entry, vim_item)
			local strings = vim.split(kind.kind, '%s', { trimempty = true })
			kind.kind = ' ' .. (strings[1] or '') .. ' '
			kind.menu = '    (' .. (strings[2] or '') .. ')'
			-- Customization for Pmenu
			hl("PmenuSel", { bg = "#282C34", fg = "NONE" })
			hl("Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

			hl("CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
			hl("CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
			hl("CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
			hl("CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

			hl("CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
			hl("CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
			hl("CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

			hl("CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
			hl("CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
			hl("CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

			hl("CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
			hl("CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
			hl("CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

			hl("CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
			hl("CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
			hl("CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
			hl("CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
			hl("CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

			hl("CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
			hl("CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

			hl("CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
			hl("CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
			hl("CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

			hl("CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hl("CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hl("CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

			hl("CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
			hl("CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
			hl("CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })
			-- gray
			hl('CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
			-- -- blue
			hl('CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
			hl('CmpItemAbbrMatchFuzzy', { link='CmpIntemAbbrMatch' })
			-- -- light blue
			hl('CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
			hl('CmpItemKindInterface', { link='CmpItemKindVariable' })
			hl('CmpItemKindText', { link='CmpItemKindVariable' })
			-- -- pink
			hl('CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
			hl('CmpItemKindMethod', { link='CmpItemKindFunction' })
			-- -- front
			hl('CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
			hl('CmpItemKindProperty', { link='CmpItemKindKeyword' })
			hl('CmpItemKindUnit', { link='CmpItemKindKeyword' })
			return kind
		end
	end

	return res
end

return M
