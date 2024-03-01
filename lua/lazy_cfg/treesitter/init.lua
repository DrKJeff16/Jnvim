---@diagnostic disable:unused-local

local User = require('user')
local exists = User.exists

if not exists('nvim-treesitter') then
	return
end

local pfx = 'lazy_cfg.treesitter.'

local Ts = require('nvim-treesitter')
local Cfg = require('nvim-treesitter.configs')
local Install = require('nvim-treesitter.install')

Install.prefer_git = true

---@type string[]
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
	'javascript',
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
	'rust',
	'scss',
	'ssh_config',
	'todotxt',
	'toml',
	'vim',
	'vimdoc',
	'xml',
	'yaml',
}

if exists('orgmode') then
	local Orgmode = require('orgmode')
	local org_dir = '~/.org'
	Orgmode.setup_ts_grammar()

	table.insert(ensure, 'org')

	Orgmode.setup({
		org_agenda_files = org_dir..'/agenda/*',
		org_default_notes_file = org_dir..'/notes/default.org'
	})
end

---@return string[]|table|boolean
local additional_hl = function()
	---@type table<string>|table|boolean
	local res
	res = {}

	if exists('orgmode') then
		table.insert(res, 'org')
	end

	if #res == 0 or res == {} then
		res = false
	end

	return res
end

Cfg.setup({
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

	indent = { enable = true, disable = { 'lua' } },
})

---@type string[]
local Modules = {
	'context',
}

---@type { [string]: any }
local M = {}

for _, s in ipairs(Modules) do
	local mod = pfx..s
	M[s] = (exists(mod) and require(mod) or nil)
end

return M
