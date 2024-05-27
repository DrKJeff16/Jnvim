---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local kmap = User.maps.kmap

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local nmap = kmap.n
local desc = kmap.desc

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

local Opts = {
	defaults = {
		layout_strategy = 'flex',
		layout_config = { vertical = { width = vim.opt.columns:get() * 3 / 4 } },
		mappings = {
			i = {
				['<C-h>'] = 'which_key',
				['<C-u>'] = false,
				['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
				['<Esc>'] = Actions.close,
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

Telescope.setup(Opts)

local function open()
	vim.cmd('Telescope')
end

---@type KeyMapDict
local Maps = {
	['<leader><leader>'] = { open, desc('Open Telescope') },
	['<leader>hH'] = { Builtin.help_tags, desc('Telescope Help Tags') },
	['<leader>ff'] = { Builtin.find_files, desc('File Picker') },

	['<leader>fTbC'] = { Builtin.commands, desc('Colommands') },
	['<leader>fTbO'] = { Builtin.keymaps, desc('Vim Options') },
	['<leader>fTbP'] = { Builtin.planets, desc('Planets') },
	['<leader>fTbb'] = { Builtin.buffers, desc('Buffers') },
	['<leader>fTbc'] = { Builtin.colorscheme, desc('Colorschemes') },
	['<leader>fTbd'] = { Builtin.diagnostics, desc('Diagnostics') },
	['<leader>fTbg'] = { Builtin.live_grep, desc('Live Grep') },
	['<leader>fTbk'] = { Builtin.keymaps, desc('Keymaps') },
	['<leader>fTblD'] = { Builtin.lsp_document_symbols, desc('Document Symbols') },
	['<leader>fTbld'] = { Builtin.lsp_definitions, desc('Definitions') },
	['<leader>fTbp'] = { Builtin.pickers, desc('Pickers') },
}

---@type table<string, TelExtension>
local known_exts = {
	['scope'] = { 'scope' },
	['project_nvim'] = {
		'projects',
		---@type fun(): KeyMapDict
		keys = exists('project_nvim') and function()
			if is_nil(Extensions.projects) then
				return {}
			end

			local pfx = Extensions.projects

			---@type KeyMapDict
			local res = {
				['<leader>fTep'] = { pfx.projects, desc('Project Picker') },
			}

			return res
		end,
	},
	['notify'] = {
		'notify',
		---@type fun(): KeyMapDict
		keys = exists('notify') and function()
			local pfx = Extensions.notify

			---@type KeyMapDict
			local res = {
				['<leader>fTeN'] = { pfx.notify, desc('Notify Picker') },
			}

			return res
		end,
	},
	['noice'] = {
		'noice',
		---@type fun(): KeyMapDict
		keys = exists('noice') and function()
			local Noice = require('noice')

			---@type KeyMapDict
			local res = {
				['<leadec>nl'] = {
					function()
						Noice.cmd('last')
					end,
					desc('NoiceLast'),
				},
				['<leadec>nh'] = {
					function()
						Noice.cmd('history')
					end,
					desc('NoiceHistory'),
				},
			}

			return res
		end,
	},
}

--- Load and Set Keymaps for available extensions.
for mod, ext in next, known_exts do
	if not (exists(mod) and is_str(ext[1])) then
		goto continue
	end

	load_ext(ext[1])

	if is_fun(ext.keys) then
		for lhs, v in next, ext.keys() do
			Maps[lhs] = v
		end
	end

	::continue::
end

for lhs, v in next, Maps do
	if not (is_str(lhs) and is_fun(v[1])) then
		goto continue
	end

	v[2] = is_tbl(v[2]) and v[2] or {}
	nmap(lhs, v[1], v[2])

	::continue::
end

---@type AuRepeat
local au_tbl = {
	['User'] = {
		{
			pattern = 'TelescopePreviewerLoaded',

			---@type fun(args: TelAuArgs)
			callback = function(args)
				if not (is_tbl(args.data) and is_str(args.data.filetype) and args.data.filetype == 'help') then
					vim.wo.number = true
				else
					vim.wo.wrap = false
				end
			end,
		},
	},
}

for event, v in next, au_tbl do
	for _, au_opts in next, v do
		au(event, au_opts)
	end
end
