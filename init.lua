---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Types = User.types -- Import docstrings and annotations.
local maps_t = Types.user.maps
local Kmap = User.maps.kmap

local exists = Check.exists.module -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local nop = User.maps.nop

-- Set `<Space>` as Leader Key.
nop('<Space>', { noremap = true, desc = 'Leader Key' })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable `netrw` regardless of whether `nvim_tree` exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Vim `:set ...` global options setter
local opts = User.opts

-- Use system clipboard
-- vim.o.clipboard = 'unnamedplus'

-- Avoid executing Normal mode keys when attempting `<leader>` sequences.
local NOP = {
	"<leader>'",
	'<leader>!',
	'<leader>"',
	'<leader>A',
	'<leader>C',
	'<leader>I',
	'<leader>L',
	'<leader>O',
	'<leader>P',
	'<leader>S',
	'<leader>U',
	'<leader>V',
	'<leader>X',
	'<leader>a',
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
	'<leader>r',
	'<leader>s',
	'<leader>v',
	'<leader>x',
	'<leader>z',
}
for _, mode in next, User.maps.modes do
	nop(NOP, {}, mode)
end

---@type Maps
local map_tbl = {
	n = {
		['<Esc><Esc>'] = { '<CMD>nohls<CR>', { desc = 'Remove Highlights' } },

		['<leader>fs'] = { '<CMD>w<CR>', { silent = false, desc = 'Save File' } },
		['<leader>fS'] = { ':w ', { silent = false, desc = 'Save File (Interactively)' } },
		['<leader>fvs'] = {
			function()
				vim.cmd('luafile $MYVIMRC')
				vim.notify('Sourced `init.lua`')
			end,
			{ silent = false }
		},
		['<leader>fvl'] = {
			function()
				local ft = vim.api.nvim_get_option_value('ft', { scope = 'local' })
				local err_msg = 'File not sourceable!'

				if ft == 'lua' then
					vim.cmd('luafile %')
					vim.notify('Sourced current Lua file')
				elseif not is_nil(_G.Notify) then
					Notify(err_msg, 'error', { title = 'Lua' })
				elseif exists('notify') then
					require('notify')(err_msg, 'error', { title = 'Lua' })
				else
					error(err_msg)
				end
			end,
			{ silent = false, desc = 'Attempt to source current Lua file' },
		},
		['<leader>fvv'] = {
			function()
				---@type string
				local ft = vim.api.nvim_get_option_value('ft', { scope = 'local' })
				local err_msg = 'File not sourceable!'

				if ft == 'vim' then
					vim.cmd('so %')
					vim.notify('Sourced current Vim file')
				elseif not is_nil(_G.Notify) then
					Notify(err_msg, 'error', { title = 'Vim' })
				elseif exists('notify') then
					require('notify')(err_msg, 'error', { title = 'Vim' })
				else
					error(err_msg)
				end
			end,
			{ silent = false, desc = 'Attempt To source current Vim file' },
		},
		['<leader>fvV'] = { ':so ', { silent = false, desc = 'Source VimScript File (Interactively)' } },
		['<leader>fvL'] = { ':luafile ', { silent = false, desc = 'Source Lua File (Interactively)' } },
		['<leader>fvet'] = { '<CMD>tabnew $MYVIMRC<CR>' },
		['<leader>fvee'] = { '<CMD>ed $MYVIMRC<CR>' },
		['<leader>fves'] = { '<CMD>split $MYVIMRC<CR>' },
		['<leader>fvev'] = { '<CMD>vsplit $MYVIMRC<CR>' },

		['<leader>vh'] = { '<CMD>checkhealth<CR>' },

		['<leader>ht'] = { ':tab h ', { silent = false, desc = 'Prompt For Help On New Tab' } },
		['<leader>hv'] = { ':vertical h ', { silent = false, desc = 'Prompt For Help On Vertical Split' } },
		['<leader>hs'] = { ':horizontal h ', { silent = false, desc = 'Prompt For Help On Horizontal Split' } },
		['<leader>hh'] = { ':h ', { silent = false, desc = 'Prompt For Help' } },
		['<leader>hT'] = { '<CMD>tab h<CR>', { desc = 'Open Help On New Tab' } },
		['<leader>hV'] = { '<CMD>vertical h<CR>', { desc = 'Open Help On Vertical Split' } },
		['<leader>hS'] = { '<CMD>horizontal h<CR>', { desc = 'Open Help On Horizontal Split' } },

		['<leader>wn'] = { '<C-w>w', { desc = 'Next Window' } },
		['<leader>wss'] = { '<CMD>split<CR>', { silent = false } },
		['<leader>wsv'] = { '<CMD>vsplit<CR>', { silent = false } },
		['<leader>wsS'] = { ':split ', { silent = false, desc = 'Horizontal Split (Interactively)' } },
		['<leader>wsV'] = { ':vsplit ', { silent = false, desc = 'Vertical Split (Interactively)' } },

		['<leader>qq'] = { '<CMD>qa<CR>' },
		['<leader>qQ'] = { '<CMD>qa!<CR>' },

		['<leader>tn'] = { '<CMD>tabN<CR>', { silent = false } },
		['<leader>tp'] = { '<CMD>tabp<CR>', { silent = false } },
		['<leader>td'] = { '<CMD>tabc<CR>', { silent = false } },
		['<leader>tD'] = { '<CMD>tabc!<CR>', { silent = false } },
		['<leader>tf'] = { '<CMD>tabfirst<CR>', { silent = false } },
		['<leader>tl'] = { '<CMD>tablast<CR>', { silent = false } },
		['<leader>ta'] = { ':tabnew ', { silent = false, desc = 'New Tab (Interactively)' } },
		['<leader>tA'] = { '<CMD>tabnew<CR>', { silent = false } },

		['<leader>bn'] = { '<CMD>bNext<CR>', { silent = false } },
		['<leader>bp'] = { '<CMD>bprevious<CR>', { silent = false } },
		['<leader>bd'] = { '<CMD>bdel<CR>', { silent = false } },
		['<leader>bD'] = { '<CMD>bdel!<CR>', { silent = false } },
		['<leader>bf'] = { '<CMD>bfirst<CR>', { silent = false } },
		['<leader>bl'] = { '<CMD>blast<CR>', { silent = false } },

		['<leader>Ll'] = { '<CMD>Lazy<CR>' },
		['<leader>LL'] = { ':Lazy ', { silent = false, desc = 'Select `Lazy` Operation (Interactively)' } },
		['<leader>Ls'] = { '<CMD>Lazy sync<CR>' },
		['<leader>Lx'] = { '<CMD>Lazy clean<CR>' },
		['<leader>Lc'] = { '<CMD>Lazy check<CR>' },
		['<leader>Li'] = { '<CMD>Lazy install<CR>' },
		['<leader>Lr'] = { '<CMD>Lazy reload<CR>' },
	},
	--- WARNING: DO NOT USE `<CMD>`!!!
	v = {
		['<leader>s'] = { ':sort<CR>', { desc = 'Sort' } },
		['<leader>S'] = { ':sort!<CR>', { desc = 'Sort (Reverse)' } },

		['<leader>f'] = { ':foldopen<CR>', { desc = 'Open Fold' } },
		['<leader>F'] = { ':foldclose<CR>', { desc = 'Open Fold' } },

		['<leader>r'] = { ':s/', { silent = false, desc = 'Run Search-Replace Interactively' } },
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
	local func = Kmap[mode]

	for lhs, v in next, t do
		if not (is_fun(v[1]) or is_str(v[1])) then
			goto continue
		end

		v[2] = is_tbl(v[2]) and v[2] or {}

		func(lhs, v[1], v[2])

		::continue::
	end
end

---@type fun(T: CscSubMod|ODSubMod): boolean
local function csc_check(T)
	return is_tbl(T) and is_fun(T.setup)
end

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
	-- A table containing various possible colorschemes.
	local Csc = Pkg.colorschemes

	-- Reorder to your liking.
	if csc_check(Csc.tokyonight) then
		Csc.tokyonight.setup()
	elseif csc_check(Csc.onedark) then
		Csc.onedark.setup()
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

-- Call the user file associations
if is_fun(User.assoc) then
	User.assoc()
end

vim.g.markdown_minlines = 500

vim.cmd([[
filetype plugin indent on
syntax on
]])
