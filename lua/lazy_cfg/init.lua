---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local lazy_t = User.types.lazy

local exists = Check.exists.module
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local nmap = User.maps.kmap.n

local fs_stat = vim.uv.fs_stat
local stdpath = vim.fn.stdpath
local system = vim.fn.system

-- Set installation dir for `Lazy`.
local lazypath = stdpath('data') .. '/lazy/lazy.nvim'

-- Install `Lazy` automatically.
if not fs_stat(lazypath) or not exists('lazy') then
	system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
end

-- Add `Lazy` to runtimepath
vim.opt.rtp:prepend(lazypath)

---@type fun(): string
local function luasnip_build()
	if not executable({ 'make', 'mingw32-make' }) then
		return ''
	end

	local cmd = executable('nproc') and 'make -j"$(nproc)" install_jsregexp' or 'make install_jsregexp'

	if is_windows and executable('mingw32-make') then
		cmd = 'mingw32-' .. cmd
	elseif is_windows and not executable('mingw32-make') then
		cmd = ''
	end

	return cmd
end

local Lazy = require('lazy')

--- A `config` function to call your plugins.
--- ---
--- Param `mod_str` must comply with this format:
--- ```lua
--- 'lazy_cfg.<plugin_name>[.<...>]'
--- ```
--- If the module is not found, a warninr is raised
--- and returns `true`.
---@type fun(mod_str: string): fun()
local function source(mod_str)
	return function()
		exists(mod_str, true)
	end
end

---@type fun(field: string): fun()
local function colorscheme_init(field)
	if not is_str(field) or empty(field) then
		error('Unable to initialize colorscheme.')
	end

	return function()
		vim.opt.termguicolors = vim_exists('+termguicolors')
		vim.g[field] = 1
	end
end

---@type table<string, LazyPlugs>
local M = {}

-- Colorschemes
M.COLORSCHEMES = {
	{
		'navarasu/onedark.nvim',
		priority = 1000,
		name = 'OneDark',
		version = false,
		init = colorscheme_init('installed_onedark'),
	},
	{
		'catppuccin/nvim',
		priority = 1000,
		name = 'catppuccin',
		version = false,
		init = colorscheme_init('installed_catppuccin'),
	},
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		name = 'tokyonight',
		version = false,
		init = colorscheme_init('installed_tokyonight'),
	},
	{
		'EdenEast/nightfox.nvim',
		priority = 1000,
		name = 'nightfox',
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
		priority = 1000,
		version = false,
		init = colorscheme_init('installed_oak'),
	},
	{
		'tjdevries/colorbuddy.vim',
		lazy = true,
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
		-- Set the global condition for a later
		-- submodule call.
		init = colorscheme_init('installed_spaceduck'),
	},
	{
		'dracula/vim',
		lazy = false,
		priority = 1000,
		name = 'dracula',
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = colorscheme_init('installed_dracula'),
	},
	{
		'liuchengxu/space-vim-dark',
		lazy = false,
		priority = 1000,
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = colorscheme_init('installed_space_vim_dark'),
	},
	{
		'tomasr/molokai',
		lazy = false,
		priority = 1000,
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = colorscheme_init('installed_molokai'),
	},
	{
		'colepeters/spacemacs-theme.vim',
		lazy = false,
		priority = 1000,
		name = 'spacemacs',
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = colorscheme_init('installed_spacemacs'),
	},
}
-- Essential Plugins
M.ESSENTIAL = {
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		keys = {
			{ '<leader>vs', function() vim.cmd('StartupTime') end, desc = 'Run StartupTime' }
		},
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		'LintaoAmons/scratch.nvim',
		event = 'VeryLazy',
		name = 'Scratch',
		version = false,
	},
	{ 'vim-scripts/L9', lazy = false },
	{
		'echasnovski/mini.nvim',
		name = 'Mini',
		version = false,
		config = source('lazy_cfg.mini'),
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
				"buffers",
				"tabpages",
				"globals",
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
	},

	{
		'rcarriga/nvim-notify',
		lazy = false,
		priority = 1000,
		name = 'Notify',
		main = 'notify',
		version = false,
		dependencies = { 'Plenary' },
		init = function()
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.notify'),
	},

	{
		'lewis6991/hover.nvim',
		name = 'Hover',
		main = 'hover',
		version = false,
		config = source('lazy_cfg.hover'),
	},

	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
		name = 'web-devicons',
		version = false,
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
		enabled = false,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = vim.opt.sessionoptions:get(),
		},
		-- stylua: ignore
		keys = {
			{
				'<leader>Sr',
				function()
					require('persistence').load()
				end,
				desc = 'Restore Session',
			},
			{
				'<leader>Sl',
				function()
					require('persistence').load({ last = true })
				end,
				desc = 'Restore Last Session',
			},
			{
				'<leader>Sd',
				function()
					require('persistence').stop()
				end,
				desc = 'Don\'t Save Current Session',
			},
		},
	},
}

-- Treesitter
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
	},
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		lazy = true,
		name = 'ts-commentstring',
	},
}
-- Editing Utils
M.EDITING = {
	{
		'numToStr/Comment.nvim',
		name = 'Comment',
		dependencies = {
			'treesitter',
			'ts-commentstring',
		},
		config = source('lazy_cfg.Comment'),
	},

	{ 'tpope/vim-endwise', lazy = false, name = 'EndWise' },
	-- TODO COMMENTS
	{
		'folke/todo-comments.nvim',
		event = 'BufWinEnter',
		name = 'todo-comments',
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
-- Version Control
M.VCS = {
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive', enabled = executable('git') },
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
		--- NOTE: Disabled to supress warnings from version bump v0.11.0
		--- until further notice.
		-- enabled = executable('git'),
		enabled = not vim_has('nvim-0.11'),
	},
}
-- LSP
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
		cmd = { 'Trouble', 'TroubleClose', 'TroubleRefresh', 'TroubleToggle' },
		name = 'Trouble',
		version = false,
		dependencies = { 'web-devicons' },
	},
	{
		'p00f/clangd_extensions.nvim',
		ft = { 'c', 'cpp' },
		name = 'clangd_exts',
		config = source('lazy_cfg.lspconfig.clangd'),
		--- NOTE: Disabled to supress warnings from version bump v0.11.0
		--- until further notice.
		-- enabled = executable('clangd'),
		enabled = not vim_has('nvim-0.11'),
	},
}
-- Completion and `cmp` related
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
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-nvim-lsp-document-symbol',
			'hrsh7th/cmp-nvim-lsp-signature-help',

			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'petertriho/cmp-git',
			'davidsierradz/cmp-conventionalcommits',
			'HiPhish/nvim-cmp-vlime',
			'https://codeberg.org/FelipeLema/cmp-async-path',
			'hrsh7th/cmp-cmdline',

			'saadparwaiz1/cmp_luasnip',
			'LuaSnip',
		},
		init = function()
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
		end,
		config = source('lazy_cfg.cmp'),
	},
	{ 'hrsh7th/cmp-nvim-lsp', lazy = true, main = 'cmp_nvim_lsp' },
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		version = false,
		dependencies = { 'friendly-snippets' },
		build = luasnip_build(),
	},
	{
		'rafamadriz/friendly-snippets',
		lazy = true,
		version = false
	},
	{
		'HiPhish/nvim-cmp-vlime',
		lazy = true,
		dependencies = { 'VLime' },
	},
	{
		'vlime/vlime',
		lazy = true,
		name = 'VLime',
	},
}
-- Telescope
M.TELESCOPE = {
	{
		'nvim-telescope/telescope.nvim',
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
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		lazy = true,
		name = 'Telescope-fzf',
		version = false,
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = function()
			local nproc = (exists('nproc') and { 'make', '-j"$(nproc)"' } or { 'make' })

			if _G.is_windows and executable('mingw32-make') then
				nproc[1] = 'mingw32-' .. nproc[1]
			elseif _G.is_windows and not executable('mingw32-make') then
				return
			end

			system(nproc)
		end,
		enabled = executable('fzf'),
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		lazy = false,
		name = 'Project',
		version = false,
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.o.autochdir = true
		end,
		config = source('lazy_cfg.project'),
		--- NOTE: Disabled to supress warnings from version bump v0.11.0
		--- until further notice.
		enabled = not vim_has('nvim-0.11'),
	},
}
-- UI Customizations
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
	},
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
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.bufferline'),
		enabled = false,
	},
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
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		name = 'ibl',
		version = false,
		dependencies = { 'rainbow_delimiters' },
		config = source('lazy_cfg.blank_line'),
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		name = 'rainbow_delimiters',
		version = false,
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

			vim.opt.termguicolors = vim_exists('+termguicolors')
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

			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.neo_tree'),
		enabled = false,
	},
	{
		'norcalli/nvim-colorizer.lua',
		name = 'colorizer',
		version = false,
		config = source('lazy_cfg.colorizer'),
	},
	{
		'akinsho/toggleterm.nvim',
		name = 'ToggleTerm',
		version = false,
		config = source('lazy_cfg.toggleterm'),
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		name = 'Noice',
		version = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"Notify",
			'Mini',
			'cmp',
		},
		config = source('lazy_cfg.noice'),
		enabled = not vim_has('nvim-0.11'),
	},
	{
		'LudoPinelli/comment-box.nvim',
		name = 'CommentBox',
		config = source('lazy_cfg.commentbox'),
		enabled = false,
	},
}
-- File Syntax Plugins
M.SYNTAX = {
	{ 'rhysd/vim-syntax-codeowners',    name = 'codeowners-syntax' },
	{ 'vim-scripts/DoxygenToolkit.vim', name = 'DoxygenToolkit', enabled = executable('doxygen') },
}

M.UTILS = {
	{
		'iamcco/markdown-preview.nvim',
		ft = { 'markdown' },
		name = 'md_preview',
		build = executable('yarn') and 'cd app && yarn install' or '',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		config = source('lazy_cfg.md_preview'),
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

---@type KeyMapDict
local Keys = {
	['<leader>Lee'] = { key_variant('ed'), { desc = 'Open `Lazy` File' } },
	['<leader>Les'] = { key_variant('split'), { desc = 'Open `Lazy` File Horizontal Window' } },
	['<leader>Let'] = { key_variant('tabnew'), { desc = 'Open `Lazy` File Tab' } },
	['<leader>Lev'] = { key_variant('vsplit'), { desc = 'Open `Lazy`File Vertical Window' } },
}

for lhs, v in next, Keys do
	if not (is_str(v[1]) or is_fun(v[1])) then
		goto continue
	end

	local rhs = v[1]
	local opts = is_tbl(v[2]) and v[2] or {}

	nmap(lhs, rhs, opts)

	::continue::
end

return P
