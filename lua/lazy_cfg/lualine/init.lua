---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

if not exists('lualine') then
	return
end

local Lualine = require('lualine')

---@type fun(theme: string?, force_auto: boolean?): string
local function theme_select(theme, force_auto)
	theme = (is_str(theme) and not empty(theme)) and theme or 'auto'

	force_auto = is_bool(force_auto) and force_auto or false

	-- If `auto` theme and permitted to select from fallbacks.
	-- Keep in mind these fallbacks are the same strings as their `require()` module strings.
	if theme == 'auto' and not force_auto then
		for _, t in next, { 'nightfox', 'onedark', 'catppuccin', 'tokyonight' } do
			if exists(t) then
				theme = t
				break -- Be contempt with the first theme you find
			end
		end
	end

	return theme
end

local Opts = {
	options = {
		icons_enabled = true,
		theme = theme_select('nightfox', true),
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

				--- Return the first letter of mode.
				--- e.g. `NORMAL` ==> `N`
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
				sources = { 'nvim_lsp' },
				sections = { 'error', 'warn' },
				diagnostics_color = {
					error = 'DiagnosticError',
					warn = 'DiagnosticWarn',
					info = 'DiagnosticInfo',
					hint = 'DiagnosticHint',
				},
				symbols = {
					error = '󰅚 ',
					hint = '󰌶 ',
					info = ' ',
					warn = '󰀪 ',
				},
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
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { 'filename' },
		lualine_c = {},
		lualine_x = { 'filetype' },
		lualine_y = {},
		lualine_z = { 'location' },
	},
	inactive_tabline = {},
	inactive_winbar = {},

	extensions = {
		'fugitive',
		'man',
	},
}

if exists('lazy') then
	table.insert(Opts.extensions, 'lazy')
end
if exists('nvim-tree') then
	table.insert(Opts.extensions, 'nvim-tree')
end
if exists('toggleterm') then
	table.insert(Opts.extensions, 'toggleterm')
end

Lualine.setup(Opts)
