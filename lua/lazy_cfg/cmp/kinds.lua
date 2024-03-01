---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

local t = require('cmp.types')
local Config = require('cmp').config

local pfx = 'lazy_cfg.cmp.'

local hi = vim.api.nvim_set_hl

local M = {}

M.lspkind = (exists('lspkind') and require('lspkind') or nil)

M.formatting = {
	fields = { 'kind', 'menu', 'abbr' }
}

M.window = {
	-- completion = Config.window.bordered(),
	documentation = Config.window.bordered(),
	completion = Config.window.bordered(),

}

---@param toggle? boolean
function M:setup(toggle)
	toggle = toggle or false

	if toggle and self.lspkind() then
		self.fields = { 'kind', 'abbr', 'menu' }
		self.window.completion = {
			completion = {
				winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
				col_offset = -3,
				side_padding = 0,
			},
		}
		self.formatting.fortmat = function(entry, vim_item)
			local kind = self.lspkind().cmp_format({
				with_text = false,
				mode = 'symbol_text',
				maxwidth = 20,
			})(entry, vim_item)
			local strings = vim.split(kind.kind, '%s', { trimempty = true })
			kind.kind = ' ' .. (strings[1] or '') .. ' '
			kind.menu = '    (' .. (strings[2] or '') .. ')'
			-- Customization for Pmenu
			hi(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
			hi(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

			hi(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
			hi(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
			hi(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
			hi(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

			hi(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
			hi(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
			hi(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

			hi(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
			hi(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
			hi(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

			hi(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
			hi(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
			hi(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

			hi(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
			hi(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
			hi(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
			hi(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
			hi(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

			hi(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
			hi(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

			hi(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
			hi(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
			hi(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

			hi(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hi(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hi(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

			hi(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
			hi(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
			hi(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })
			-- gray
			hi(0, 'CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
			-- -- blue
			hi(0, 'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
			hi(0, 'CmpItemAbbrMatchFuzzy', { link='CmpIntemAbbrMatch' })
			-- -- light blue
			hi(0, 'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
			hi(0, 'CmpItemKindInterface', { link='CmpItemKindVariable' })
			hi(0, 'CmpItemKindText', { link='CmpItemKindVariable' })
			-- -- pink
			hi(0, 'CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
			hi(0, 'CmpItemKindMethod', { link='CmpItemKindFunction' })
			-- -- front
			hi(0, 'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
			hi(0, 'CmpItemKindProperty', { link='CmpItemKindKeyword' })
			hi(0, 'CmpItemKindUnit', { link='CmpItemKindKeyword' })
			return kind
		end
	end
end

function M:new()
	return setmetatable({}, self)
end

return M
