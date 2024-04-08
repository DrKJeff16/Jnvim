---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('gitsigns') then
	return
end

local types = User.types.gitsigns
local bufmap = User.maps.buf_map

local Gsig = require('gitsigns')

---@type UserBufModeKeys
local keys = {
	n = {
		-- Navigati7on
		{ lhs = '<leader>G]c', rhs = "&diff ? ']c' : '<CMD>Gitsigns next_hunk<CR>'", opts = { expr = true } },
		{ lhs = '<leader>G[c', rhs = "&diff ? '[c' : '<CMD>Gitsigns prev_hunk<CR>'", opts = { expr = true } },
		-- Actions
		{ lhs = '<leader>Ghs', rhs = ':Gitsigns stage_hunk<CR>' },
		{ lhs = '<leader>Ghr', rhs = ':Gitsigns reset_hunk<CR>' },
		{ lhs = '<leader>GhS', rhs = '<CMD>Gitsigns stage_buffer<CR>' },
		{ lhs = '<leader>Ghu', rhs = '<CMD>Gitsigns undo_stage_hunk<CR>' },
		{ lhs = '<leader>GhR', rhs = '<CMD>Gitsigns reset_buffer<CR>' },
		{ lhs = '<leader>Ghp', rhs = '<CMD>Gitsigns preview_hunk<CR>' },
		{ lhs = '<leader>Ghb', rhs = '<CMD>lua require"gitsigns".blame_line{full=true}<CR>' },
		{ lhs = '<leader>Gtb', rhs = '<CMD>Gitsigns toggle_current_line_blame<CR>' },
		{ lhs = '<leader>Ghd', rhs = '<CMD>Gitsigns diffthis<CR>' },
		{ lhs = '<leader>GhD', rhs = '<CMD>lua require"gitsigns".diffthis("~")<CR>' },
		{ lhs = '<leader>Gtd', rhs = '<CMD>Gitsigns toggle_deleted<CR>' },
	},
	v = {
		{ lhs = '<leader>Ghs', rhs = ':Gitsigns stage_hunk<CR>' },
		{ lhs = '<leader>Ghr', rhs = ':Gitsigns reset_hunk<CR>' },
	},
}

---@alias GitSignOpts { ['text']: string }

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
		for mode, v in next, keys do
			---@type BufMapFunction
			local func = bufmap[mode]

			for _, t in next, v do
				func(bufnr, t.lhs, t.rhs, t.opts or {})
			end
		end
	end,

	signs = signs,

	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = { follow_files = true },
	-- auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = false,
		virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
		delay = 5000,
		ignore_whitespace = false,
		virt_text_priority = 25,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 4,
	update_debounce = 100,
	-- status_formatter = nil, -- Use default
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
