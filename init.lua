---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Types = User.types -- Import docstrings and annotations.
local maps_t = Types.user.maps
local Kmap = User.maps.kmap
local WK = User.maps.wk
local Util = User.util
local Notify = Util.notify

local exists = Check.exists.module -- Checks for missing modules
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local vim_has = Check.exists.vim_has
local nop = User.maps.nop
local desc = Kmap.desc
local ft_get = Util.ft_get
local notify = Notify.notify

_G.is_windows = vim_has('win32')

-- Set `<Space>` as Leader Key.
nop('<Space>', desc('Leader Key', true, nil, true))
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
	"'",
	'!',
	'"',
	'A',
	'B',
	'C',
	'G',
	'I',
	'L',
	'O',
	'P',
	'S',
	'U',
	'V',
	'W',
	'X',
	'a',
	'b',
	'c',
	'd',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'o',
	'p',
	'r',
	's',
	'v',
	'w',
	'x',
	'z',
}
for _, mode in next, User.maps.modes do
	nop(NOP, {}, mode, '<leader>')
end

---@type Maps
local Keys = {
	n = {
		['<Esc><Esc>'] = { vim.cmd.nohls, desc('Remove Highlighted Search') },

		['<leader>fr'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false) },
		['<leader>fir'] = { ':%retab<CR>', desc('Retab File') },
		['<leader>fs'] = { ':w<CR>', desc('Save File', false) },
		['<leader>fS'] = { ':w ', desc('Save File (Prompt)', false) },
		['<leader>fvl'] = {
			function()
				local ft = Util.ft_get()
				local err_msg = 'Filetype' .. ft .. ' not sourceable by Lua'

				if ft == 'lua' then
					vim.cmd('luafile %')
					notify('Sourced current Lua file')
				else
					notify(err_msg, 'error', { title = 'Lua' })
				end
			end,
			desc('Source Current File As Lua File'),
		},
		['<leader>fvv'] = {
			function()
				local ft = Util.ft_get()
				local err_msg = 'Filetype' .. ft .. ' not sourceable by Vim'

				if ft == 'vim' then
					vim.cmd('so %')
					notify('Sourced current Vim file')
				else
					notify(err_msg, 'error', { title = 'Vim' })
				end
			end,
			desc('Source Current File As VimScript File'),
		},
		['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false) },
		['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false) },

		['<leader>vet'] = { ':tabnew $MYVIMRC<CR>', desc('Open In New Tab') },
		['<leader>vee'] = { ':ed $MYVIMRC<CR>', desc('Open In Current Window') },
		['<leader>ves'] = { ':split $MYVIMRC<CR>', desc('Open In Horizontal Split') },
		['<leader>vev'] = { ':vsplit $MYVIMRC<CR>', desc('Open In Vertical Split') },
		['<leader>vh'] = { '<CMD>checkhealth<CR>', desc('Run Checkhealth', false) },
		['<leader>vs'] = {
			function()
				vim.cmd('luafile $MYVIMRC')
				notify('Sourced `init.lua`')
			end,
			desc('Source $MYVIMRC', false),
		},

		['<leader>ht'] = { ':tab h ', desc('Prompt For Help On New Tab', false) },
		['<leader>hv'] = { ':vertical h ', desc('Prompt For Help On Vertical Split', false) },
		['<leader>hs'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split', false) },
		['<leader>hh'] = { ':h ', desc('Prompt For Help', false) },
		['<leader>hT'] = { ':tab h<CR>', desc('Open Help On New Tab') },
		['<leader>hV'] = { ':vertical h<CR>', desc('Open Help On Vertical Split') },
		['<leader>hS'] = { ':horizontal h<CR>', desc('Open Help On Horizontal Split') },

		['<leader>wn'] = { '<C-w>w', desc('Cycle Window') },
		['<leader>wd'] = { '<C-w>q', desc('Close Window') },
		['<leader>wsS'] = { ':split ', desc('Horizontal Split (Prompt)', false) },
		['<leader>wsV'] = { ':vsplit ', desc('Vertical Split (Prompt)', false) },
		['<leader>wss'] = { ':split<CR>', desc('Horizontal Split', false) },
		['<leader>wsv'] = { ':vsplit<CR>', desc('Vertical Split', false) },

		['<leader>qq'] = { ':qa<CR>', desc('Quit Nvim') },
		['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },

		['<leader>ta'] = { ':tabnew ', desc('New Tab (Prompt)', false) },
		['<leader>tn'] = { ':tabN<CR>', desc('Next Tab', false) },
		['<leader>tp'] = { ':tabp<CR>', desc('Previous Tab', false) },
		['<leader>td'] = { ':tabc<CR>', desc('Close Tab', false) },
		['<leader>tD'] = { ':tabc!<CR>', desc('Close Tab Forcefully', false) },
		['<leader>tf'] = { ':tabfirst<CR>', desc('Goto First Tab', false) },
		['<leader>tl'] = { ':tablast<CR>', desc('Goto Last Tab', false) },
		['<leader>tA'] = { ':tabnew<CR>', desc('New Tab', false) },

		['<leader>bn'] = { ':bNext<CR>', desc('Next Buffer', false) },
		['<leader>bp'] = { ':bprevious<CR>', desc('Previous Buffer', false) },
		['<leader>bd'] = { ':bdel<CR>', desc('Close Buffer', false) },
		['<leader>bD'] = { ':bdel!<CR>', desc('Close Buffer Forcefully', false) },
		['<leader>bf'] = { ':bfirst<CR>', desc('Goto First Buffer', false) },
		['<leader>bl'] = { ':blast<CR>', desc('Goto Last Buffer', false) },
	},
	v = {
		['<leader>s'] = { ':sort<CR>', desc('Sort') },
		['<leader>S'] = { ':sort!<CR>', desc('Sort (Reverse)') },

		['<leader>f'] = { ':foldopen<CR>', desc('Open Fold') },
		['<leader>F'] = { ':foldclose<CR>', desc('Close Fold') },

		['<leader>r'] = { ':s/', desc('Run Search-Replace Prompt For Selection', false) },
		['<leader>ir'] = { ':retab<CR>', desc('Retab Selection') },
	},
}
---@type table<MapModes, RegKeysNamed>
local Names = {
	n = {
		--- File Handling
		['<leader>f'] = { name = '+File' },
		--- Script File Handling
		['<leader>fv'] = { name = '+Script Files' },
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

		--- Vim
		['<leader>v'] = { name = '+Vim' },
		--- `init.lua` Editing
		['<leader>ve'] = { name = '+Edit $MYVIMRC' },
	},
	v = {
		--- Indent Control
		['<leader>i'] = { name = '+Indent' },

		--- Vim
		['<leader>v'] = { name = '+Vim' },

		--- Help
		['<leader>h'] = { name = '+Help' },
	},
}

Kmap.t('<Esc>', '<C-\\><C-n>')

if not called_lazy then
	-- List of manually-callable plugins.
	_G.Pkg = require('lazy_cfg')
	_G.called_lazy = true
end

-- Set the keymaps previously stated
for mode, t in next, Names do
	if WK.available() then
		WK.register(Names[mode], { mode = mode })
	end

	User.maps.map_dict(Keys, 'wk.register', true, mode)
end

---@type fun(T: CscSubMod|ODSubMod): boolean
local function color_exists(T)
	return is_tbl(T) and is_fun(T.setup)
end

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
	-- A table containing various possible colorschemes.
	local Csc = Pkg.colorschemes

	---@type table<MapModes, KeyMapDict>
	local CscKeys = {
		n = {},
		v = {},
	}

	--- Reorder to your liking.
	---@type ('nightfox'|'tokyonight'|'catppuccin'|'onedark'|'spaceduck'|'spacemacs'|'molokai'|'dracula'|'oak'|'space_vim_dark')[]
	local selected = {
		'tokyonight',
		'catppuccin',
		'nightfox',
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

			for mode, _ in next, CscKeys do
				CscKeys[mode]['<leader>vc' .. tostring(i)] = { Csc[c].setup, desc('Setup Colorscheme `' .. c .. '`') }
			end

			i = i + 1
		end
	end

	---@type table<MapModes, RegKeysNamed>
	local NamesCsc = {
		n = { ['<leader>vc'] = { name = '+Colorschemes' } },
		v = { ['<leader>vc'] = { name = '+Colorschemes' } },
	}

	for mode, t in next, NamesCsc do
		if WK.available() then
			WK.register(NamesCsc[mode], { mode = mode })
		end

		User.maps.map_dict(CscKeys, 'wk.register', true, mode)
	end

	if not empty(found_csc) then
		Csc[selected[found_csc]].setup()
	end
end

-- Call the user file associations
Util.assoc()

vim.g.markdown_minlines = 500

require('user.distro.archlinux').setup()

vim.cmd([[
filetype plugin indent on
syntax on
]])
