---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Types = User.types -- Import docstrings and annotations.
local maps_t = Types.user.maps
local Kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local vim_has = Check.exists.vim_has
local nop = User.maps.nop
local desc = Kmap.desc

_G.is_windows = vim_has('win32')

-- WARNING: DO NOT CHANGE ANYTHING BUT THE FIRST PARAMETER
--          Keymaps will break for yet unknown reasons.
--
-- Set `<Space>` as Leader Key.
nop('<Space>', User.maps.map.desc('Leader Key', true, true))
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable `netrw` regardless of whether `nvim_tree` exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Vim `:set ...` global options setter
local opts = User.opts

-- Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

-- Avoid executing Normal mode keys when attempting `<leader>` sequences.
local NOP = {
	"<leader>'",
	'<leader>!',
	'<leader>"',
	'<leader>A',
	'<leader>B',
	'<leader>C',
	'<leader>I',
	'<leader>L',
	'<leader>O',
	'<leader>P',
	'<leader>S',
	'<leader>U',
	'<leader>V',
	'<leader>W',
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
	'<leader>w',
	'<leader>x',
	'<leader>z',
}
for _, mode in next, User.maps.modes do
	nop(NOP, {}, mode)
end

---@type Maps
local map_tbl = {
	n = {
		['<Esc><Esc>'] = { ':nohls<CR>', desc('Remove Highlighted Search') },

		['<leader>fir'] = { ':%retab<CR>', desc('Retab File') },
		['<leader>fs'] = { ':w<CR>', desc('Save File', false) },
		['<leader>fS'] = { ':w ', desc('Save File (Interactively)', false) },
		['<leader>fvs'] = {
			function()
				vim.cmd('luafile $MYVIMRC')
				vim.notify('Sourced `init.lua`')
			end,
			desc('Source My `init.lua`', false),
		},
		['<leader>fvl'] = {
			function()
				local ft = vim.api.nvim_get_option_value('ft', { scope = 'local' })
				local err_msg = 'File not sourceable!'

				if ft == 'lua' then
					vim.cmd('luafile %')
					vim.notify('Sourced current Lua file')
				elseif not is_nil(Notify) then
					Notify(err_msg, 'error', { title = 'Lua' })
				elseif exists('notify') then
					require('notify')(err_msg, 'error', { title = 'Lua' })
				else
					vim.notify(err_msg, vim.log.levels.ERROR)
				end
			end,
			desc('Attempt to source current Lua file', false),
		},
		['<leader>fvv'] = {
			function()
				local ft = User.ft_get()
				local err_msg = 'File not sourceable!'

				if ft == 'vim' then
					vim.cmd('so %')
					vim.notify('Sourced current Vim file')
				elseif not is_nil(Notify) then
					Notify(err_msg, 'error', { title = 'Vim' })
				elseif exists('notify') then
					require('notify')(err_msg, 'error', { title = 'Vim' })
				else
					vim.notify(err_msg, vim.log.levels.ERROR)
				end
			end,
			desc('Attempt To source current Vim file', false),
		},
		['<leader>fvV'] = { ':so ', desc('Source VimScript File (Interactively)', false) },
		['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Interactively)', false) },
		['<leader>fvet'] = { ':tabnew $MYVIMRC<CR>', desc('Open In New Tab') },
		['<leader>fvee'] = { ':ed $MYVIMRC<CR>', desc('Open In Current Window') },
		['<leader>fves'] = { ':split $MYVIMRC<CR>', desc('Open In Horizontal Split') },
		['<leader>fvev'] = { ':vsplit $MYVIMRC<CR>', desc('Open In Vertical Split') },

		['<leader>vh'] = { ':checkhealth<CR>', desc('Run Checkhealth', false) },

		['<leader>ht'] = { ':tab h ', desc('Prompt For Help On New Tab', false) },
		['<leader>hv'] = { ':vertical h ', desc('Prompt For Help On Vertical Split', false) },
		['<leader>hs'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split', false) },
		['<leader>hh'] = { ':h ', desc('Prompt For Help', false) },
		['<leader>hT'] = { ':tab h<CR>', desc('Open Help On New Tab') },
		['<leader>hV'] = { ':vertical h<CR>', desc('Open Help On Vertical Split') },
		['<leader>hS'] = { ':horizontal h<CR>', desc('Open Help On Horizontal Split') },

		['<leader>wn'] = { '<C-w>w', desc('Next Window') },
		['<leader>wss'] = { ':split<CR>', desc('Horizontal Split', false) },
		['<leader>wsv'] = { ':vsplit<CR>', desc('Vertical Split', false) },
		['<leader>wsS'] = { ':split ', desc('Horizontal Split (Interactively)', false) },
		['<leader>wsV'] = { ':vsplit ', desc('Vertical Split (Interactively)', false) },

		['<leader>qq'] = { ':qa<CR>', desc('Quit Nvim') },
		['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },

		['<leader>tn'] = { ':tabN<CR>', desc('Next Tab', false) },
		['<leader>tp'] = { ':tabp<CR>', desc('Previous Tab', false) },
		['<leader>td'] = { ':tabc<CR>', desc('Close Tab', false) },
		['<leader>tD'] = { ':tabc!<CR>', desc('Close Tab (Forcefully)', false) },
		['<leader>tf'] = { ':tabfirst<CR>', desc('Goto First Tab', false) },
		['<leader>tl'] = { ':tablast<CR>', desc('Goto Last Tab', false) },
		['<leader>ta'] = { ':tabnew ', desc('New Tab (Interactively)', false) },
		['<leader>tA'] = { ':tabnew<CR>', desc('New Tab', false) },

		['<leader>bn'] = { ':bNext<CR>', desc('Next Buffer', false) },
		['<leader>bp'] = { ':bprevious<CR>', desc('Previous Buffer', false) },
		['<leader>bd'] = { ':bdel<CR>', desc('Close Buffer', false) },
		['<leader>bD'] = { ':bdel!<CR>', desc('Close Buffer (Forcefully)', false) },
		['<leader>bf'] = { ':bfirst<CR>', desc('Goto First Buffer', false) },
		['<leader>bl'] = { ':blast<CR>', desc('Goto Last Buffer', false) },
	},
	-- WARNING: DO NOT USE `:`!!!
	v = {
		['<leader>s'] = { ':sort<CR>', desc('Sort') },
		['<leader>S'] = { ':sort!<CR>', desc('Sort (Reverse)') },

		['<leader>f'] = { ':foldopen<CR>', desc('Open Fold') },
		['<leader>F'] = { ':foldclose<CR>', desc('Open Fold') },

		['<leader>r'] = { ':s/', desc('Run Search-Replace Interactively', false) },
		['<leader>ir'] = { ':%retab<CR>', desc('Retab Selection') },
	},
}
---@type table<MapModes, RegKeysNamed>
local Names = {
	n = {
		--- File Handling
		['<leader>f'] = { name = '+File' },
		--- Script File Handling
		['<leader>fv'] = { name = '+Script Files' },
		--- `init.lua` Editing
		['<leader>fve'] = { name = '+Edit `init.lua`' },
		--- Indent Control
		['<leader>fi'] = { name = '+Indent' },

		--- Tabs Handling
		['<leader>t'] = { name = '+Tabs' },

		--- Buffer Handling
		['<leader>b'] = { name = '+Buffer' },

		--- Window Handling
		['<leader>w'] = { name = '+Window' },

		--- Window Splitting
		['<leader>ws'] = { name = '+Split' },

		--- Exiting
		['<leader>q'] = { name = '+Quit Nvim' },

		--- Help
		['<leader>h'] = { name = '+Help' },

		--- Session
		['<leader>S'] = { name = '+Session' },

		--- Vim
		['<leader>v'] = { name = '+Vim' },
	},
	v = {
		--- Indent Control
		['<leader>i'] = { name = '+Indent' },
	},
}

Kmap.t('<Esc>', '<C-\\><C-n>')

if not called_lazy then
	-- List of manually-callable plugins.
	_G.Pkg = require('lazy_cfg')
	_G.called_lazy = true
end

-- Set the keymaps previously stated
for mode, t in next, map_tbl do
	if WK.available() then
		if is_tbl(Names[mode]) and not empty(Names[mode]) then
			WK.register(Names[mode], { mode = mode })
		end

		WK.register(WK.convert_dict(t), { mode = mode })
	else
		for lhs, v in next, t do
			v[2] = is_tbl(v[2]) and v[2] or {}
			Kmap[mode](lhs, v[1], v[2])
		end
	end
end

---@type fun(T: CscSubMod|ODSubMod): boolean
local function color_exists(T)
	return is_tbl(T) and is_fun(T.setup)
end

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
	-- A table containing various possible colorschemes.
	local Csc = Pkg.colorschemes

	---@type KeyMapDict
	local CscKeys = {}

	---@type ('nightfox'|'tokyonight'|'catppuccin'|'onedark'|'spaceduck'|'spacemacs'|'molokai'|'dracula'|'oak')[]
	local selected = {
		-- Reorder to your liking.
		'catppuccin',
		'nightfox',
		'tokyonight',
		'onedark',
		'spacemacs',
		'molokai',
		'oak',
		'spaceduck',
		'dracula',
	}

	local i = 1
	local found_csc = 0
	for _, c in next, selected do
		if color_exists(Csc[c]) then
			found_csc = found_csc == 0 and i or found_csc
			CscKeys['<leader>vc' .. tostring(i)] = { Csc[c].setup, desc('Setup Colorscheme `' .. c .. '`') }
			i = i + 1
		end
	end

	for _, mode in next, { 'n', 'v' } do
		if WK.available() then
			WK.register({ ['<leader>vc'] = { name = '+Colorschemes' } }, { mode = mode })
			WK.register(WK.convert_dict(CscKeys), { mode = mode })
		else
			for lhs, v in next, CscKeys do
				v[2] = is_tbl(v[2]) and v[2] or {}
				Kmap[mode](lhs, v[1], v[2])
			end
		end
	end

	if not empty(found_csc) then
		Csc[selected[found_csc]].setup()
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
