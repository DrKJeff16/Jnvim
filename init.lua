---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
-- Import docstrings and annotations.
local types = User.types
local maps_t = types.user.maps
local hl_t = types.user.highlight
local exists = User.exists  -- Checks for missing modules
local map = User.maps.map
local kmap = User.maps.kmap
local hl = User.highlight.hl

local set = vim.o
local opt = vim.opt
local fn = vim.fn
local api = vim.api
local let = vim.g
local lsp = vim.lsp
local bo = vim.bo

local nmap = map.n

-- Set `<Space>` as Leader Key.
nmap('<space>', '<Nop>', {
	nowait = false,
	desc = 'Leader Key.'
})
let.mapleader = ' '
let.maplocalleader = ' '

-- Disable `netrw` regardless of whether
-- Nvim Tree exists or not
let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

-- Vim `:set ...` global options setter.
User.opts()

--- Table of mappings for each mode `(normal|insert|visual|terminal)`.
--- ---
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t].opts` is an **API** option table.
---@type ApiMapModeDicts
local map_tbl = {
	n = {
		{ lhs = '<Leader>fn', rhs = ':edit ', opts = { silent = false } },
		{ lhs = '<Leader>fs', rhs = ':w<CR>' },
		{ lhs = '<Leader>fS', rhs = ':w ', opts = { silent = false } },
		{ lhs = '<Leader>ff', rhs = ':ed ', opts = { silent = false } },
		{ lhs = '<Leader>fvs', rhs = ':luafile $MYVIMRC<CR>' },
		{ lhs = '<Leader>fvl', rhs = ':luafile %<CR>' },
		{ lhs = '<Leader>fvv', rhs = ':so %<CR>' },
		{ lhs = '<Leader>fvV', rhs = ':so ', opts = { silent = false } },
		{ lhs = '<Leader>fvL', rhs = ':luafile ', opts = { silent = false } },
		{ lhs = '<Leader>fve', rhs = ':tabnew $MYVIMRC<CR>', opts = { silent = false } },

		{ lhs = '<Leader>wss', rhs = ':split<CR>' },
		{ lhs = '<Leader>wsv', rhs = ':vsplit<CR>' },
		{ lhs = '<Leader>wsS', rhs = ':split ', opts = { silent = false } },
		{ lhs = '<Leader>wsV', rhs = ':vsplit ', opts = { silent = false } },

		{ lhs = '<Leader>qq', rhs = ':qa<CR>' },
		{ lhs = '<Leader>qQ', rhs = ':qa!<CR>' },

		{ lhs = '<Leader>tn', rhs = ':tabN<CR>', opts = { silent = false } },
		{ lhs = '<Leader>tp', rhs = ':tabp<CR>', opts = { silent = false } },
		{ lhs = '<Leader>td', rhs = ':tabc<CR>' },
		{ lhs = '<Leader>tD', rhs = ':tabc!<CR>' },
		{ lhs = '<Leader>tf', rhs = ':tabfirst<CR>' },
		{ lhs = '<Leader>tl', rhs = ':tablast<CR>' },
		{ lhs = '<Leader>ta', rhs = ':tabnew ', opts = { silent = false } },
		{ lhs = '<Leader>tA', rhs = ':tabnew<CR>' },

		{ lhs = '<Leader>bn', rhs = ':bNext<CR>' },
		{ lhs = '<Leader>bp', rhs = ':bprevious<CR>' },
		{ lhs = '<Leader>bd', rhs = ':bdel<CR>' },
		{ lhs = '<Leader>bD', rhs = ':bdel!<CR>' },
		{ lhs = '<Leader>bf', rhs = ':bfirst<CR>' },
		{ lhs = '<Leader>bl', rhs = ':blast<CR>' },

		{ lhs = '<Leader>fir', rhs = ':%retab<CR>' },

		{ lhs = '<Leader>Ll', rhs = ':Lazy<CR>' },
		{ lhs = '<Leader>LL', rhs = ':Lazy ', opts = { silent = false } },
		{ lhs = '<Leader>Ls', rhs = ':Lazy sync<CR>' },
		{ lhs = '<Leader>Lx', rhs = ':Lazy clean<CR>' },
		{ lhs = '<Leader>Lc', rhs = ':Lazy check<CR>' },
		{ lhs = '<Leader>Li', rhs = ':Lazy install<CR>' },
		{ lhs = '<Leader>Lr', rhs = ':Lazy reload<CR>' },
	},
	v = {
		{ lhs = '<Leader>is', rhs = ':sort<CR>' },
		{ lhs = '<Leader>iS', rhs = ':sort!<CR>' },
	},
	t = {
		{ lhs = '<Esc>', rhs = '<C-\\><C-n>' },
	},
}

-- Set the keymaps previously stated.
for k, func in next, map do
	local tbl = map_tbl[k]

	-- If `tbl` exists, apply the mapping.
	if tbl then
		for _, v in next, tbl do
			func(v.lhs, v.rhs, v.opts or {})
		end
	end
end

--- List of manually-called, plugins.
local Pkg = require('lazy_cfg')
local Csc = Pkg.colorschemes

-- Reorder to your liking.
if Csc.nightfox and Csc.nightfox.setup then
	Csc.nightfox.setup()
elseif Csc.tokyonight and Csc.tokyonight.setup then
	Csc.tokyonight.setup()
elseif Csc.spaceduck and Csc.spaceduck.setup then
	Csc.spaceduck.setup()
elseif Csc.catppuccin and Csc.catppuccin.setup then
	Csc.catppuccin.setup()
end

-- Call the user file associations.
User.assoc()

vim.cmd[[
filetype plugin indent on
syntax on
]]
