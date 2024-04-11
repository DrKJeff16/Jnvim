---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local maps_t = User.types.user.maps
local au_t = User.types.user.autocmd

if not exists('telescope') then
	return
end

local api = vim.api
local bo = vim.bo
local wo = vim.wo
local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local kmap = User.maps.kmap
local nmap = kmap.n

local Telescope = require('telescope')
local Builtin = require('telescope.builtin')
local Themes = require('telescope.themes')
local Actions = require('telescope.actions')
local ActionLayout = require('telescope.actions.layout')
local Extensions = Telescope.extensions

local load_ext = Telescope.load_extension

local opts = {
	defaults = {
		layout_strategy = 'flex',
		layout_config = {
			vertical = { width = 0.85 },
		},
		mappings = {
			i = {
				['<C-h>'] = 'which_key',
				['<C-u>'] = false,
				['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
				['<ESC>'] = Actions.close,
				['<C-e>'] = Actions.close,
			},
		},
	},
	pickers = {
		colorscheme = { theme = 'dropdown' },
		find_files = { theme = 'dropdown' },
		lsp_definitions = { theme = 'dropdown' },
		pickers = { theme = 'dropdown' },
		notify = { theme = 'dropdown' },
	},
}

local function open()
	vim.cmd('Telescope')
end

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun(): any
---@field opts? KeyMapOpts

---@class KeyMapModeDict
---@field n KeyMapArgs[]
local maps = {
	n = {
		{ lhs = '<leader><leader>', rhs = open, opts = { desc = 'Open Telescope' } },
		{ lhs = '<leader>fTbP', rhs = Builtin.planets, opts = { desc = 'Planets' } },
		{ lhs = '<leader>fTbb', rhs = Builtin.buffers },
		{ lhs = '<leader>fTbc', rhs = Builtin.colorscheme, opts = { desc = 'Colorschemes' } },
		{ lhs = '<leader>fTbd', rhs = Builtin.diagnostics, opts = { desc = 'Diagnostics' } },
		{ lhs = '<leader>fTbf', rhs = Builtin.find_files, opts = { desc = 'File Picker' } },
		{ lhs = '<leader>fTbg', rhs = Builtin.live_grep, opts = { desc = 'Live Grep' } },
		{ lhs = '<leader>fTbh', rhs = Builtin.help_tags, opts = { desc = 'Help Tags' } },
		{ lhs = '<leader>fTbk', rhs = Builtin.keymaps, opts = { desc = 'Keymaps' } },
		{ lhs = '<leader>fTblD', rhs = Builtin.lsp_document_symbols, opts = { desc = 'Document Symbols' } },
		{ lhs = '<leader>fTbld', rhs = Builtin.lsp_definitions, opts = { desc = 'Definitions' } },
		{ lhs = '<leader>fTbp', rhs = Builtin.pickers, opts = { desc = 'Pickers' } },
	},
}

---@class TelAuData
---@field title? string
---@field filetype? string
---@field bufname? string

---@class TelAuArgs
---@field data? TelAuData

---@type AuRepeat
local au_tbl = {
	['User'] = {
		{
			pattern = 'TelescopePreviewerLoaded',
			---@param args TelAuArgs
			callback = function(args)
				if not args.data or not args.data.filetype or args.data.filetype ~= 'help' then
					wo.number = true
				else
					wo.wrap = false
				end
			end,
		},
	},
}

---@class TelExtension
---@field [1] string
---@field keys? fun(...): KeyMapArgs[]

---@type table<string, TelExtension>
local known_exts = {
	['scope'] = {
		'scope',
	},
	['project_nvim'] = {
		'projects',
		---@return KeyMapArgs[]
		keys = function()
			local pfx = Extensions.projects
			return {
				{ lhs = '<leader>fTep', rhs = pfx.projects, opts = { desc = 'Project Picker' } },
			}
		end,
	},
	['notify'] = {
		'notify',
		---@return KeyMapArgs[]
		keys = function()
			local pfx = Extensions.notify

			---@type KeyMapArgs[]
			local res = {
				{ lhs = '<leader>fTeN', rhs = pfx.notify, opts = { desc = 'Notify Picker' } },
			}

			return res
		end,
	},
}

Telescope.setup(opts)

--- Load and Set Keymaps for available extensions.
for mod, ext in next, known_exts do
	if exists(mod) then
		load_ext(ext[1])

		if ext.keys then
			for _, v in next, ext.keys() do
				table.insert(maps.n, v)
			end
		end
	end
end

for mode, m in next, maps do
	for _, v in next, m do
		kmap[mode](v.lhs, v.rhs, v.opts or {})
	end
end

for event, v in next, au_tbl do
	for _, au_opts in next, v do
		au(event, au_opts)
	end
end
