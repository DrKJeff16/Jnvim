---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('nvim-treesitter') then
	return
end

local pfx = 'lazy_cfg.treesitter.'

local Ts = require('nvim-treesitter')
local Cfg = require('nvim-treesitter.configs')
local Install = require('nvim-treesitter.install')
local TSUtils = require('nvim-treesitter.ts_utils')

Install.prefer_git = true

local ensure = {
	'asm',
	'bash',
	'c',
	'cmake',
	'cpp',
	'css',
	'csv',
	'doxygen',
	'git_config',
	'git_rebase',
	'gitattributes',
	'gitcommit',
	'gitignore',
	'gpg',
	'html',
	'ini',
	'java',
	'json',
	'json5',
	'jsonc',
	'latex',
	'lua',
	'luadoc',
	'luap',
	'markdown',
	'markdown_inline',
	'meson',
	'ninja',
	'passwd',
	'python',
	'readline',
	'regex',
	'rst',
	'scss',
	'ssh_config',
	'todotxt',
	'toml',
	'vim',
	'vimdoc',
	'xml',
	'yaml',
}

local function add_org()
	local Orgmode = require('orgmode')
	local org_dir = '~/.org'
	Orgmode.setup_ts_grammar()

	table.insert(ensure, 'org')

	return Orgmode.setup({
		org_agenda_files = org_dir..'/agenda/*',
		org_default_notes_file = org_dir..'/notes/default.org'
	})
end

if exists('orgmode') then
	add_org()
end

---@return string[]
local additional_hl = function()
	---@type string[]
	local res = {}

	if exists('orgmode') then
		table.insert(res, 'org')
	end

	return res
end

---@type TSConfig
local TSConfig = {
	auto_install = true,
	sync_install = false,
	ensure_installed = ensure,

	highlight = {
		enable = true,

		---@param buf integer The bufnumber.
		---@param lang? string The filetype.
		---@return boolean
		disable = function(lang, buf)
			local max_fs = 512 * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

			if ok and stats and stats.size > max_fs then
				return true
			end

			return false
		end,
		additional_vim_regex_highlighting = additional_hl(),
	},

	indent = { enable = true, disable = { 'lua', 'bash' } },
	incremental_selection = { enable = false },
}

if exists('ts-rainbow') and exists('lazy_cfg.treesitter.rainbow') then
	TSConfig.rainbow = require('lazy_cfg.treesitter.rainbow').rainbow
end

---@type string[]
local modules = {
	'context',
	'rainbow',
}

for _, s in next, modules do
	local mod = pfx..s
	if exists(mod) then
		require(mod)
	end
end

Cfg.setup(TSConfig)

if exists('ts_context_commentstring') then
	require('ts_context_commentstring').setup({
		enable_autocmd = false,
	})
end
