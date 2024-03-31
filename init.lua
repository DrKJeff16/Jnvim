---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

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
local exists = User.exists
local map = User.maps().map

local nmap = map.n
local imap = map.i
local tmap = map.t
local vmap = map.v

User.opts()

---@type ApiMapOpts
local ns_noremap = { noremap = true, silent = false, nowait = true }

nmap('<Space>', '<Nop>')
let.mapleader = ' '
let.maplocalleader = ' '

let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

_G.Pkg = require('lazy_cfg')

if Pkg.colorschemes then
	_G.Csc = Pkg.colorschemes()
	if Csc.nightfox then
		Csc.nightfox.setup()
	elseif Csc.catppuccin then
		Csc.catppuccin.setup()
	elseif Csc.tokyonight then
		Csc.tokyonight.setup()
	end
end

---@class Maps
---@field n? MapTbl[]
---@field i? MapTbl[]
---@field v? MapTbl[]
---@field t? MapTbl[]
local map_tbl = {
	n = {
		{ lhs = '<Leader>fn', rhs = ':edit ', opts = ns_noremap },
		{ lhs = '<Leader>fs', rhs = ':w<CR>' },
		{ lhs = '<Leader>fS', rhs = ':w ', opts = ns_noremap },
		{ lhs = '<Leader>ff', rhs = ':ed ', opts = ns_noremap },

		{ lhs = '<Leader>fvs', rhs = ':luafile $MYVIMRC<CR>' },
		{ lhs = '<Leader>fvl', rhs = ':luafile %<CR>' },
		{ lhs = '<Leader>fvv', rhs = ':so %<CR>' },
		{ lhs = '<Leader>fvV', rhs = ':so ', opts = ns_noremap },
		{ lhs = '<Leader>fvL', rhs = ':luafile ', opts = ns_noremap },
		{ lhs = '<Leader>fve', rhs = ':tabnew $MYVIMRC<CR>', opts = ns_noremap },

		{ lhs = '<Leader>wss', rhs = ':split<CR>' },
		{ lhs = '<Leader>wsv', rhs = ':vsplit<CR>' },
		{ lhs = '<Leader>wsS', rhs = ':split ', opts = ns_noremap },
		{ lhs = '<Leader>wsV', rhs = ':vsplit ', opts = ns_noremap },

		{ lhs = '<Leader>qq', rhs = ':qa<CR>' },
		{ lhs = '<Leader>qQ', rhs = ':qa!<CR>' },

		{ lhs = '<Leader>tn', rhs = ':tabN<CR>', opts = ns_noremap },
		{ lhs = '<Leader>tp', rhs = ':tabp<CR>', opts = ns_noremap },
		{ lhs = '<Leader>td', rhs = ':tabc<CR>' },
		{ lhs = '<Leader>tD', rhs = ':tabc!<CR>' },
		{ lhs = '<Leader>tf', rhs = ':tabfirst<CR>' },
		{ lhs = '<Leader>tl', rhs = ':tablast<CR>' },
		{ lhs = '<Leader>ta', rhs = ':tabnew ', opts = ns_noremap },
		{ lhs = '<Leader>tA', rhs = ':tabnew<CR>' },

		{ lhs = '<Leader>bn', rhs = ':bNext<CR>' },
		{ lhs = '<Leader>bp', rhs = ':bprevious<CR>' },
		{ lhs = '<Leader>bd', rhs = ':bdel<CR>' },
		{ lhs = '<Leader>bD', rhs = ':bdel!<CR>' },
		{ lhs = '<Leader>bf', rhs = ':bfirst<CR>' },
		{ lhs = '<Leader>bl', rhs = ':blast<CR>' },

		{ lhs = '<Leader>fir', rhs = ':%retab<CR>' },

		{ lhs = '<Leader>Ll', rhs = ':Lazy<CR>' },
		{ lhs = '<Leader>LL', rhs = ':Lazy ', opts = ns_noremap },
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
		{ lhs = '<Leader>prk', rhs = ':lua Pkg.which_key()<cr>' },
	},
	v = {
		{ lhs = '<Leader>is', rhs = ':sort<CR>', opts = ns_noremap },
	},
	t = {
		{ lhs = '<Esc>', rhs = '<C-\\><C-n>' },
	},
}

local map_fields = {
	n = nmap,
	v = vmap,
	t = tmap,
	i = imap,
}

for k, func in next, map_fields do
	local tbl = map_tbl[k]
	if tbl then
		for _, v in next, tbl do
			func(v.lhs, v.rhs, v.opts or s_noremap)
		end
	end
end

for k, func in next, Pkg do
	if k ~= 'colorschemes' and k ~= 'cmp' then
		func()
	end
end

User.assoc()

vim.cmd[[
filetype plugin indent on
syntax on
]]

Pkg.cmp()
