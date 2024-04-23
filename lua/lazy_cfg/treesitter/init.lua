---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local exists = Check.exists.module

local is_nil = Check.value.is_nil

if not exists('nvim-treesitter') then
	return
end

local Ts = require('nvim-treesitter')
local Cfg = require('nvim-treesitter.configs')
local Install = require('nvim-treesitter.install')
local TSUtils = require('nvim-treesitter.ts_utils')

Install.prefer_git = true

local ensure = {
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
	'json',
	'json5',
	'jsonc',
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

---@param ens string[]
---@param t TSConfig
---@return string[], TSConfig
local function add_org(ens, t)
	local Orgmode = require('orgmode')
	local org_dir = '~/.org'
	-- Orgmode.setup_ts_grammar()

	table.insert(ens, 'org')

	---@type OrgDefaultConfig
	local org_opts = {
		org_agenda_files = org_dir..'/agenda/*',
		org_default_notes_file = org_dir..'/notes/default.org',
		org_hide_emphasis_markers = false,
	}

	Orgmode.setup()

	t.highlight = t.highlight or { enable = true }
	t.highlight.additional_vim_regex_highlighting = { 'org' }

	return ens, t
end

---@type TSConfig
local TSConfig = {
	auto_install = true,
	sync_install = false,
	ignore_install = {},
	ensure_installed = ensure,

	highlight = {
		enable = true,

		---@param buf integer The bufnumber.
		---@param lang? string The filetype.
		---@return boolean
		disable = function(lang, buf)
			local max_fs = 512 * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

			return ok and not is_nil(stats) and stats.size > max_fs
		end,
		additional_vim_regex_highlighting = false,
	},

	indent = { enable = false },
	incremental_selection = { enable = false },
	modules = {},
}

-- if exists('ts-rainbow') and exists('lazy_cfg.treesitter.rainbow') then
-- 	TSConfig.rainbow = require('lazy_cfg.treesitter.rainbow').rainbow
-- end

-- if exists('orgmode') then
-- 	ensure, TSConfig = add_org(ensure, TSConfig)
-- end

local modules = {
	'context',
	'rainbow',
}

for _, s in next, modules do
	local path = 'lazy_cfg.treesitter.'..s
	if exists(path) then
		require(path)
	end
end

if exists('ts_context_commentstring') then
	require('ts_context_commentstring').setup({
		enable_autocmd = true,
	})
end

Cfg.setup(TSConfig)
