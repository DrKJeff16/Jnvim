---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str

if not exists('lualine') then
	return
end

local Lualine = require('lualine')

---@type fun(theme: string?): string
local function theme_select(theme)
	if not is_str(theme) then
		theme = 'auto'
	else
		theme = exists(theme) and theme or 'auto'
	end

	if theme == 'auto' then
		for _, t in next, { 'onedark', 'catppuccin', 'tokyonight' } do
			if exists(t) then
				theme = t
				break
			end
		end
	end

	return theme
end

Lualine.setup({
	options = {
		icons_enabled = true,
		theme = theme_select('tokyonight'),
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			{
				'mode',
				icons_enabled = true,
				---@type fun(str: string): string
				fmt = function(str)
					return str:sub(1, 1)
				end,
			},
		},
		lualine_b = {
			'branch',
			'filename',
		},
		lualine_c = {
			{
				'diagnostics',
				sources = { 'nvim_lsp', 'nvim_workspace_diagnostic' },
				sections = { 'error', 'warn' },
				diagnostics_color = {
					error = 'DiagnosticError',
					warn = 'DiagnosticWarn',
					info = 'DiagnosticInfo',
					hint = 'DiagnosticHint',
				},
				symbols = { error = 'E ', warn = 'W ', info = 'I ', hint = '? ' },
				colored = true,
				update_in_insert = false,
				always_visible = true,
			},
		},
		lualine_x = {
			'encoding',
			'fileformat',
			'filetype',
		},
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { 'filename' },
		lualine_c = {},
		lualine_x = { 'location' },
		lualine_y = { 'windows' },
		lualine_z = {}
	},
	inactive_tabline = {},
	inactive_winbar = {},

	extensions = {
		'lazy',
		'fugitive',
		'man',
		'nvim-tree',
		'toggleterm',
	},
})
