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
		for _, t in next, { 'catppuccin', 'tokyonight' } do
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
        theme = theme_select(),
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
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
				---@type fun(str: string): string
				fmt = function(str)
					return str:sub(1,1)
				end,
			},
        },
        lualine_b = { 'filename' },
        lualine_c = { 'diagnostics' },
        lualine_x = {
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
        lualine_x = {},
        lualine_y = {'windows'},
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
