---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.autocmd')

local User = require('user')
local exists = User.exists

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
			vertical = { width = 0.5 },
		},
		mappings = {
			i = {
				['<C-h>'] = 'which_key',
				['<C-u>'] = false,
				['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
				['<esc>'] = Actions.close,
			},
		},
	},
	pickers = {
		colorscheme = { theme = 'dropdown' },
		find_files = { theme = 'dropdown' },
		lsp_definitions = { theme = 'dropdown' },
		pickers = { theme = 'dropdown' },
	},
}

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun(): any
---@field opts? KeyMapOpts

---@class KeyMapModeDict
---@field n KeyMapArgs[]
local maps = {
	n = {
		{ lhs = '<leader>fTbP', rhs = Builtin.planets },
		{ lhs = '<leader>fTbb', rhs = Builtin.buffers },
		{ lhs = '<leader>fTbc', rhs = Builtin.colorscheme },
		{ lhs = '<leader>fTbd', rhs = Builtin.diagnostics },
		{ lhs = '<leader>fTbf', rhs = Builtin.find_files },
		{ lhs = '<leader>fTbg', rhs = Builtin.live_grep },
		{ lhs = '<leader>fTbh', rhs = Builtin.help_tags },
		{ lhs = '<leader>fTbk', rhs = Builtin.keymaps },
		{ lhs = '<leader>fTblD', rhs = Builtin.lsp_document_symbols },
		{ lhs = '<leader>fTbld', rhs = Builtin.lsp_definitions },
		{ lhs = '<leader>fTbp', rhs = Builtin.pickers },

		{ lhs = '<leader>fTeN', rhs = Extensions.notify.notify },
	},
}

---@class TelAuData
---@field title? string
---@field filetype? string
---@field bufname? string

---@class TelAuArgs
---@field data? TelAuData

---@type AuPair[]
local au_tbl = {
	{
		event = 'User',
		opts = {
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
	['project_nvim'] = {
		'projects',
		---@return KeyMapArgs[]
		keys = function()
			local pfx = Extensions.projects
			return {
				{ lhs = '<leader>fTep', rhs = pfx.projects },
			}
		end,
	},
	['notify'] = {
		'notify',
		---@return KeyMapArgs[]
		keys = function()
			local pfx = Extensions.notify
			return {
				{ lhs = '<leader>fTeN', rhs = pfx.notify },
			}
		end,
	},
}

Telescope.setup(opts)

for mod, ext in next, known_exts do
	if exists(mod) then
		load_ext(ext[1])
		for _, v in next, ext.keys() do
			table.insert(maps.n, v)
		end
	end
end

for mode, m in next, maps do
	for _, v in next, m do
		kmap[mode](v.lhs, v.rhs, v.opts or {})
	end
end

for _, t in next, au_tbl do
	au(t.event, t.opts)
end
