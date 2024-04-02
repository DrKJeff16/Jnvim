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

Telescope.setup({
	defaults = {
		mappings = {
			i = {
				['<C-h>'] = 'which_key',
			},
		},
	},
})

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun(): any
---@field opts? KeyMapOpts

---@class KeyMapModeDict
---@field n? KeyMapArgs[]
---@field i? KeyMapArgs[]
---@field v? KeyMapArgs[]
---@field t? KeyMapArgs[]
local maps = {
	n = {
		{ lhs = '<leader>fTf', rhs = Builtin.find_files },
		{ lhs = '<leader>fTg', rhs = Builtin.live_grep },
		{ lhs = '<leader>fTb', rhs = Builtin.buffers },
		{ lhs = '<leader>fTh', rhs = Builtin.help_tags },
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
