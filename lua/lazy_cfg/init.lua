---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lazy
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local in_console = Check.in_console
local desc = kmap.desc

local fs_stat = vim.uv.fs_stat
local stdpath = vim.fn.stdpath
local system = vim.fn.system

-- Set installation dir for `Lazy`.
local lazypath = stdpath('data') .. '/lazy/lazy.nvim'

-- Install `Lazy` automatically.
if not fs_stat(lazypath) then
	system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		lazypath,
	})
end

-- Add `Lazy` to runtimepath
vim.opt.rtp:prepend(lazypath)

--- Returns the string for the `build` field for `LuaSnip` depending on certain conditions.
--- ---
--- ## Return
--- ---
--- ### Unix
--- **The return string could be empty** or something akin to
--- ```sh
--- make install_jsregexp
--- ```
--- If `nproc` is found in `PATH` or a valid executable then the string could look like
--- ```sh
--- make -j"$(nproc)" install_jsregexp
--- ```
--- ---
--- ### Windows
--- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
--- ---
---@type fun(): string
local function luasnip_build()
	local cmd = executable('nproc') and 'make -j"$(nproc)" install_jsregexp' or 'make install_jsregexp'

	if is_windows and executable('mingw32-make') then
		cmd = 'mingw32-' .. cmd
	elseif is_windows and not executable('make') then
		cmd = ''
	end

	return cmd
end

--- Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions.
--- ---
--- ## Return
--- ---
--- ### Unix
--- **The return string could be empty** or something akin to
--- ```sh
--- make
--- ```
--- If `nproc` is found in `PATH` or a valid executable then the string could look like
--- ```sh
--- make -j"$(nproc)"
--- ```
--- ---
--- ### Windows
--- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
--- ---
---@type fun(): string
local function tel_fzf_build()
	local cmd = executable('nproc') and 'make -j"$(nproc)"' or 'make'

	if is_windows and executable('mingw32-make') then
		cmd = 'mingw32-' .. cmd
	elseif is_windows and not executable('make') then
		cmd = ''
	end

	return cmd
end

local Lazy = require('lazy')

--- A `config` function to call your plugins.
--- ---
--- ## Parameters
--- * `mod_str` This parameter must comply with the following format:
--- ```lua
--- "lazy_cfg.<plugin_name>[.<...>]"
--- ```
--- ---
--- ## Return
--- A function that attempts to `require` the given `mod_str`.
--- ---
---@type fun(mod_str: string): fun()
local function source(mod_str)
	return function()
		exists(mod_str, true)
	end
end

--- Set the global condition for a later submodule call.
--- ---
--- ## Parameters
--- * `field`: Either a **string** that will be the name of a vim `g:...` variable, or
---	a **dictionary** with the keys as the vim `g:...` variable names, and the value
---	as whatever said variables are set to respectively.
--- ---
--- ## Return
--- A **function** that sets the pre-loading for the colorscheme and initializes the `g:field` variable(s).
--- ---
---@type fun(field: string|table<string, any>): fun()
local function colorscheme_init(fields)
	if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
		error('(lazy_cfg:colorscheme_init): Unable to initialize colorscheme.')
	end

	return function()
		vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
		if is_str(fields) then
			vim.g[fields] = 1
		else
			for field, val in next, fields do
				vim.g[field] = val
			end
		end
	end
end

---@type table<string, LazyPlugs>
local M = {}

--- Colorscheme Plugins
M.COLORSCHEMES = {
	{
		'navarasu/onedark.nvim',
		priority = 1000,
		name = 'OneDark',
		main = 'onedark',
		version = false,
		init = colorscheme_init('installed_onedark'),
	},
	{
		'catppuccin/nvim',
		priority = 1000,
		name = 'catppuccin',
		main = 'catppuccin',
		version = false,
		init = colorscheme_init('installed_catppuccin'),
	},
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		name = 'tokyonight',
		main = 'tokyonight',
		version = false,
		init = colorscheme_init('installed_tokyonight'),
	},
	{
		'EdenEast/nightfox.nvim',
		priority = 1000,
		name = 'nightfox',
		main = 'nightfox',
		version = false,
		init = colorscheme_init('installed_nightfox'),
	},
	{
		'bkegley/gloombuddy',
		priority = 1000,
		version = false,
		dependencies = { 'colorbuddy' },
		init = colorscheme_init('installed_gloombuddy'),
	},
	{
		'vigoux/oak',
		lazy = false,
		priority = 1000,
		version = false,
		init = colorscheme_init({
			['installed_oak'] = 1,
			['oak_virtualtext_bg'] = 1,
		}),
	},
	{
		'tjdevries/colorbuddy.vim',
		lazy = false,
		priority = 1000,
		name = 'colorbuddy',
		version = false,
		init = colorscheme_init('installed_colorbuddy'),
	},
	{
		'pineapplegiant/spaceduck',
		lazy = false,
		priority = 1000,
		version = false,
		init = colorscheme_init('installed_spaceduck'),
	},
	{
		'dracula/vim',
		lazy = false,
		priority = 1000,
		name = 'dracula',
		version = false,
		init = colorscheme_init('installed_dracula'),
	},
	{
		'liuchengxu/space-vim-dark',
		lazy = false,
		priority = 1000,
		version = false,
		init = colorscheme_init('installed_space_vim_dark'),
	},
	{
		'tomasr/molokai',
		lazy = false,
		priority = 1000,
		version = false,
		init = colorscheme_init('installed_molokai'),
	},
	{
		'colepeters/spacemacs-theme.vim',
		lazy = false,
		priority = 1000,
		name = 'spacemacs',
		version = false,
		init = colorscheme_init('installed_spacemacs'),
	},
}
--- Essential Plugins
M.ESSENTIAL = {
	{
		'dstein64/vim-startuptime',
		cmd = 'StartupTime',
		keys = {
			{
				'<leader>vs',
				function()
					vim.cmd('StartupTime')
				end,
				desc = 'Run StartupTime',
			},
		},
		name = 'StartupTime',
		version = false,
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		'LintaoAmons/scratch.nvim',
		event = 'VeryLazy',
		name = 'Scratch',
		version = false,
		enabled = false,
	},
	{ 'vim-scripts/L9', lazy = false },
	{
		'echasnovski/mini.nvim',
		name = 'Mini',
		version = false,
		config = source('lazy_cfg.mini'),
		enabled = not in_console(),
	},
	{
		'tiagovla/scope.nvim',
		event = 'VimEnter',
		priority = 1000,
		name = 'Scope',
		version = false,
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.opt.hid = true

			-- NOTE: Required for `scope`
			vim.opt.sessionoptions = {
				'buffers',
				'tabpages',
				'globals',
			}
		end,
		config = source('lazy_cfg.scope'),
	},

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		name = 'Plenary',
		version = false,
	},
	{
		'nvim-lua/popup.nvim',
		name = 'Popup',
		main = 'popup',
		version = false,
		dependencies = { 'Plenary' },
		enabled = not in_console(),
	},

	{
		'rcarriga/nvim-notify',
		priority = 1000,
		name = 'Notify',
		main = 'notify',
		version = false,
		dependencies = { 'Plenary' },
		init = function()
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.notify'),
		enabled = not in_console(),
	},

	{
		'lewis6991/hover.nvim',
		name = 'Hover',
		main = 'hover',
		version = false,
		config = source('lazy_cfg.hover'),
		enabled = not in_console(),
	},

	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
		name = 'web-devicons',
		version = false,
		enabled = not in_console(),
	},
}

-- Nvim Configurations
M.NVIM = {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		priority = 1000,
		name = 'which_key',
		main = 'which-key',
		version = false,
		init = function()
			vim.opt.timeout = true
			vim.opt.timeoutlen = 300
			vim.opt.ttimeout = true
			vim.opt.ttimeoutlen = -1
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.which_key'),
	},
	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		name = 'Dashboard',
		version = false,
		dependencies = { 'web-devicons' },
		config = source('lazy_cfg.dashboard'),
		enabled = false,
	},
	{
		'startup-nvim/startup.nvim',
		event = 'VimEnter',
		name = 'Startup',
		version = false,
		dependencies = {
			'Telescope',
			'Plenary',
		},
		config = source('lazy_cfg.startup'),
		-- enabled = false,
	},
	{
		'folke/persistence.nvim',
		event = 'BufReadPre',
		name = 'Persistence',
		config = source('lazy_cfg.persistence'),
	},
}

--- Treesitter Plugins
M.TS = {
	{
		'nvim-treesitter/nvim-treesitter',
		name = 'treesitter',
		build = ':TSUpdate',
		version = false,
		dependencies = {
			'ts-context',
			'ts-commentstring',
		},
		config = source('lazy_cfg.treesitter'),
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		lazy = true,
		name = 'ts-context',
		version = false,
		enabled = not in_console(),
	},
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		lazy = true,
		name = 'ts-commentstring',
	},
}
--- Editing Utils
M.EDITING = {
	{
		'numToStr/Comment.nvim',
		name = 'Comment',
		version = false,
		dependencies = {
			'treesitter',
			'ts-commentstring',
		},
		config = source('lazy_cfg.Comment'),
	},

	{
		'tpope/vim-endwise',
		lazy = false,
		name = 'EndWise',
		version = false,
	},
	-- TODO COMMENTS
	{
		'folke/todo-comments.nvim',
		name = 'todo-comments',
		version = false,
		dependencies = {
			'treesitter',
			'Plenary',
		},
		config = source('lazy_cfg.todo_comments'),
		enabled = executable('rg'),
	},
	{
		'windwp/nvim-autopairs',
		name = 'AutoPairs',
		main = 'nvim-autopairs',
		version = false,
		config = source('lazy_cfg.autopairs'),
	},
	{
		'glepnir/template.nvim',
		name = 'Template',
		config = source('lazy_cfg.template'),
		enabled = false,
	},
}
--- Version Control Plugins
M.VCS = {
	{
		'tpope/vim-fugitive',
		lazy = false,
		name = 'Fugitive',
		version = false,
		enabled = executable('git'),
	},
	{
		'lewis6991/gitsigns.nvim',
		name = 'GitSigns',
		version = false,
		config = source('lazy_cfg.gitsigns'),
		enabled = executable('git'),
	},
	{
		'sindrets/diffview.nvim',
		name = 'DiffView',
		version = false,
		config = source('lazy_cfg.diffview'),
		enabled = executable('git'),
	},
}
--- LSP Plugins
M.LSP = {
	{
		'neovim/nvim-lspconfig',
		name = 'lspconfig',
		version = false,
		dependencies = {
			'NeoDev',
			'NeoConf',
			'Trouble',
			'SchemaStore',
		},
		config = source('lazy_cfg.lspconfig'),
		enabled = vim_has('nvim-0.8'), -- Constraint specified in the repo
	},
	{
		'b0o/SchemaStore',
		lazy = true,
		name = 'SchemaStore',
		version = false,
		enabled = executable('vscode-json-language-server'),
	},
	-- Essential for Nvim Lua files.
	{
		'folke/neodev.nvim',
		name = 'NeoDev',
		version = false,
		dependencies = { 'NeoConf' },
		enabled = executable('lua-language-server'),
	},
	{
		'folke/neoconf.nvim',
		name = 'NeoConf',
		version = false,
	},
	{
		'folke/trouble.nvim',
		name = 'Trouble',
		version = false,
		dependencies = { 'web-devicons' },
		enabled = not in_console(),
	},
	{
		'p00f/clangd_extensions.nvim',
		ft = { 'c', 'cpp' },
		name = 'clangd_exts',
		version = false,
		config = source('lazy_cfg.lspconfig.clangd'),
		enabled = executable('clangd') and not in_console(),
	},
}
--- Completion and `cmp`-related Plugins
M.COMPLETION = {
	{
		'hrsh7th/nvim-cmp',
		event = { 'InsertEnter', 'CmdlineEnter' },
		name = 'cmp',
		version = false,
		dependencies = {
			'treesitter',
			'lspconfig',
			'onsails/lspkind.nvim',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-document-symbol',
			'hrsh7th/cmp-nvim-lsp-signature-help',

			'hrsh7th/cmp-buffer',

			'hrsh7th/cmp-path',
			'https://codeberg.org/FelipeLema/cmp-async-path',

			'petertriho/cmp-git',
			'davidsierradz/cmp-conventionalcommits',

			'cmp-vlime',

			'hrsh7th/cmp-nvim-lua',

			'hrsh7th/cmp-cmdline',

			'saadparwaiz1/cmp_luasnip',
			'LuaSnip',
		},
		init = function()
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
			vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
		end,
		config = source('lazy_cfg.cmp'),
	},
	{
		'L3MON4D3/LuaSnip',
		event = { 'InsertEnter', 'CmdlineEnter' },
		version = false,
		dependencies = { 'friendly-snippets' },
		build = luasnip_build(),
	},
	{
		'rafamadriz/friendly-snippets',
		ft = 'gitcommit',
		version = false,
	},
	{
		'HiPhish/nvim-cmp-vlime',
		ft = 'lisp',
		name = 'cmp-vlime',
		version = false,
		dependencies = { 'VLime' },
	},
	{
		'vlime/vlime',
		ft = 'lisp',
		name = 'VLime',
		version = false,
	},
}
-- Telescope
M.TELESCOPE = {
	{
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		name = 'Telescope',
		version = false,
		dependencies = {
			'Telescope-fzf',
			'treesitter',
			'lspconfig',
			'Plenary',
			'Project',
		},
		config = source('lazy_cfg.telescope'),
		enabled = not in_console(),
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		lazy = true,
		name = 'Telescope-fzf',
		version = false,
		build = tel_fzf_build(),
		enabled = executable('fzf'),
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		lazy = false,
		name = 'Project',
		main = 'project_nvim',
		version = false,
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.o.autochdir = true
		end,
		config = source('lazy_cfg.project'),
		--- NOTE: Disabled to supress warnings from version bump v0.11.0
		--- until further notice.
		-- enabled = not vim_has('nvim-0.11'),
	},
}
--- UI Plugins
M.UI = {
	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		priority = 1000,
		name = 'LuaLine',
		version = false,
		dependencies = { 'web-devicons' },
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.opt.showmode = false
		end,
		config = source('lazy_cfg.lualine'),
		enabled = not in_console(),
	},
	-- Tabline
	{
		'akinsho/bufferline.nvim',
		priority = 1000,
		name = 'BufferLine',
		version = false,
		dependencies = {
			'web-devicons',
			'Scope',
		},
		init = function()
			vim.opt.stal = 2
			vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
		end,
		config = source('lazy_cfg.bufferline'),
		-- enabled = not in_console(),
		enabled = false,
	},
	-- Tabline
	{
		'romgrk/barbar.nvim',
		priority = 1000,
		name = 'BarBar',
		version = false,
		dependencies = {
			'GitSigns',
			'web-devicons',
			'Scope',
		},
		init = function()
			vim.opt.stal = 2
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.barbar'),
		enabled = not in_console(),
	},
	-- Indent Scope
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		name = 'ibl',
		version = false,
		dependencies = { 'rainbow_delimiters' },
		config = source('lazy_cfg.blank_line'),
		-- enabled = not in_console(),
		enabled = false,
	},
	{
		'HiPhish/rainbow-delimiters.nvim',
		name = 'rainbow_delimiters',
		version = false,
		config = source('lazy_cfg.rainbow_delimiters'),
		enabled = not in_console(),
	},
	-- File Tree
	{
		'nvim-tree/nvim-tree.lua',
		name = 'nvim_tree',
		main = 'nvim-tree',
		version = false,
		dependencies = {
			'web-devicons',
			'Mini',
		},
		init = function()
			-- Disable `netrw`.
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
		end,
		config = source('lazy_cfg.nvim_tree'),
	},
	{
		'nvim-neo-tree/neo-tree.nvim',
		name = 'NeoTree',
		version = false,
		dependencies = {
			'Plenary',
			'web-devicons',
			'MunifTanjim/nui.nvim',
			-- '3rd/image.nvim',
		},
		init = function()
			-- Disable `netrw`.
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
		end,
		config = source('lazy_cfg.neo_tree'),
		enabled = false,
	},
	{
		'nvim-zh/colorful-winsep.nvim',
		event = { 'WinNew' },
		name = 'ColorfulWinsep',
		version = false,
		config = source('lazy_cfg.colorful_winsep'),
		enabled = not in_console(),
	},
	{
		'norcalli/nvim-colorizer.lua',
		name = 'colorizer',
		version = false,
		config = source('lazy_cfg.colorizer'),
		--- NOTE: Disabled to supress warnings from version bump v0.11.0
		--- until further notice.
		enabled = not vim_has('nvim-0.11'),
	},
	{
		'akinsho/toggleterm.nvim',
		name = 'ToggleTerm',
		version = false,
		config = source('lazy_cfg.toggleterm'),
		enabled = not in_console(),
	},
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		name = 'Noice',
		version = false,
		dependencies = {
			'MunifTanjim/nui.nvim',
			'Notify',
			'Mini',
			'cmp',
			'treesitter',
		},
		config = source('lazy_cfg.noice'),
		enabled = not in_console(),
	},
	{
		'LudoPinelli/comment-box.nvim',
		name = 'CommentBox',
		version = false,
		config = source('lazy_cfg.commentbox'),
		enabled = false,
	},
}
-- File Syntax Plugins
M.SYNTAX = {
	{
		'rhysd/vim-syntax-codeowners',
		name = 'codeowners-syntax',
		version = false,
	},
	{
		'vim-scripts/DoxygenToolkit.vim',
		name = 'DoxygenToolkit',
		version = false,
		enabled = executable('doxygen'),
	},
}

M.UTILS = {
	{
		'iamcco/markdown-preview.nvim',
		name = 'md_preview',
		build = executable('yarn') and 'cd app && yarn install' or '',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		config = source('lazy_cfg.md_preview'),
		enabled = not in_console(),
	},
}

---@type LazyPlugs
local T = {}

--- INFO: Setup.
for _, plugs in next, M do
	for _, p in next, plugs do
		table.insert(T, p)
	end
end
Lazy.setup(T)

---@type LazyMods
local P = {
	colorschemes = require('lazy_cfg.colorschemes'),
}

---@type fun(cmd: 'ed'|'tabnew'|'split'|'vsplit'): fun()
local key_variant = function(cmd)
	cmd = (is_str(cmd) and vim.tbl_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'ed'

	cmd = cmd .. ' '

	return function()
		local full_cmd = cmd .. stdpath('config') .. '/lua/lazy_cfg/init.lua'

		vim.cmd(full_cmd)
	end
end

---@type table<MapModes, KeyMapDict>
local Keys = {
	n = {
		['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
		['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
		['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
		['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
		['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
		['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
		['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
		['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
		['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
		['<leader>Lr'] = { Lazy.reload, desc('Reload Lazy Plugins') },
		['<leader>LL'] = { ':Lazy ', desc('Select `Lazy` Operation (Interactively)', false) },
	},
	v = {
		['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
		['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
		['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
		['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
		['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
		['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
		['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
		['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
		['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
		['<leader>Lr'] = { Lazy.reload, desc('Reload Lazy Plugins') },
	},
}
---@type table<MapModes, RegKeysNamed>
local Names = {
	n = {
		['<leader>L'] = { name = '+Lazy' },
		['<leader>Le'] = { name = '+Edit Lazy File' },
	},
	v = {
		['<leader>L'] = { name = '+Lazy' },
		['<leader>Le'] = { name = '+Edit Lazy File' },
	},
}

for mode, maps in next, Keys do
	if WK.available() then
		if is_tbl(Names[mode]) and not empty(Names[mode]) then
			WK.register(Names[mode], { mode = mode })
		end
		WK.register(WK.convert_dict(maps), { mode = mode })
	else
		for lhs, v in next, maps do
			local msg = '(lazy_cfg): Could not set keymap `' .. lhs .. '`'
			if not (is_str(v[1]) or is_fun(v[1])) then
				vim.notify(msg)
				goto continue
			end

			v[2] = is_tbl(v[2]) and v[2] or {}
			kmap[mode](lhs, v[1], v[2])

			::continue::
		end
	end
end

return P
