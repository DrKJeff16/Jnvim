---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil

if not exists('nvim-treesitter') then
	return
end

local fs_stat = vim.uv.fs_stat
local buf_name = vim.api.nvim_buf_get_name

local Ts = require('nvim-treesitter')
local Cfg = require('nvim-treesitter.configs')
local Install = require('nvim-treesitter.install')
local TSUtils = require('nvim-treesitter.ts_utils')

Install.prefer_git = true

local ensure = {
	'asm',
	'arduino',
	'bash',
	'c',
	'cmake',
	'comment',
	'commonlisp',
	'cpp',
	'css',
	'csv',
	'diff',
	'doxygen',
	'git_config',
	'git_rebase',
	'gitattributes',
	'gitcommit',
	'gitignore',
	'glsl',
	'gpg',
	'html',
	'ini',
	'json',
	'json5',
	'jsonc',
	'julia',
	'kconfig',
	'latex',
	'lua',
	'luadoc',
	'luap',
	'luau',
	'markdown',
	'markdown_inline',
	'meson',
	'ninja',
	'objdump',
	'passwd',
	'python',
	'query',
	'readline',
	'regex',
	'rst',
	'scss',
	'ssh_config',
	'templ',
	'tmux',
	'todotxt',
	'toml',
	'udev',
	'vim',
	'vimdoc',
	'xml',
	'yaml',
}

---@type TSConfig
local TSConfig = {
	auto_install = true,
	sync_install = false,
	ignore_install = {},
	ensure_installed = ensure,

	highlight = {
		enable = true,

		---@type fun(lang: string, buf: integer): boolean
		disable = function(lang, buf)
			local max_fs = 1024 * 1024
			local ok, stats = pcall(fs_stat, buf_name(buf))

			local disable_ft = {
				'config',
				'cfg',
				'conf',
			}

			local res = false

			if vim.tbl_contains(disable_ft, vim.api.nvim_get_option_value('ft', { scope = 'local' })) then
				res = true
			end

			return res or ok and not is_nil(stats) and stats.size > max_fs
		end,
		additional_vim_regex_highlighting = false,
	},

	indent = { enable = false },
	incremental_selection = { enable = false },
	modules = {},
}

Cfg.setup(TSConfig)

exists('lazy_cfg.treesitter.context', true)

if exists('ts_context_commentstring') then
	require('ts_context_commentstring').setup({
		enable_autocmd = true,
	})
end
