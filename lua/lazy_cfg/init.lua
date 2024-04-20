---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.check.exists.module
local types = User.types.lazy
local nmap = User.maps.kmap.n

local fn = vim.fn
local api = vim.api

local rtp = vim.opt.rtp
local fs_stat = vim.loop.fs_stat
local stdpath = fn.stdpath
local system = fn.system
local has = fn.has
local vim_exists = fn.exists
local executable = fn.executable
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- Set installation dir for `Lazy`.
local lazypath = stdpath('data') .. '/lazy/lazy.nvim'

-- Install `Lazy` automatically.
if not exists('lazy') or not fs_stat(lazypath) then
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
--- ---
---@param mod_str string
---@return true|fun()
local function source(mod_str)
	return function()
		if exists(mod_str) then
			require(mod_str)
		end
	end
end

---@type table<string, LazyPlugs>
local M = {}

M.ESSENTIAL = {
	{ 'vim-scripts/L9', lazy = false, priority = 1000 },
	{
		'echasnovski/mini.nvim',
		lazy = false,
		priority = 1000,
		name = 'Mini',
		version = false,
		config = source('lazy_cfg.mini'),
	},
	{
		'tiagovla/scope.nvim',
		lazy = false,
		priority = 1000,
		name = 'Scope',
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.opt.hid = true
		end,
		config = source('lazy_cfg.scope'),
	},

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		priority = 1000,
		name = 'Plenary',
		version = false,
	},
	{
		'nvim-lua/popup.nvim',
		lazy = false,
		priority = 1000,
		name = 'Popup',
		version = false,
		dependencies = { 'Plenary' },
	},

	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
		priority = 1000,
		name = 'web-devicons',
		version = false,
	},
}
M.TS = {
	-- Treesitter.
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		build = ':verbose TSUpdate',
		priority = 1000,
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
		name = 'Comment',
		dependencies = {
			'treesitter',
			'ts-commentstring',
		},
		config = source('lazy_cfg.Comment'),
	},

	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive', enabled = executable('git') == 1 },
	{ 'tpope/vim-speeddating', enabled = false },
	-- TODO COMMENTS
	{
		'folke/todo-comments.nvim',
		name = 'todo-comments',
		dependencies = {
			'treesitter',
			'Plenary',
		},
		config = source('lazy_cfg.todo_comments'),
	},
	{
		'windwp/nvim-autopairs',
		name = 'AutoPairs',
		config = source('lazy_cfg.autopairs'),
		enabled = false,
	},
	{
		'lewis6991/gitsigns.nvim',
		name = 'GitSigns',
		version = false,
		config = source('lazy_cfg.gitsigns'),
		enabled = executable('git') == 1,
	},
	{
		'sindrets/diffview.nvim',
		name = 'DiffView',
		config = source('lazy_cfg.diffview'),
	},
}
M.LSP = {
	-- LSP
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		priority = 1000,
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
	},
	-- Essenyial for Nvim Lua files.
	{
		'folke/neodev.nvim',
		lazy = false,
		priority = 1000,
		name = 'NeoDev',
		version = false,
		dependencies = { 'NeoConf' },
		enabled = executable('lua-language-server') == 1,
	},
	{
		'folke/neoconf.nvim',
		lazy = false,
		priority = 1000,
		name = 'NeoConf',
		version = false,
		dependencies = {
			'nlsp-settings',
		},
	},
	-- TODO: Make submodule.
	{
		'folke/trouble.nvim',
		name = 'Trouble',
		version = false,
		dependencies = { 'web-devicons' },
		opts = {},
		enabled = false,
	},
	{
		'p00f/clangd_extensions.nvim',
		lazy = true,
		ft = { 'c', 'cpp' },
		name = 'clangd_exts',
		config = source('lazy_cfg.lspconfig.clangd'),
		enabled = executable('clangd') == 1,
	},
	{
		'tamago324/nlsp-settings.nvim',
		lazy = true,
		name = 'nlsp-settings',
		dependencies = {
			'MasonLSP',
			'Notify',
		},
		enabled = false,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		name = 'MasonLSP',
		dependencies = { 'Mason' },
		enabled = false,
	},
	{
		'williamboman/mason.nvim',
		cmd = { 'Mason' },
		name = 'Mason',
		enabled = false,
	},
	{
		'antosha417/nvim-lsp-file-operations',
		lazy = true,
		name = 'Lsp_FileOps',
		enabled = false,
	},
}
M.COLORSCHEMES = {
	-- Colorschemes
	{
		'pineapplegiant/spaceduck',
		lazy = false,
		priority = 1000,
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
		main = 'catppuccin',
		version = false,
	},
	{
		'folke/tokyonight.nvim',
		lazy = true,
		priority = 1000,
		name = 'tokyonight',
		main = 'tokyonight',
		version = false,
	},
	{
		'vigoux/oak',
		lazy = true,
		priority = 1000,
	},
	{
		'bkegley/gloombuddy',
		lazy = true,
		priority = 1000,
		dependencies = { 'colorbuddy' },
	},
	{
		'tjdevries/colorbuddy.vim',
		lazy = true,
		priority = 1000,
		name = 'colorbuddy',
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
		priority = 1000,
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
			'FelipeLema/cmp-async-path',
			'hrsh7th/cmp-cmdline',
			'saadparwaiz1/cmp_luasnip',
			'LuaSnip',
		},
		init = function()
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
		end,
		config = source('lazy_cfg.cmp')
	},
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'friendly-snippets' },
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = (_G.is_windows and 'mingw32-make -j"$(nproc)" install_jsregexp' or 'make -j"$(nproc)" install_jsregexp'),
	},
	{ 'rafamadriz/friendly-snippets', lazy = false },
}
M.TELESCOPE = {
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		name = 'Telescope',
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
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = (_G.is_windows and 'mingw32-make -j"$(nproc)"' or 'make -j"$(nproc)"'),
		enabled = function()
			return executable('fzf') == 1
		end,
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		lazy = false,
		priority = 1000,
		name = 'Project',
		init = function()
			vim.opt.ls = 2
			vim.opt.stal = 2
			vim.opt.autochdir = false
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
		dependencies = { 'Plenary' },
		init = function()
			vim.opt.termguicolors = true
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
		dependencies = {
			'web-devicons',
			'Scope',
		},
		init = function()
			vim.opt.stal = 2
			vim.opt.termguicolors = true
		end,
		config = source('lazy_cfg.bufferline'),
		enabled = false,
	},
	{
		'romgrk/barbar.nvim',
		priority = 1000,
		name = 'BarBar',
		dependencies = {
			'GitSigns',
			'web-devicons',
			'Scope',
		},
		init = function()
			vim.opt.stal = 2
			vim.opt.termguicolors = true
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
		priority = 1000,
		name = 'nvim_tree',
		version = false,
		dependencies = {
			'web-devicons',
			'Lsp_FileOps',
			'Mini',
		},
		-- Disable `netrw`.
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = source('lazy_cfg.nvim_tree'),
	},
	{
		'norcalli/nvim-colorizer.lua',
		name = 'colorizer',
		version = '*',
		config = source('lazy_cfg.colorizer'),
	},
	{
		'akinsho/toggleterm.nvim',
		name = 'ToggleTerm',
		version = '*',
		config = source('lazy_cfg.toggleterm'),
	},
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		priority = 1000,
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
	colorschemes = require('lazy_cfg.colorschemes'),
}

nmap('<leader>Le', function()
	local cmd = 'tabnew ' .. stdpath('config') .. '/lua/lazy_cfg/init.lua'

	vim.cmd(cmd)
end, { desc = 'Open `Lazy` File' })

return P
