---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Maps = User.maps
local Types = User.types  -- Import docstrings and annotations.
local maps_t = Types.user.maps
local hl_t = Types.user.highlight
local map = Maps.map
local kmap = Maps.kmap

local exists = Check.exists.module  -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun

local nop = User.maps.nop
local hl = User.highlight.hl

local fn = vim.fn

-- Set `<Space>` as Leader Key.
nop('<Space>', {
	nowait = false,
	desc = 'Leader Key.'
})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable `netrw` regardless of whether
-- Nvim Tree exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
	'<leader>x',
}
nop(NOP, { nowait = false })

--- Table of mappings for each mode `(normal|insert|visual|terminal)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t]['<YOUR_KEY>'].opts` is an **API** option table.
local map_tbl = {
	n = {
		['<leader>fs'] = { '<CMD>w<CR>' },
		['<leader>fS'] = { ':w ', {
			silent = false,
			desc = 'Save File (Prompt)',
		} },
		['<leader>fvs'] = { '<CMD>luafile $MYVIMRC<CR>' },
		['<leader>fvl'] = { '<CMD>luafile %<CR>' },
		['<leader>fvv'] = { '<CMD>so %<CR>' },
		['<leader>fvV'] = { ':so ', {
			silent = false,
			desc = 'Source VimScript File (Prompt)',
		} },
		['<leader>fvL'] = { ':luafile ', {
			silent = false,
			desc = 'Source Lua File (Prompt)',
		} },
		['<leader>fvet'] = { '<CMD>tabnew $MYVIMRC<CR>' },
		['<leader>fvee'] = { '<CMD>ed $MYVIMRC<CR>' },
		['<leader>fves'] = { '<CMD>split $MYVIMRC<CR>' },
		['<leader>fvev'] = { '<CMD>vsplit $MYVIMRC<CR>' },

		['<leader>wss'] = { '<CMD>split<CR>' },
		['<leader>wsv'] = { '<CMD>vsplit<CR>' },
		['<leader>wsS'] = { ':split ', { silent = false } },
		['<leader>wsV'] = { ':vsplit ', { silent = false } },

		['<leader>qq'] = { '<CMD>qa<CR>' },
		['<leader>qQ'] = { '<CMD>qa!<CR>' },

		['<leader>tn'] = { '<CMD>tabN<CR>', { silent = false } },
		['<leader>tp'] = { '<CMD>tabp<CR>', { silent = false } },
		['<leader>td'] = { '<CMD>tabc<CR>' },
		['<leader>tD'] = { '<CMD>tabc!<CR>' },
		['<leader>tf'] = { '<CMD>tabfirst<CR>' },
		['<leader>tl'] = { '<CMD>tablast<CR>' },
		['<leader>ta'] = { ':tabnew ', { silent = false } },
		['<leader>tA'] = { '<CMD>tabnew<CR>' },

		['<leader>bn'] = { '<CMD>bNext<CR>' },
		['<leader>bp'] = { '<CMD>bprevious<CR>' },
		['<leader>bd'] = { '<CMD>bdel<CR>' },
		['<leader>bD'] = { '<CMD>bdel!<CR>' },
		['<leader>bf'] = { '<CMD>bfirst<CR>' },
		['<leader>bl'] = { '<CMD>blast<CR>' },

		['<leader>Ll'] = { '<CMD>Lazy<CR>' },
		['<leader>LL'] = { ':Lazy ', { silent = false } },
		['<leader>Ls'] = { '<CMD>Lazy sync<CR>' },
		['<leader>Lx'] = { '<CMD>Lazy clean<CR>' },
		['<leader>Lc'] = { '<CMD>Lazy check<CR>' },
		['<leader>Li'] = { '<CMD>Lazy install<CR>' },
		['<leader>Lr'] = { '<CMD>Lazy reload<CR>' },
	},
	v = {
		--- WARNING: DO NOT USE `<CMD>`!!!
		['<leader>is'] = { ':sort<CR>' },
		['<leader>iS'] = { ':sort!<CR>' },
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

---@param csc CscSubMod
---@return boolean
local csc_check = function(csc)
	return is_tbl(csc) and is_fun(csc.setup)
end

-- Reorder to your liking.
local Csc = Pkg.colorschemes
if csc_check(Csc.nightfox) then
	Csc.nightfox.setup()
elseif csc_check(Csc.tokyonight) then
	Csc.tokyonight.setup()
elseif csc_check(Csc.spaceduck) then
	Csc.spaceduck.setup()
elseif csc_check(Csc.catppuccin) then
	Csc.catppuccin.setup()
end

-- Call the user file associations.
if is_fun(User.assoc) then
	User.assoc()
end

vim.cmd[[
filetype plugin indent on
syntax on
]]
