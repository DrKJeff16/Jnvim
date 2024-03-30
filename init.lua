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

local map = api.nvim_set_keymap
local hi = api.nvim_set_hl
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

---@type MapOpts
local s_noremap = { noremap = true, silent = true, nowait = true }
---@type MapOpts
local ns_noremap = { noremap = true, silent = false, nowait = true }

---@param lhs string
---@param rhs string
---@param opts? MapOpts
local nmap = function(lhs, rhs, opts)
	opts = opts or s_noremap
	map('n', lhs, rhs, opts)
end
---@param lhs string
---@param rhs string
---@param opts? MapOpts
local vmap = function(lhs, rhs, opts)
	opts = opts or s_noremap
	map('v', lhs, rhs, opts)
end
---@param lhs string
---@param rhs string
---@param opts? MapOpts
local imap = function(lhs, rhs, opts)
	opts = opts or s_noremap
	map('i', lhs, rhs, opts)
end
---@param lhs string
---@param rhs string
---@param opts? MapOpts
local tmap = function(lhs, rhs, opts)
	opts = opts or s_noremap
	map('t', lhs, rhs, opts)
end

nmap('<Space>', '<Nop>')
let.mapleader = ' '
let.maplocalleader = ' '

let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

local User = require('user')
local exists = User.exists
local options = User.opts()

local Pkg = require('lazy_cfg')

for _, v in next, Pkg do
	local path = 'lazy_cfg.'..v
	if exists(path) then
		require(path)
	end
end

if exists('lazy_cfg.colorschemes') then
	local Csc = require('lazy_cfg.colorschemes')
	if Csc.tokyonight then
		Csc.tokyonight.setup()
	elseif Csc.catppuccin then
		Csc.catppuccin.setup()
	end
end

---@class MapsTbls
---@field nmap? MapTbl[]
---@field imap? MapTbl[]
---@field vmap? MapTbl[]
---@field tmap? MapTbl[]
local map_tbl = {
	nmap = {
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
	},
	vmap = {
		{ lhs = '<Leader>is', rhs = ':sort<CR>', opts = ns_noremap },
	},
	tmap = {
		{ lhs = '<Esc>', rhs = '<C-\\><C-n>' },
	},
}

---@type table<string, fun()>
local map_fields = {
	['nmap'] = nmap,
	['vmap'] = vmap,
	['tmap'] = tmap,
	['imap'] = imap,
}

for k, f in next, map_fields do
	local tbl = map_tbl[k] or nil
	if tbl ~= nil then
		local func = f
		for _, v in next, tbl do
			func(v.lhs, v.rhs, v.opts or s_noremap)
		end
	end
end

User.assoc()

vim.cmd[[
filetype plugin indent on
syntax on
]]
