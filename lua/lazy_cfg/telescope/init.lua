---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.user.maps')

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

local kmap = User.maps().kmap
local nmap = kmap.n

local Telescope = require('telescope')
local Builtin = require('telescope.builtin')
local Themes = require('telescope.themes')
local Actions = require('telescope.actions')
local ActionLayout = require('telescope.actions.layout')

Telescope.setup({
	defaults = {
		layout_strategy = 'flex',
		-- FIXME: Make this actually work.
		-- layout_config = {
		-- 	horizontal = {
		-- 		size = { width = '90%', height = '80%' },
		-- 	},
		-- 	vertical = {
		-- 		size = { width = '80%', height = '80%' },
		-- 	},
		-- },
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
})

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun(): any
---@field opts? KeyMapOpts

---@class KeyMapModeDict
---@field n KeyMapArgs[]
local maps = {
	n = {
		{ lhs = '<leader>fTbb', rhs = Builtin.buffers },
		{ lhs = '<leader>fTbc', rhs = Builtin.colorscheme },
		{ lhs = '<leader>fTbd', rhs = Builtin.diagnostics },
		{ lhs = '<leader>fTbf', rhs = Builtin.find_files },
		{ lhs = '<leader>fTbg', rhs = Builtin.live_grep },
		{ lhs = '<leader>fTbh', rhs = Builtin.help_tags },
		{ lhs = '<leader>fTbk', rhs = Builtin.keymaps },
		{ lhs = '<leader>fTbld', rhs = Builtin.lsp_definitions },
		{ lhs = '<leader>fTblD', rhs = Builtin.lsp_document_symbols },
		{ lhs = '<leader>fTbp', rhs = Builtin.pickers },
		{ lhs = '<leader>fTbP', rhs = Builtin.planets },
	},
}

for mode, m in next, maps do
	for _, v in next, m do
		kmap[mode](v.lhs, v.rhs, v.opts or {})
	end
end

---@class AuPair
---@field event string|string?
---@field opts AuOpts

---@class TelArgs
---@field title? string
---@field filetype? string
---@field bufname? string

---@type AuPair[]
local au_tbl = {
	{
		event = 'User',
		opts = {
			pattern = 'TelescopePreviewerLoaded',
			callback = function(args)
				if args.data.filetype ~= 'help' then
					wo.number = true
				else
					wo.wrap = true
				end
			end,
		},
	},
}

for _, t in next, au_tbl do
	au(t.event, t.opts)
end
