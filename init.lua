---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
-- Import docstrings and annotations.
local types = User.types
local maps_t = types.user.maps
local hl_t = types.user.highlight
local map = User.maps.map
local kmap = User.maps.kmap

local exists = Check.exists.module  -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local nop = User.maps.nop
local hl = User.highlight.hl

local fn = vim.fn
local let = vim.g

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

-- Avoid executing Normal mode keys when attempting `<leader>` sequences.
local NOP = {
	'<leader>"',
	'<leader>\'',
	'<leader>c',
	'<leader>d',
	'<leader>i',
	'<leader>p',
	'<leader>v',
	'<leader>z',
}
nop(NOP, { nowait = false })

--- Table of mappings for each mode `(normal|insert|visual|terminal)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t]['<YOUR_KEY>'].opts` is an **API** option table.
local map_tbl = {
	n = {
		['<Leader>fs'] = { '<CMD>w<CR>' },
		['<Leader>fS'] = { ':w ', { silent = false } },
		['<Leader>fvs'] = { '<CMD>luafile $MYVIMRC<CR>' },
		['<Leader>fvl'] = { '<CMD>luafile %<CR>' },
		['<Leader>fvv'] = { '<CMD>so %<CR>' },
		['<Leader>fvV'] = { ':so ', { silent = false } },
		['<Leader>fvL'] = { ':luafile ', { silent = false } },
		['<Leader>fve'] = { '<CMD>tabnew $MYVIMRC<CR>', { silent = false } },

		['<Leader>wss'] = { '<CMD>split<CR>' },
		['<Leader>wsv'] = { '<CMD>vsplit<CR>' },
		['<Leader>wsS'] = { ':split ', { silent = false } },
		['<Leader>wsV'] = { ':vsplit ', { silent = false } },

		['<Leader>qq'] = { '<CMD>qa<CR>' },
		['<Leader>qQ'] = { '<CMD>qa!<CR>' },

		['<Leader>tn'] = { '<CMD>tabN<CR>', { silent = false } },
		['<Leader>tp'] = { '<CMD>tabp<CR>', { silent = false } },
		['<Leader>td'] = { '<CMD>tabc<CR>' },
		['<Leader>tD'] = { '<CMD>tabc!<CR>' },
		['<Leader>tf'] = { '<CMD>tabfirst<CR>' },
		['<Leader>tl'] = { '<CMD>tablast<CR>' },
		['<Leader>ta'] = { ':tabnew ', { silent = false } },
		['<Leader>tA'] = { '<CMD>tabnew<CR>' },

		['<Leader>bn'] = { '<CMD>bNext<CR>' },
		['<Leader>bp'] = { '<CMD>bprevious<CR>' },
		['<Leader>bd'] = { '<CMD>bdel<CR>' },
		['<Leader>bD'] = { '<CMD>bdel!<CR>' },
		['<Leader>bf'] = { '<CMD>bfirst<CR>' },
		['<Leader>bl'] = { '<CMD>blast<CR>' },

		['<Leader>Ll'] = { '<CMD>Lazy<CR>' },
		['<Leader>LL'] = { ':Lazy ', { silent = false } },
		['<Leader>Ls'] = { '<CMD>Lazy sync<CR>' },
		['<Leader>Lx'] = { '<CMD>Lazy clean<CR>' },
		['<Leader>Lc'] = { '<CMD>Lazy check<CR>' },
		['<Leader>Li'] = { '<CMD>Lazy install<CR>' },
		['<Leader>Lr'] = { '<CMD>Lazy reload<CR>' },
	},
	v = {
		--- WARNING: DO NOT USE `<CMD>`!!!
		['<Leader>is'] = { ':sort<CR>' },
		['<Leader>iS'] = { ':sort!<CR>' },
	},
	t = {
		-- Escape terminl by pressing `<Esc>`
		['<Esc>'] = { '<C-\\><C-n>' },
	},
}

-- Set the keymaps previously stated.
for k, func in next, map do
	local tbl = map_tbl[k]

	-- If `tbl` exists, apply the mapping.
	if is_tbl(tbl) and not vim.tbl_isempty(tbl) then
		for lhs, v in next, tbl do
			func(lhs, v[1], v[2] or {})
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
