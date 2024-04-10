---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('lualine') then
	return
end

local Lualine = require('lualine')

Lualine.setup({
	options = {
		icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
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
				---@param str string
				---@return string
				fmt = function(str)
					return str:sub(1,1)
				end,
			},
        },
        lualine_b = {},
        lualine_c = {},
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
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {}
    },
    tabline = {
		lualine_a = { 'tabs' },
		lualine_b = {
			'buffers'
		},
		lualine_c = { 'branch' },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {{
			'datetime',
			style = 'uk'
		}},
    },
    winbar = {
		lualine_a = {{
			'diff',
			colored = true,
			diff_color = {
				-- Same color values as the general color option can be used here.
				added    = 'LuaLineDiffAdd',    -- Changes the diff's added color
				modified = 'LuaLineDiffChange', -- Changes the diff's modified color
				removed  = 'LuaLineDiffDelete', -- Changes the diff's removed color you
			},
			symbols = {added = '+', modified = '~', removed = '-'}, -- Changes the symbols used by the diff.
		}},
		lualine_b = {
			{
				'filename',
				file_status = true,
				newfile_status = true,
				path = 4,
				shorting_target = 15,
				symbold = {
					modified = '[+]',
					readonly = '[RO]',
					unnamed = '[NONAME]',
					newfile = '[NEW]'
				},
			},
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{
				'diagnostics',
				sources = { 'nvim_lsp' },
				sections = { 'error', 'warn' },
				symbols = {
					error = 'E',
					warn = 'W',
					info = 'I',
					hint = '?'
				},
			},
		},
		lualine_z = {},
    },
    inactive_winbar = {
		lualine_a = {},
		lualine_b = {
			{
				'filename',
				file_status = true,
				newfile_status = true,
				path = 4,
				shorting_target = 15,
				symbold = {
					modified = '[+]',
					readonly = '[RO]',
					unnamed = '[NONAME]',
					newfile = '[NEW]'
				},
			},
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { 'progress' },
		lualine_z = {},
    },
    extensions = {}
})
