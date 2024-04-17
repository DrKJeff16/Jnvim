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
local opts = User.opts

--- Table of mappings for each mode `(normal|insert|visual|terminal)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t]['<YOUR_KEY>'].opts` is an **API** option table.
local map_tbl = {
	n = {
		['<Leader>fn'] = { rhs = ':edit ', opts = { silent = false } },
		['<Leader>fs'] = { rhs = '<CMD>w<CR>' },
		['<Leader>fS'] = { rhs = ':w ', opts = { silent = false } },
		['<Leader>ff'] = { rhs = ':ed ', opts = { silent = false } },
		['<Leader>fvs'] = { rhs = '<CMD>luafile $MYVIMRC<CR>' },
		['<Leader>fvl'] = { rhs = '<CMD>luafile %<CR>' },
		['<Leader>fvv'] = { rhs = '<CMD>so %<CR>' },
		['<Leader>fvV'] = { rhs = ':so ', opts = { silent = false } },
		['<Leader>fvL'] = { rhs = ':luafile ', opts = { silent = false } },
		['<Leader>fve'] = { rhs = '<CMD>tabnew $MYVIMRC<CR>', opts = { silent = false } },

		['<Leader>wss'] = { rhs = '<CMD>split<CR>' },
		['<Leader>wsv'] = { rhs = '<CMD>vsplit<CR>' },
		['<Leader>wsS'] = { rhs = ':split ', opts = { silent = false } },
		['<Leader>wsV'] = { rhs = ':vsplit ', opts = { silent = false } },

		['<Leader>qq'] = { rhs = '<CMD>qa<CR>' },
		['<Leader>qQ'] = { rhs = '<CMD>qa!<CR>' },

		['<Leader>tn'] = { rhs = '<CMD>tabN<CR>', opts = { silent = false } },
		['<Leader>tp'] = { rhs = '<CMD>tabp<CR>', opts = { silent = false } },
		['<Leader>td'] = { rhs = '<CMD>tabc<CR>' },
		['<Leader>tD'] = { rhs = '<CMD>tabc!<CR>' },
		['<Leader>tf'] = { rhs = '<CMD>tabfirst<CR>' },
		['<Leader>tl'] = { rhs = '<CMD>tablast<CR>' },
		['<Leader>ta'] = { rhs = ':tabnew ', opts = { silent = false } },
		['<Leader>tA'] = { rhs = '<CMD>tabnew<CR>' },

		['<Leader>bn'] = { rhs = '<CMD>bNext<CR>' },
		['<Leader>bp'] = { rhs = '<CMD>bprevious<CR>' },
		['<Leader>bd'] = { rhs = '<CMD>bdel<CR>' },
		['<Leader>bD'] = { rhs = '<CMD>bdel!<CR>' },
		['<Leader>bf'] = { rhs = '<CMD>bfirst<CR>' },
		['<Leader>bl'] = { rhs = '<CMD>blast<CR>' },

		['<Leader>Ll'] = { rhs = '<CMD>Lazy<CR>' },
		['<Leader>LL'] = { rhs = ':Lazy ', opts = { silent = false } },
		['<Leader>Ls'] = { rhs = '<CMD>Lazy sync<CR>' },
		['<Leader>Lx'] = { rhs = '<CMD>Lazy clean<CR>' },
		['<Leader>Lc'] = { rhs = '<CMD>Lazy check<CR>' },
		['<Leader>Li'] = { rhs = '<CMD>Lazy install<CR>' },
		['<Leader>Lr'] = { rhs = '<CMD>Lazy reload<CR>' },
		-- Avoid entering visual while using `<leader>` sequences.
		['<Leader>v'] = { rhs = '<Nop>', opts = { nowait = false } },
		-- Avoid entering insert while using `<leader>` sequences.
		['<Leader>i'] = { rhs = '<Nop>', opts = { nowait = false } },
		['<Leader>"'] = { rhs = '<Nop>', opts = { nowait = false } },
		['<Leader>\''] = { rhs = '<Nop>', opts = { nowait = false } },
	},
	v = {
		--- WARNING: DO NOT USE `<CMD>`!!!
		['<Leader>is'] = { rhs = ':sort<CR>' },
		['<Leader>iS'] = { rhs = ':sort!<CR>' },
	},
	t = {
		-- Escape terminl by pressing `<Esc>`
		['<Esc>'] = { rhs = '<C-\\><C-n>' },
	},
}

-- Set the keymaps previously stated.
for k, func in next, map do
	local tbl = map_tbl[k]

	-- If `tbl` exists, apply the mapping.
	if tbl ~= nil and not vim.tbl_isempty(tbl) then
		for lhs, v in next, tbl do
			func(lhs, v.rhs, v.opts or {})
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
