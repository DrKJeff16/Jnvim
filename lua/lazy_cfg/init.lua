---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local kmap = User.maps.kmap
local lazy_t = User.types.lazy

local exists = Check.exists.module
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local is_str = Check.value.is_str
local nmap = kmap.n

local fn = vim.fn
local api = vim.api
local rtp = vim.opt.rtp

local fs_stat = vim.loop.fs_stat
local stdpath = fn.stdpath
local system = fn.system
local au = api.nvim_create_autocmd

-- Set installation dir for `Lazy`.
local lazypath = stdpath('data') .. '/lazy/lazy.nvim'

-- Install `Lazy` automatically.
if not fs_stat(lazypath) or not exists('lazy')  then
	system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
end

-- Add `Lazy` to `stdpath`
rtp:prepend(lazypath)

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

---@type table<string, LazyPlugs>
local M = {}

M.ESSENTIAL = {
	{ 'vim-scripts/L9', lazy = false },
	-- WARN: `checkhealth` issues.
	-- TODO: Solve config issues down the line.
	{
		'anuvyklack/hydra.nvim',
		lazy = false,
		name = 'Hydra',
		enabled = false,
	},
	{
		'echasnovski/mini.nvim',
		name = 'Mini',
		version = false,
		config = source('lazy_cfg.mini'),
	},
	{
		'tiagovla/scope.nvim',
		lazy = false,
		name = 'Scope',
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
	},
	{
		'nvim-lua/popup.nvim',
		name = 'Popup',
		dependencies = { 'Plenary' },
	},

	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
		name = 'web-devicons',
		version = false,
	},
}

M.NVIM = {
	{ 'tpope/vim-sensible', enabled = false },
	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		name = 'Dashboard',
		version = false,
		dependencies = { 'web-devicons' },
		config = source('lazy_cfg.dashboard'),
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
}

M.TS = {
	-- Treesitter.
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		name = 'treesitter',
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
M.EDITING = {
	{
		'numToStr/Comment.nvim',
		event = 'InsertEnter',
		name = 'Comment',
		dependencies = {
			'treesitter',
			'ts-commentstring',
		},
		config = source('lazy_cfg.Comment'),
	},

	{ 'tpope/vim-endwise', lazy = false, name = 'EndWise' },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive', enabled = executable('git') },
	{ 'tpope/vim-speeddating', enabled = false },
	-- TODO COMMENTS
	{
		'folke/todo-comments.nvim',
		event =  'BufWinEnter',
		name = 'todo-comments',
		dependencies = {
			'treesitter',
			'Plenary',
		},
		config = source('lazy_cfg.todo_comments'),
	},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		name = 'AutoPairs',
		main = 'nvim-autopairs',
		version = false,
		config = source('lazy_cfg.autopairs'),
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
		enabled = false,
		-- enabled = executable('git'),
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
			'b0o/SchemaStore',
			'clangd_exts',
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
	-- Essenyial for Nvim Lua files.
	{
		'folke/neodev.nvim',
		name = 'NeoDev',
		version = false,
		dependencies = { 'NeoConf' },
		enabled = executable('lua-language-server',
		function()
			local msg = 'No `lua-language-server` in `PATH`!'
			if exists('notify') then
				require('notify')(msg, 'error')
			else
				error(msg)
			end
		end
			),
	},
	{
		'folke/neoconf.nvim',
		name = 'NeoConf',
		version = false,
		enabled = executable('vscode-json-language-server',
		function()
			local msg = 'No `vscode-json-language-server` in `PATH`!'
			if exists('notify') then
				require('notify')(msg, 'error')
			else
				error(msg)
			end
		end
			),
	},
	-- TODO: Make submodule.
	{
		'folke/trouble.nvim',
		lazy = true,
		name = 'Trouble',
		version = false,
		dependencies = { 'web-devicons' },
		enabled = false,
	},
	{
		'p00f/clangd_extensions.nvim',
		lazy = true,
		name = 'clangd_exts',
		config = source('lazy_cfg.lspconfig.clangd'),
		enabled = executable('clangd',
		function()
			local msg = 'No `clangd` in `PATH`!'
			if exists('notify') then
				require('notify')(msg, 'warn')
			else
				print(msg)
			end
		end
		),
	},
	{
		'tamago324/nlsp-settings.nvim',
		lazy = true,
		name = 'nlsp-settings',
		dependencies = {
			'MasonLSP',
			'Notify',
		},
	},
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		name = 'MasonLSP',
		dependencies = { 'Mason' },
	},
	{
		'williamboman/mason.nvim',
		lazy = true,
		cmd = { 'Mason' },
		name = 'Mason',
	},
	{
		'antosha417/nvim-lsp-file-operations',
		lazy = true,
		name = 'Lsp_FileOps',
		enabled = false,
	},
}
-- Colorschemes
M.COLORSCHEMES = {
	{
		'pineapplegiant/spaceduck',
		lazy = false,
		priority = 1000,
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_spaceduck = 1
		end,
	},
	{
		'dracula/vim',
		lazy = false,
		priority = 1000,
		name = 'dracula',
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_dracula = 1
		end,
	},
	{
		'liuchengxu/space-vim-dark',
		lazy = false,
		priority = 1000,
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_space_vim_dark = 1
		end,
	},
	{
		'tomasr/molokai',
		lazy = false,
		priority = 1000,
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_molokai = 1
		end,
	},
	{
		'colepeters/spacemacs-theme.vim',
		lazy = false,
		priority = 1000,
		name = 'spacemacs',
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_spacemacs = 1
		end,
	},
	{
		'joshdick/onedark.vim',
		lazy = false,
		priority = 1000,
		name = 'onedark',
		version = false,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_onedark = 1
		end,
	},
	{
		'catppuccin/nvim',
		lazy = true,
		priority = 1000,
		name = 'catppuccin',
		version = false,
	},
	{
		'folke/tokyonight.nvim',
		lazy = true,
		priority = 1000,
		name = 'tokyonight',
		version = false,
	},
	{
		'vigoux/oak',
		lazy = true,
		priority = 1000,
		version = false,
	},
	{
		'bkegley/gloombuddy',
		lazy = true,
		priority = 1000,
		version = false,
		dependencies = { 'colorbuddy' },
	},
	{
		'tjdevries/colorbuddy.vim',
		lazy = true,
		priority = 1000,
		name = 'colorbuddy',
		version = false,
	},
	{
		'EdenEast/nightfox.nvim',
		lazy = true,
		priority = 1000,
		name = 'nightfox',
		version = false,
	},
}
M.CMP = {
	-- Completion Engine
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
			'FelipeLema/cmp-async-path',
			'hrsh7th/cmp-cmdline',

			'saadparwaiz1/cmp_luasnip',
			'LuaSnip',
		},
		init = function()
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
		end,
		config = source('lazy_cfg.cmp'),
	},
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		version = false,
		dependencies = { 'friendly-snippets' },
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = function()
			local nproc = (exists('nproc') and { 'make', '-j"$(nproc)"', 'install_jsregexp' } or { 'make', 'install_jsregexp' })

			if _G.is_windows and executable('mingw32-make') then
				nproc[1] = 'mingw32-' .. nproc[1]
			elseif _G.is_windows and not executable('mingw32-make') then
				return
			end

			system(nproc)
		end,
	},
	{ 'rafamadriz/friendly-snippets', lazy = true, version = false },
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
M.TELESCOPE = {
	-- Telescope
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
		enabled = executable({ 'fzf', 'nproc' }),
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
	},
}
M.UI = {
	{
		'rcarriga/nvim-notify',
		lazy = false,
		priority = 1000,
		name = 'Notify',
		version = false,
		dependencies = { 'Plenary' },
		init = function()
			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.notify'),
	},
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
		dependencies = { 'rainbow-delimiters' },
		config = source('lazy_cfg.blank_line'),
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		name = 'rainbow-delimiters',
		version = false,
	},
	-- File Tree
	{
		'nvim-tree/nvim-tree.lua',
		name = 'nvim_tree',
		version = false,
		dependencies = {
			'web-devicons',
			'Lsp_FileOps',
			'Mini',
			'Hydra',
		},
		-- Disable `netrw`.
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			vim.opt.termguicolors = vim_exists('+termguicolors')
		end,
		config = source('lazy_cfg.nvim_tree'),
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
		'folke/which-key.nvim',
		event = 'VeryLazy',
		priprity = 1000,
		name = 'which_key',
		version = false,
		init = function()
			vim.opt.timeout = true
			vim.opt.timeoutlen = 300
		end,
		config = source('lazy_cfg.which_key'),
	},
	{
		'LudoPinelli/comment-box.nvim',
		lazy = false,
		name = 'CommentBox',
		config = source('lazy_cfg.commentbox'),
		enabled = false,
	},
}

M.SYNTAX = {
	{
		'rhysd/vim-syntax-codeowners',
		lazy = false,
		name = 'codeowners-syntax',
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
	colorschemes = exists('lazy_cfg.colorschemes', true),
}

---@type fun(cmd: string): fun()
local key_variant = function(cmd)
	local CMDS = {
		'ed',
		'split',
		'vsplit',
		'tabnew',
	}

	if not is_str(cmd) or not vim.tbl_contains(CMDS, cmd) then
		cmd = 'ed'
	end

	return function()
		local full_cmd = cmd .. ' ' .. stdpath('config') .. '/lua/lazy_cfg/init.lua'

		vim.cmd(cmd)
	end
end

nmap('<leader>Let', key_variant('tabnew'), { desc = 'Open `Lazy` File Tab' })
nmap('<leader>Lee', key_variant('ed'), { desc = 'Open `Lazy` File' })
nmap('<leader>Les', key_variant('split'), { desc = 'Open `Lazy` File Horizontal Window' })
nmap('<leader>Lev', key_variant('vsplit'), { desc = 'Open `Lazy`File Vertical Window' })

return P
