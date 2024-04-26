---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local maps_t = User.types.user.maps
local Check = User.check
local bufmap = User.maps.buf_map

local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_fun = Check.value.is_fun
local exists = Check.exists.module
local executable = Check.exists.executable

if not exists('gitsigns') or not executable('git') then
	return
end

local types = User.types.gitsigns

local Gsig = require('gitsigns')

---@type table<string, BufMapTbl[]|BufMapArr[]>
local keys = {
	n = {
		-- Navigati7on
		{ '<leader>G]c', "&diff ? ']c' : '<CMD>Gitsigns next_hunk<CR>'", { expr = true } },
		{ '<leader>G[c', "&diff ? '[c' : '<CMD>Gitsigns prev_hunk<CR>'", { expr = true } },
		-- Actions
		{ '<leader>Ghs', ':Gitsigns stage_hunk<CR>' },
		{ '<leader>Ghr', ':Gitsigns reset_hunk<CR>' },
		{ '<leader>GhS', '<CMD>Gitsigns stage_buffer<CR>' },
		{ '<leader>Ghu', '<CMD>Gitsigns undo_stage_hunk<CR>' },
		{ '<leader>GhR', '<CMD>Gitsigns reset_buffer<CR>' },
		{ '<leader>Ghp', '<CMD>Gitsigns preview_hunk<CR>' },
		{ '<leader>Ghb', '<CMD>lua require"gitsigns".blame_line{full=true}<CR>' },
		{ '<leader>Gtb', '<CMD>Gitsigns toggle_current_line_blame<CR>' },
		{ '<leader>Ghd', '<CMD>Gitsigns diffthis<CR>' },
		{ '<leader>GhD', '<CMD>lua require"gitsigns".diffthis("~")<CR>' },
		{ '<leader>Gtd', '<CMD>Gitsigns toggle_deleted<CR>' },
	},
	v = {
		{ '<leader>Ghs', ':Gitsigns stage_hunk<CR>' },
		{ '<leader>Ghr', ':Gitsigns reset_hunk<CR>' },
	},
}

---@class GitSignOpts
---@field text string

---@class GitSigns
---@field add GitSignOpts
---@field change GitSignOpts
---@field delete GitSignOpts
---@field topdelete GitSignOpts
---@field changedelete GitSignOpts
---@field untracked GitSignOpts

---@alias GitSignsArr GitSigns[]

---@type GitSigns
local signs = {
	add          = { text = '÷' },
	change       = { text = '~' },
	delete       = { text = '-' },
	topdelete    = { text = 'X' },
	changedelete = { text = '≈' },
	untracked    = { text = '┆' },
}

local opts= {
	---@param bufnr integer
	on_attach = function(bufnr)
		if not is_num(bufnr) or bufnr < 0 then
			bufnr = 0
		end

		for mode, v in next, keys do
			---@type BufMapFunction
			local func = bufmap[mode]

			for _, t in next, v do
				if not is_nil(t.lhs) and not is_nil(t.rhs) then
					func(bufnr, t.lhs, t.rhs, t.opts or {})
				elseif not is_nil(t[1]) and not is_nil(t[2]) then
					func(bufnr, t[1], t[2], t[3] or {})
				end
			end
		end
	end,

	signs = signs,

	signcolumn = vim.o.signcolumn ==  'yes',  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = { follow_files = true },
	-- auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = false,
		virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
		delay = 5000,
		ignore_whitespace = false,
		virt_text_priority = 15,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 10,
	update_debounce = 100,
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		border = 'double',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1,
	},
}

Gsig.setup(opts)
