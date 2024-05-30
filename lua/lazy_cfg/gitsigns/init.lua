---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.gitsigns
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local is_num = Check.value.is_num
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local desc = kmap.desc

if not exists('gitsigns') or not executable('git') then
	return
end

local GS = require('gitsigns')

---@type table<MapModes, KeyMapDict>
local Keys = {
	n = {
		-- Navigation
		['<leader>G]c'] = {
			"&diff ? ']c' : '<CMD>Gitsigns next_hunk<CR>'",
			desc('Next Hunk', true, 0, true, true, true),
		},
		['<leader>G[c'] = {
			"&diff ? '[c' : '<CMD>Gitsigns prev_hunk<CR>'",
			desc('Previous Hunk', true, 0, true, true, true),
		},

		-- Actions
		['<leader>Ghs'] = { '<CMD>Gitsigns stage_hunk<CR>', desc('Stage Current Hunk') },
		['<leader>Ghr'] = { '<CMD>Gitsigns reset_hunk<CR>', desc('Reset Current Hunk') },
		['<leader>Ghu'] = { '<CMD>Gitsigns undo_stage_hunk<CR>', desc('Undo Hunk Stage') },
		['<leader>Ghp'] = { '<CMD>Gitsigns preview_hunk<CR>', desc('Preview Current Hunk') },
		['<leader>GhS'] = { '<CMD>Gitsigns stage_buffer<CR>', desc('Stage The Whole Buffer') },
		['<leader>GhR'] = { '<CMD>Gitsigns reset_buffer<CR>', desc('Reset The Whole Buffer') },
		['<leader>Ghb'] = {
			function()
				GS.blame_line({ full = true })
			end,
			desc('Blame Current Line'),
		},
		['<leader>Ghd'] = { '<CMD>Gitsigns diffthis<CR>', desc('Diff Against Index') },
		['<leader>GhD'] = {
			function()
				GS.diffthis('~')
			end,
			desc('Diff This'),
		},
		['<leader>Gtb'] = { '<CMD>Gitsigns toggle_current_line_blame<CR>', desc('Toggle Line Blame') },
		['<leader>Gtd'] = { '<CMD>Gitsigns toggle_deleted<CR>', desc('Toggle Deleted') },
	},
	v = {
		{ '<leader>Ghs', ':Gitsigns stage_hunk<CR>', desc('Stage Selected Hunk(s)') },
		{ '<leader>Ghr', ':Gitsigns reset_hunk<CR>', desc('Reset Selected Hunk(s)') },
	},
}
---@type table<MapModes, RegKeysNamed>
local Names = {
	n = {
		['<leader>G'] = { name = '+Gitsigns' },
		['<leader>Gh'] = { name = '+Hunks' },
		['<leader>Gt'] = { name = '+Toggles' },
		['<leader>G['] = { name = '+Previous Hunk' },
		['<leader>G]'] = { name = '+Next Hunk' },
	},
	v = {
		['<leader>G'] = { name = '+Gitsigns' },
		['<leader>Gh'] = { name = '+Hunks' },
	},
}

---@type GitSigns
local signs = {
	add = { text = '÷' },
	change = { text = '~' },
	delete = { text = '-' },
	topdelete = { text = 'X' },
	changedelete = { text = '≈' },
	untracked = { text = '┆' },
}

local opts = {
	---@type fun(bufnr: integer)
	on_attach = function(bufnr)
		bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

		for mode, t in next, Keys do
			if WK.available() then
				if is_tbl(Names[mode]) and not empty(Names[mode]) then
					WK.register(Names[mode], { mode = mode, buffer = bufnr })
				end

				WK.register(WK.convert_dict(t), { mode = mode, buffer = bufnr })
			else
				for lhs, v in next, t do
					v[2] = is_tbl(v[2]) and v[2] or {}
					v[2].buffer = bufnr

					kmap[mode](lhs, v[1], v[2])
				end
			end
		end
	end,

	signs = signs,

	signcolumn = vim.o.signcolumn == 'yes', -- Toggle with `:Gitsigns toggle_signs`
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = { follow_files = true },
	auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
		delay = 2000,
		ignore_whitespace = false,
		virt_text_priority = 10,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 10,
	update_debounce = 100,
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1,
	},
}

GS.setup(opts)
