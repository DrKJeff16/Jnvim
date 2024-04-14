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
nmap('<Space>', '<Nop>', {
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
		{ lhs = '<Leader>fs', rhs = '<CMD>w<CR>' },
		{ lhs = '<Leader>fS', rhs = ':w ', opts = { silent = false } },
		{ lhs = '<Leader>ff', rhs = ':ed ', opts = { silent = false } },
		{ lhs = '<Leader>fvs', rhs = '<CMD>luafile $MYVIMRC<CR>' },
		{ lhs = '<Leader>fvl', rhs = '<CMD>luafile %<CR>' },
		{ lhs = '<Leader>fvv', rhs = '<CMD>so %<CR>' },
		{ lhs = '<Leader>fvV', rhs = ':so ', opts = { silent = false } },
		{ lhs = '<Leader>fvL', rhs = ':luafile ', opts = { silent = false } },
		{ lhs = '<Leader>fve', rhs = '<CMD>tabnew $MYVIMRC<CR>', opts = { silent = false } },

		{ lhs = '<Leader>wss', rhs = '<CMD>split<CR>' },
		{ lhs = '<Leader>wsv', rhs = '<CMD>vsplit<CR>' },
		{ lhs = '<Leader>wsS', rhs = ':split ', opts = { silent = false } },
		{ lhs = '<Leader>wsV', rhs = ':vsplit ', opts = { silent = false } },

		{ lhs = '<Leader>qq', rhs = '<CMD>qa<CR>' },
		{ lhs = '<Leader>qQ', rhs = '<CMD>qa!<CR>' },

		{ lhs = '<Leader>tn', rhs = '<CMD>tabN<CR>', opts = { silent = false } },
		{ lhs = '<Leader>tp', rhs = '<CMD>tabp<CR>', opts = { silent = false } },
		{ lhs = '<Leader>td', rhs = '<CMD>tabc<CR>' },
		{ lhs = '<Leader>tD', rhs = '<CMD>tabc!<CR>' },
		{ lhs = '<Leader>tf', rhs = '<CMD>tabfirst<CR>' },
		{ lhs = '<Leader>tl', rhs = '<CMD>tablast<CR>' },
		{ lhs = '<Leader>ta', rhs = ':tabnew ', opts = { silent = false } },
		{ lhs = '<Leader>tA', rhs = '<CMD>tabnew<CR>' },

		{ lhs = '<Leader>bn', rhs = '<CMD>bNext<CR>' },
		{ lhs = '<Leader>bp', rhs = '<CMD>bprevious<CR>' },
		{ lhs = '<Leader>bd', rhs = '<CMD>bdel<CR>' },
		{ lhs = '<Leader>bD', rhs = '<CMD>bdel!<CR>' },
		{ lhs = '<Leader>bf', rhs = '<CMD>bfirst<CR>' },
		{ lhs = '<Leader>bl', rhs = '<CMD>blast<CR>' },

		-- { lhs = '<Leader>fir', rhs = '<CMD>%retab<CR>' },

		{ lhs = '<Leader>Ll', rhs = '<CMD>Lazy<CR>' },
		{ lhs = '<Leader>LL', rhs = ':Lazy ', opts = { silent = false } },
		{ lhs = '<Leader>Ls', rhs = '<CMD>Lazy sync<CR>' },
		{ lhs = '<Leader>Lx', rhs = '<CMD>Lazy clean<CR>' },
		{ lhs = '<Leader>Lc', rhs = '<CMD>Lazy check<CR>' },
		{ lhs = '<Leader>Li', rhs = '<CMD>Lazy install<CR>' },
		{ lhs = '<Leader>Lr', rhs = '<CMD>Lazy reload<CR>' },

		-- Avoid entering visual while using `<leader>` sequences.
		{ lhs = '<Leader>v', rhs = '<Nop>', opts = { nowait = false } },
		-- Avoid entering insert while using `<leader>` sequences.
		{ lhs = '<Leader>i', rhs = '<Nop>', opts = { nowait = false } },
		{ lhs = '<Leader>"', rhs = '<Nop>', opts = { nowait = false } },
		{ lhs = '<Leader>\'', rhs = '<Nop>', opts = { nowait = false } },
	},
	v = {
		{ lhs = '<Leader>is', rhs = '<CMD>sort<CR>' },
		{ lhs = '<Leader>iS', rhs = '<CMD>sort!<CR>' },
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

-- SECTION: Colorschemes
-- Sourced from `lua/lazy_cfg/colorschemes/*`.
--
-- Reorder to your liking.
local Csc = Pkg.colorschemes
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
