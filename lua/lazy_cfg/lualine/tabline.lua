---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('lualine') then
	return
end

---@class TabLine.Comps.Diag.Spec
---@field error? any
---@field warn? any
---@field info? any
---@field hint? any

---@class TabLine.Comps.Diag.Src: TabLine.Comps.Diag.Spec
---@field error? integer
---@field warn? integer
---@field info? integer
---@field hint? integer

---@alias DiagOpt ('nvim_lsp'|'nvim_diagnostic'|'nvim_workspace_diagnostic'|'coc'|'ale'|'vim_lsp')[]|fun(): TabLine.Comps.Diag.Src
--
---@alias DiagLvls ('error'|'warn'|'info'|'hint')[]

---@class TabLine.Comps.Diag.Colors: TabLine.Comps.Diag.Spec
---@field error? string
---@field warn? string
---@field info? string
---@field hint? string

---@class TabLine.Comps.Diag.Symbols: TabLine.Comps.Diag.Colors

---@class TabLine.Comps.Spec
---@field icons_enabled? boolean

---@class TabLine.Comps.Buffer: TabLine.Comps.Spec
---@class TabLine.Comps.DateTime: TabLine.Comps.Spec
---@class TabLine.Comps.Diag: TabLine.Comps.Spec

---@class TabLine.Comps.Buffer.Colors
---@field active? string
---@field inactive? string

---@class TabLine.Comps.Buffer.Symbols
---@field modified? string
---@field alternate_file? string
---@field directory? string

---@class TabLine.Comps
---@field basic? TabLine.Comps.Spec
---@field buffers? TabLine.Comps.Buffer
---@field datetime? TabLine.Comps.DateTime
---@field diagnostics? TabLine.Comps.Diag

---@class TabLine
---@field components TabLine.Comps
---@field public new fun(): TabLine
---@field protected __index? TabLine
---@field public __call fun(self: TabLine)

---@class TabLine.Comps.Diff.Colors
---@field added? string
---@field modified? string
---@field removed? string

---@class TabLine.Comps.Diff.Symbols: TabLine.Comps.Diff.Colors
---@field added? integer
---@field modified? integer
---@field removed? integer

---@alias Tabline.Comps.DateTime.style 'default'|'us'|'uk'|'iso'|string

---@class TabLine.Comps.Diff.Src: TabLine.Comps.Diff.Colors

---@type TabLine
local M = {}

---@type TabLine.Comps
M.components = {
	basic = {
		icons_enabled = true,

		icon = nil,
		separator = nil,
		cond = nil,

		draw_empty = false,

		color = nil,

		---@type 'lua_expr'|'vim_fun'|nil
		type = nil,

		---@type nil|fun(...): any
		on_click = nil,
	},
	buffers = {
		show_filename_only = true,   -- Shows shortened relative path when set to false.
		hide_filename_extension = false,   -- Hide filename extension when set to true.
		show_modified_status = true, -- Shows indicator when the buffer is modified.

		-- - 0: Buffer name
		-- - 1: Buffer index
		-- - 2: Buffer name + buffer index
		-- - 3: Buffer number
		-- - 4: Buffer name + buffer number
		---@type 0|1|2|3|4
		mode = 0,

		-- Maximum width of buffers component,
		-- it can also be a function that returns
		-- the value of `max_length` dynamically.
		---@type number
		max_length = vim.o.columns * 2 / 3,

		-- Shows specific buffer name for that filetype ( `{ `filetype` = `buffer_name`, ... }` )
		---@type table<string, string>
		filetype_names = {
			TelescopePrompt = 'Telescope',
			dashboard = 'Dashboard',
			packer = 'Packer',
			fzf = 'FZF',
			alpha = 'Alpha'
		},

		-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
		---@type boolean
		use_mode_colors = false,

		---@type TabLine.Comps.Buffer.Colors
		buffers_color = {
			-- Same values as the general color option can be used here.
			active = 'lualine_{section}_normal',     -- Color for active buffer.
			inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
		},

		---@type TabLine.Comps.Buffer.Symbols
		symbols = {
			modified = ' ●',      -- Text to show when the buffer is modified
			alternate_file = '#', -- Text to show to identify the alternate file
			directory =  '',     -- Text to show when the buffer is a directory
		},
	},

	datetime = {
		---@type Tabline.Comps.DateTime.style
		style = 'dk'
	},

	---@type TabLine.Comps.Diag
	diagnostics = {
		-- Table of diagnostic sources, available sources are:
		--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
		-- or a function that returns a table as such:
		--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
		---@type DiagOpt
		sources = {
			'nvim_lsp',
			'nvim_diagnostic',
			'nvim_workspace_diagnostic'
		},

		-- Displays diagnostics for the defined severity types
		---@type DiagLvls
		sections = {
			'error',
			'warn',
		},

		---@type TabLine.Comps.Diag.Colors
		diagnostics_color = {
			-- Same values as the general color option can be used here.
			error = 'DiagnosticError', -- Changes diagnostics' error color.
			warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
			info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
			hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
		},

		---@type TabLine.Comps.Diag.Symbols
		symbols = {
			error = 'E',
			warn = 'W',
			info = 'I',
			hint = 'H',
		},

		colored = true,           -- Displays diagnostics status in color if set to true.
		update_in_insert = false, -- Update diagnostics in insert mode.
		always_visible = false,   -- Show diagnostics even if there are none.
	},

	diff = {
		colored = true, -- Displays a colored diff status if set to true

		---@type TabLine.Comps.Diff.Colors
		diff_color = {
			-- Same color values as the general color option can be used here.
			added    = 'LuaLineDiffAdd',    -- Changes the diff's added color
			modified = 'LuaLineDiffChange', -- Changes the diff's modified color
			removed  = 'LuaLineDiffDelete', -- Changes the diff's removed color you
		},
		---@type TabLine.Comps.Diff.Symbols
		symbols = {
			added = '+',
			modified = '~',
			removed = '-',
		}, -- Changes the symbols used by the diff.
		---@type TqbLine.Comps.Diff.Src|nil
		source = nil, -- A function that works as a data source for diff.
		-- It must return a table as such:
		--   { added = add_count, modified = modified_count, removed = removed_count }
		-- or nil on failure. count <= 0 won't be displayed.
	},

	fileformat = {
		symbols = {
			unix = '', -- e712
			dos = '',  -- e70f
			mac = '',  -- e711
		},
	},

	filename = {
		file_status = true,      -- Displays file status (readonly status, modified status)
		newfile_status = false,  -- Display new file status (new file means no write after created)
		path = 0,                -- 0: Just the filename
		-- 1: Relative path
		-- 2: Absolute path
		-- 3: Absolute path, with tilde as the home directory
		-- 4: Filename and parent dir, with tilde as the home directory

		shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
		-- for other components. (terrible name, any suggestions?)
		symbols = {
			modified = '[+]',      -- Text to show when the file is modified.
			readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
			unnamed = '[No Name]', -- Text to show for unnamed buffers.
			newfile = '[New]',     -- Text to show for newly created file before first write
		}
	},

	filetype = {
		colored = true,   -- Displays filetype icon in color if set to true
		icon_only = false, -- Display only an icon for filetype
		icon = { align = 'right' }, -- Display filetype icon on the right hand side
		-- icon =    {'X', align='right'}
		-- Icon string ^ in table is ignored in filetype component
	},

	searchcount = {
		maxcount = 999,
		timeout = 500,
	},

	tabs = {
		tab_max_length = 40,  -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
		max_length = vim.o.columns / 3, -- Maximum width of tabs component.
		-- Note:
		-- It can also be a function that returns
		-- the value of `max_length` dynamically.
		mode = 0, -- 0: Shows tab_nr
		-- 1: Shows tab_name
		-- 2: Shows tab_nr + tab_name

		path = 0, -- 0: just shows the filename
		-- 1: shows the relative path and shorten $HOME to ~
		-- 2: shows the full path
		-- 3: shows the full path and shorten $HOME to ~

		-- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
		use_mode_colors = false,

		tabs_color = {
			-- Same values as the general color option can be used here.
			active = 'lualine_{section}_normal',     -- Color for active tab.
			inactive = 'lualine_{section}_inactive', -- Color for inactive tab.
		},

		show_modified_status = true,  -- Shows a symbol next to the tab name if the file has been modified.
		symbols = {
			modified = '[+]',  -- Text to show when the file is modified.
		},

		fmt = function(name, context)
			-- Show + if buffer is modified in tab
			local buflist = vim.fn.tabpagebuflist(context.tabnr)
			local winnr = vim.fn.tabpagewinnr(context.tabnr)
			local bufnr = buflist[winnr]
			local mod = vim.fn.getbufvar(bufnr, '&mod')

			return name .. (mod == 1 and ' +' or '')
		end,
	},

	windows = {
		show_filename_only = true,   -- Shows shortened relative path when set to false.
		show_modified_status = true, -- Shows indicator when the window is modified.

		mode = 0, -- 0: Shows window name
		-- 1: Shows window index
		-- 2: Shows window name + window index

		max_length = vim.o.columns * 2 / 3, -- Maximum width of windows component,
		-- it can also be a function that returns
		-- the value of `max_length` dynamically.
		filetype_names = {
			TelescopePrompt = 'Telescope',
			dashboard = 'Dashboard',
			packer = 'Packer',
			fzf = 'FZF',
			alpha = 'Alpha'
		}, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

		disabled_buftypes = { 'quickfix', 'prompt' }, -- Hide a window if its buffer's type is disabled

		-- Automatically updates active window color to match color of other components (will be overidden if buffers_color is set)
		use_mode_colors = false,

		windows_color = {
			-- Same values as the general color option can be used here.
			active = 'lualine_{section}_normal',     -- Color for active window.
			inactive = 'lualine_{section}_inactive', -- Color for inactive window.
		},
	},
}

M.sections = {
	active = {
    	lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
	},
	inactive = {
    	lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
	},
}

function M.new()
	local self = setmetatable({}, { __index = M })
	self.components = {}
	for k, v in next, M.components do
		self.components[k] = v
	end

	self.sections = M.sections

	return self
end

---@param self 
function M:__call()
end

return M
