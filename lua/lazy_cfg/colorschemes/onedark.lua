---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local empty = Check.value.empty

---@type ODSubMod
local M = {
	mod_pfx = 'lazy_cfg.colorschemes.onedark',
	mod_cmd = 'colorscheme onedark',
}

if exists('onedark') then
	function M.setup(style)
		local OD = require('onedark')

		if not is_str or not vim.tbl_contains(OD.styles_list, style) then
			style = 'deep'
		end

		---@type OD
		local opts = {
			style = style,
			transparent = false,
			term_colors = true,
			ending_tildes = true,
			cmp_itemkind_reverse = true,

			toggle_style_key = nil,
			toggle_style_list = { 'deep', 'warmer', 'darker' },

			code_style = {
				comments = 'altfont', -- Change the style of comments
				conditionals = 'bold',
				loops = 'bold',
				functions = 'bold',
				keywords = 'bold',
				strings = 'altfont',
				variables = 'altfont',
				numbers = 'altfont',
				booleans = 'bold',
				properties = 'bold',
				types = 'bold',
				operators = 'altfont',
				-- miscs = '', -- Uncomment to turn off hard-coded styles
			},

			lualine = { transparent = false },

			diagnostics = {
				darker = true,
				undercurl = true,
				background = true,
			},
		}

		OD.load()
	end
end

return M
