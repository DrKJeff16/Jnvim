---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

-- Import docstrings and annotations.
require('user.types')

local set = vim.o
local opt = vim.opt
local fn = vim.fn
local api = vim.api
local let = vim.g
local lsp = vim.lsp
local bo = vim.bo

local hi = api.nvim_set_hl
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local User = require('user')
local exists = User.exists  -- Checks for missing modules
local map = User.maps().map

local nmap = map.n
local imap = map.i
local tmap = map.t
local vmap = map.v

-- Vim `:set ...` global options setter.
_G.vimopts = User.opts
vimopts()

-- Set `<Space>` as Leader Key.
nmap('<Space>', '<Nop>')
let.mapleader = ' '
let.maplocalleader = ' '

-- Disable `netrw` regardless of whether Nvim Tree exists
-- Or not
let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

-- Make the package list globsl.
_G.Pkg = require('lazy_cfg')

-- If colorschemes calker table exists.
if Pkg.colorschemes then
	-- Global color schemes table.
	_G.Csc = Pkg.colorschemes()

	-- Reorder to your liking.
	if Csc.nightfox then
		Csc.nightfox.setup()
	elseif Csc.catppuccin then
		Csc.catppuccin.setup()
	elseif Csc.tokyonight then
		Csc.tokyonight.setup()
	elseif Csc.spaceduck then
		Csc.spaceduck.setup()
	end
end

--- Table of mappings for each mode `(normal|insert|visual|terminal)`.
---
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t].opts` is an **API** option table.
---@class Maps
---@field n? MapTbl[]
---@field i? MapTbl[]
---@field v? MapTbl[]
---@field t? MapTbl[]
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

		{ lhs = '<Leader>prc', rhs = ':lua Pkg.cmp()<cr>' },
		{ lhs = '<Leader>prl', rhs = ':lua Pkg.lspconfig()<cr>' },
		{ lhs = '<Leader>prL', rhs = ':lua Pkg.lualine()<cr>' },
		{ lhs = '<Leader>prT', rhs = ':lua Pkg.treesitter()<cr>' },
		{ lhs = '<Leader>prC', rhs = ':lua Pkg.Comment()<cr>' },
		{ lhs = '<Leader>prt', rhs = ':lua Pkg.nvim_tree()<cr>' },
		{ lhs = '<Leader>prg', rhs = ':lua Pkg.gitsigns()<cr>' },
		{ lhs = '<Leader>prh', rhs = ':lua Pkg.colorizer()<cr>' },
		{ lhs = '<Leader>prs', rhs = ':lua Pkg.toggleterm()<cr>' },
		{ lhs = '<Leader>prk', rhs = ':lua Pkg.which_key()<cr>' },
	},
	v = {
		{ lhs = '<Leader>is', rhs = ':sort<CR>' },
	},
	t = {
		{ lhs = '<Esc>', rhs = '<C-\\><C-n>' },
	},
}

---@class MapFields
---@field n fun(lhs: string, rhs: string, opts?: ApiMapOpts)
---@field i fun(lhs: string, rhs: string, opts?: ApiMapOpts)
---@field v fun(lhs: string, rhs: string, opts?: ApiMapOpts)
---@field t fun(lhs: string, rhs: string, opts?: ApiMapOpts)
local map_fields = {
	n = nmap,
	v = vmap,
	t = tmap,
	i = imap,
}

-- Set the keymaps previously stated.
for k, func in next, map_fields do
	local tbl = map_tbl[k]

	-- If `tbl` exists, apply the mapping.
	if tbl then
		for _, v in next, tbl do
			func(v.lhs, v.rhs, v.opts or {})
		end
	end
end

-- Configure the plugins.
for k, func in next, Pkg do
	-- List of excluded packages (**in this stage**).
	local exclude = { 'cmp', 'colorschemes' }

	-- Call every plugin except `cmp` and the colorschemes.
	if not vim.tbl_contains(exclude, k) then
		func()
	end
end

-- Call the user file associations.
User.assoc()

vim.cmd[[
filetype plugin indent on
syntax on
]]

-- Call `cmp` last 'cause this plugin is a headache.
if Pkg.cmp then
	Pkg.cmp()
end
