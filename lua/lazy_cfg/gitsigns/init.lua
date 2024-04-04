---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('gitsigns') then
	return
end

local Gsig = require('gitsigns')

local bmap = User.maps().buf_map
local nmap = bmap.n
local vmap = bmap.v
local omap = bmap.o
local xmap = bmap.x

Gsig.setup({
	---@param bufnr integer
	on_attach = function(bufnr)
		-- Navigation
		nmap(bufnr, ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		nmap(bufnr, '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		-- Actions
		nmap(bufnr, '<leader>hs', ':Gitsigns stage_hunk<CR>')
		vmap(bufnr, '<leader>hs', ':Gitsigns stage_hunk<CR>')
		nmap(bufnr, '<leader>hr', ':Gitsigns reset_hunk<CR>')
		vmap(bufnr, '<leader>hr', ':Gitsigns reset_hunk<CR>')
		nmap(bufnr, '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
		nmap(bufnr, '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
		nmap(bufnr, '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
		nmap(bufnr, '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
		nmap(bufnr, '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
		nmap(bufnr, '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
		nmap(bufnr, '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
		nmap(bufnr, '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
		nmap(bufnr, '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

		-- Text object
		omap(bufnr, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		xmap(bufnr, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end,

	signs = {
		add          = { text = '÷' },
		change       = { text = '~' },
		delete       = { text = '-' },
		topdelete    = { text = 'X' },
		changedelete = { text = '≈' },
		untracked    = { text = '┆' },
	},
	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = { follow_files = true },
	auto_attach = true,
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = false,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 5000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 4,
	update_debounce = 100,
	-- status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1,
	},

	yadm = { enable = false },
})
