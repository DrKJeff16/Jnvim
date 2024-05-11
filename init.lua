---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Types = User.types -- Import docstrings and annotations.
local maps_t = Types.user.maps
local Kmap = User.maps.kmap

local nop = User.maps.nop
local exists = Check.exists.module -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun

local empty = vim.tbl_isempty

-- Set `<Space>` as Leader Key.
nop('<Space>', { nowait = false, desc = 'Leader Key' })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable `netrw` regardless of whether
-- Nvim Tree exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Vim `:set ...` global options setter.
local opts = User.opts

-- Use clipboard
-- vim.o.clipboard = 'unnamedplus'

-- Avoid executing Normal mode keys when attempting `<leader>` sequences.
local NOP = {
	"<leader>'",
	'<leader>!',
	'<leader>"',
	'<leader>C',
	'<leader>I',
	'<leader>L',
	'<leader>O',
	'<leader>P',
	'<leader>S',
	'<leader>U',
	'<leader>V',
	'<leader>X',
	'<leader>b',
	'<leader>c',
	'<leader>d',
	'<leader>h',
	'<leader>i',
	'<leader>j',
	'<leader>k',
	'<leader>l',
	'<leader>o',
	'<leader>p',
	'<leader>s',
	'<leader>r',
	'<leader>v',
	'<leader>x',
	'<leader>z',
}
for _, mode in next, User.maps.modes do
	if mode ~= 'i' then
		nop(NOP, { nowait = false }, mode)
	end
end

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table.
---@class Maps
---@field n table<string, KeyMapRhsOptsArr>
---@field i? table<string, KeyMapRhsOptsArr>
---@field v table<string, KeyMapRhsOptsArr>
---@field t table<string, KeyMapRhsOptsArr>
---@field o? table<string, KeyMapRhsOptsArr>
---@field x? table<string, KeyMapRhsOptsArr>

---@type Maps
local map_tbl = {
	n = {
		['<leader>fs'] = { '<CMD>w<CR>' },
		['<leader>fS'] = { ':w ', { silent = false, desc = 'Save File (Interactively)' } },
		['<leader>fvs'] = { '<CMD>luafile $MYVIMRC<CR>' },
		['<leader>fvl'] = { '<CMD>luafile %<CR>' },
		['<leader>fvv'] = { '<CMD>so %<CR>' },
		['<leader>fvV'] = { ':so ', { silent = false, desc = 'Source VimScript File (Interactively)' } },
		['<leader>fvL'] = { ':luafile ', { silent = false, desc = 'Source Lua File (Interactively)' } },
		['<leader>fvet'] = { '<CMD>tabnew $MYVIMRC<CR>' },
		['<leader>fvee'] = { '<CMD>ed $MYVIMRC<CR>' },
		['<leader>fves'] = { '<CMD>split $MYVIMRC<CR>' },
		['<leader>fvev'] = { '<CMD>vsplit $MYVIMRC<CR>' },

		['<leader>wn'] = { '<C-w>w', { desc = 'Next Window' } },
		['<leader>wss'] = { '<CMD>split<CR>' },
		['<leader>wsv'] = { '<CMD>vsplit<CR>' },
		['<leader>wsS'] = { ':split ', { silent = false, desc = 'Horizontal Split (Interactively)' } },
		['<leader>wsV'] = { ':vsplit ', { silent = false, desc = 'Vertical Split (Interactively)' } },

		['<leader>qq'] = { '<CMD>qa<CR>' },
		['<leader>qQ'] = { '<CMD>qa!<CR>' },

		['<leader>tn'] = { '<CMD>tabN<CR>', { silent = false } },
		['<leader>tp'] = { '<CMD>tabp<CR>', { silent = false } },
		['<leader>td'] = { '<CMD>tabc<CR>', { silent = false } },
		['<leader>tD'] = { '<CMD>tabc!<CR>' },
		['<leader>tf'] = { '<CMD>tabfirst<CR>' },
		['<leader>tl'] = { '<CMD>tablast<CR>' },
		['<leader>ta'] = { ':tabnew ', { silent = false, desc = 'New Tab (Interactively)' } },
		['<leader>tA'] = { '<CMD>tabnew<CR>', { silent = false } },

		['<leader>bn'] = { '<CMD>bNext<CR>', { silent = false } },
		['<leader>bp'] = { '<CMD>bprevious<CR>', { silent = false } },
		['<leader>bd'] = { '<CMD>bdel<CR>' },
		['<leader>bD'] = { '<CMD>bdel!<CR>' },
		['<leader>bf'] = { '<CMD>bfirst<CR>' },
		['<leader>bl'] = { '<CMD>blast<CR>' },

		['<leader>Ll'] = { '<CMD>Lazy<CR>' },
		['<leader>LL'] = { ':Lazy ', { silent = false, desc = 'Select `Lazy` Operation (Interactively)' } },
		['<leader>Ls'] = { '<CMD>Lazy sync<CR>' },
		['<leader>Lx'] = { '<CMD>Lazy clean<CR>' },
		['<leader>Lc'] = { '<CMD>Lazy check<CR>' },
		['<leader>Li'] = { '<CMD>Lazy install<CR>' },
		['<leader>Lr'] = { '<CMD>Lazy reload<CR>' },
	},
	v = {
		--- WARNING: DO NOT USE `<CMD>`!!!
		['<leader>is'] = { ':sort<CR>', { desc = 'Sort' } },
		['<leader>iS'] = { ':sort!<CR>', { desc = 'Sort (Reverse)' } },
	},
	t = {
		-- Escape terminl by pressing `<Esc>`
		['<Esc>'] = { '<C-\\><C-n>' },
	},
}

--- List of manually-callable plugins.
local Pkg = require('lazy_cfg')

-- Set the keymaps previously stated.
for mode, t in next, map_tbl do
	---@type KeyMapFunction
	local func = Kmap[mode]

	for lhs, v in next, t do
		if not is_tbl(v[2]) then
			v[2] = {}
		end

		func(lhs, v[1], v[2])
	end
end

-- SECTION: Colorschemes
-- Sourced from `lua/lazy_cfg/colorschemes/*`.

---@type fun(csc: CscSubMod): boolean
local function csc_check(csc)
	return is_tbl(csc) and is_fun(csc.setup)
end

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
	-- A table containing various possible colorschemes.
	local Csc = Pkg.colorschemes.new()

	-- Reorder to your liking.
	if csc_check(Csc.tokyonight) then
		Csc.tokyonight.setup()
	elseif csc_check(Csc.catppuccin) then
		Csc.catppuccin.setup()
	elseif csc_check(Csc.nightfox) then
		Csc.nightfox.setup()
	elseif csc_check(Csc.spaceduck) then
		Csc.spaceduck.setup()
	elseif csc_check(Csc.dracula) then
		Csc.dracula.setup()
	elseif csc_check(Csc.molokai) then
		Csc.molokai.setup()
	end
end

if is_fun(User.assoc) then
	--- Call the user file associations.
	User.assoc()
end

vim.cmd([[
filetype plugin indent on
syntax on
]])
