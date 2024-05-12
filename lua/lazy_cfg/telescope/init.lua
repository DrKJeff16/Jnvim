---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local kmap = User.maps.kmap

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local nmap = kmap.n

if not exists('telescope') then
	return
end

local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
		layout_config = { vertical = { width = 0.80 } },
		mappings = {
			i = {
				['<C-h>'] = 'which_key',
				['<C-u>'] = false,
				['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
				['<ESC>'] = Actions.close,
				['<C-e>'] = Actions.close,
				['<C-q>'] = Actions.close,
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

Telescope.setup(opts)

local function open()
	vim.cmd('Telescope')
end

---@type KeyMapModeDict
local maps = {
	n = {
		{ lhs = '<leader>ff',       rhs = Builtin.find_files,           opts = { desc = 'File Picker' } },
		{ lhs = '<leader><leader>', rhs = open,                         opts = { desc = 'Open Telescope' } },
		{ lhs = '<leader>fTT',      rhs = open,                         opts = { desc = 'Open Telescope' } },
		{ lhs = '<leader>fTbP',     rhs = Builtin.planets,              opts = { desc = 'Planets' } },
		{ lhs = '<leader>fTbb',     rhs = Builtin.buffers,              opts = { desc = 'Buffers' } },
		{ lhs = '<leader>fTbc',     rhs = Builtin.colorscheme,          opts = { desc = 'Colorschemes' } },
		{ lhs = '<leader>fTbd',     rhs = Builtin.diagnostics,          opts = { desc = 'Diagnostics' } },
		{ lhs = '<leader>fTbf',     rhs = Builtin.find_files,           opts = { desc = 'File Picker' } },
		{ lhs = '<leader>fTbg',     rhs = Builtin.live_grep,            opts = { desc = 'Live Grep' } },
		{ lhs = '<leader>fTbh',     rhs = Builtin.help_tags,            opts = { desc = 'Help Tags' } },
		{ lhs = '<leader>fTbk',     rhs = Builtin.keymaps,              opts = { desc = 'Keymaps' } },
		{ lhs = '<leader>fTblD',    rhs = Builtin.lsp_document_symbols, opts = { desc = 'Document Symbols' } },
		{ lhs = '<leader>fTbld',    rhs = Builtin.lsp_definitions,      opts = { desc = 'Definitions' } },
		{ lhs = '<leader>fTbp',     rhs = Builtin.pickers,              opts = { desc = 'Pickers' } },
	},
}

---@type AuRepeat
local au_tbl = {
	['User'] = {
		{
			pattern = 'TelescopePreviewerLoaded',

			---@type fun(args: TelAuArgs)
			callback = function(args)
				if not is_tbl(args.data) or not is_str(args.data.filetype) or args.data.filetype ~= 'help' then
					vim.wo.number = true
				else
					vim.wo.wrap = false
				end
			end,
		},
	},
}

---@type table<string, TelExtension>
local known_exts = {
	['scope'] = {
		'scope',
	},
	['project_nvim'] = {
		'projects',
		---@type fun(): KeyMapArgs[]
		keys = function()
			local pfx = Extensions.projects

			---@type KeyMapArgs[]
			local res = {
				{ lhs = '<leader>fTep', rhs = pfx.projects, opts = { desc = 'Project Picker' } },
			}

			return res
		end,
	},
	['notify'] = {
		'notify',
		---@type fun(): KeyMapArgs[]
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

--- Load and Set Keymaps for available extensions.
for mod, ext in next, known_exts do
	load_ext(ext[1])
	if not is_nil(ext.keys) then
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

for event, v in next, au_tbl do
	for _, au_opts in next, v do
		au(event, au_opts)
	end
end
