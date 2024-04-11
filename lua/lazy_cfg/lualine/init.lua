---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('lualine') then
	return
end

local Lualine = require('lualine')

local Winbar = require('lazy_cfg.lualine.winbar')
local Tabline = require('lazy_cfg.lualine.tabline')

Lualine.setup({
	options = {
		icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {
				'checkhealth',
				'lazy',
				'help',
            },
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
        lualine_b = {
        	{
        		'buffers',
        		show_filename_only = true,
        		hide_filename_extension = false,
        		mode = 2,
        		max_length = vim.o.columns * 1 / 3,
				filetype_names = {
					TelescopePrompt = 'Telescope',
					dashboard = 'Dashboard',
					packer = 'Packer',
					fzf = 'FZF',
					alpha = 'Alpha'
				}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

				use_mode_colors = false,
				symbols = {
					modified = ' ●',      -- Text to show when the buffer is modified
					alternate_file = '#', -- Text to show to identify the alternate file
					directory =  '',     -- Text to show when the buffer is a directory
				},

        	},
        },
        lualine_c = {},
        lualine_x = {
			'fileformat',
			'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
    	lualine_a = {},
        lualine_b = { 'buffers' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'windows'},
        lualine_z = {}
    },
    tabline = {
		lualine_a = {
			{
				'tabs',
				tab_max_length = vim.o.columns * 2 / 3,
				mode = 0,
				path = 0,
				use_mode_colors = false,
				show_modified_status = true,
				symbols = {
					modified = '[+]',
				},

				fmt = function(name, context)
					-- Show + if buffer is modified in tab
					local buflist = vim.fn.tabpagebuflist(context.tabnr)
					local winnr = vim.fn.tabpagewinnr(context.tabnr)
					local bufnr = buflist[winnr]
					local mod = vim.fn.getbufvar(bufnr, '&mod')

					return name .. (mod == 1 and ' +' or '')
				end
			},
		},
		lualine_b = { 'branch' },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{
				'windows',
				show_filename_only = true,
				show_modified_status = true,

			},
		},
		lualine_z = {},
    },
    winbar = {},
    inactive_winbar = {},

    extensions = {
		'lazy',
		'fugitive',
		'man',
		'nvim-tree',
		'symbols-outline',
		'toggleterm',
    },
})
