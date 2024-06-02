---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Util = User.util
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local empty = Check.value.empty

local cmp = require('cmp')

---@type fun(priority: integer?): SourceBuf
local buffer = function(priority)
	---@type SourceBuf
	local res = {
		name = 'buffer',
		option = {
			-- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]]
			keyword_pattern = [[\k\+]],
			get_bufnrs = function()
				local bufs = {}
				for _, win in next, vim.api.nvim_list_wins() do
					bufs[vim.api.nvim_win_get_buf(win)] = true
				end
				return vim.tbl_keys(bufs)
			end,
		},
	}

	if is_num(priority) and priority >= 1 then
		res.priority = priority
	end

	return res
end

---@type fun(priority: integer?): SourceAPath
local async_path = function(priority)
	---@type SourceAPath
	local res = {
		name = 'async_path',
		option = {
			trailing_slash = true,
			label_trailing_slash = true,
			show_hidden_files_by_default = true,
		},
	}

	if is_num(priority) and priority >= 1 then
		res.priority = priority
	end

	return res
end

local lua_sources = {
	{ name = 'nvim_lsp', priority = 5 },
	{ name = 'nvim_lua', priority = 4 },
	{ name = 'nvim_lsp_signature_help', priority = 3 },
	{ name = 'luasnip', priority = 2 },
	buffer(1),
}

if exists('lazydev') then
	table.insert(lua_sources, {
		name = 'lazydev',
		group_index = 0,
		priority = 6,
	})
end

---@type SetupSources
local ft = {
	{
		{
			'sh',
			'bash',
			'crontab',
			'zsh',
			'html',
			'markdown',
			'json',
			'json5',
			'jsonc',
			'yaml',
		},
		{
			sources = cmp.config.sources({
				{ name = 'nvim_lsp', priority = 5 },
				async_path(4),
				{ name = 'nvim_lsp_signature_help', priority = 3 },
				{ name = 'luasnip', priority = 2 },
				buffer(1),
			}),
		},
	},
	{
		{ 'conf', 'config', 'cfg', 'confini', 'gitconfig' },
		{
			sources = cmp.config.sources({
				{ name = 'luasnip', priority = 2 },
				async_path(3),
				buffer(1),
			}),
		},
	},
	['lua'] = {
		sources = cmp.config.sources(lua_sources),
	},
	['lisp'] = {
		sources = cmp.config.sources({
			{ name = 'vlime', priority = 3 },
			{ name = 'luasnip', priority = 2 },
			buffer(1),
		}),
	},
	['gitcommit'] = {
		sources = cmp.config.sources({
			{ name = 'conventionalcommits', priority = 5 },
			{ name = 'git', priority = 4 },
			{ name = 'luasnip', priority = 2 },
			async_path(3),
			buffer(1),
		}),
	},
}

---@type SetupSources
local cmdline = {
	{
		{ '/', '?' },
		{
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp_document_symbol', priority = 2 },
				buffer(1),
			}),
		},
	},
	[':'] = {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{
				name = 'cmdline',
				option = { treat_trailing_slash = false },
				priority = 1,
			},
			async_path(2),
		}),

		---@diagnostic disable-next-line:missing-fields
		matching = { disallow_symbol_nonprefix_matching = false },
	},
}

---@type Sources
---@diagnostic disable-next-line:missing-fields
local M = {
	setup = function(T)
		if is_tbl(T) and not empty(T) then
			for k, v in next, T do
				if is_num(k) and is_tbl({ v[1], v[2] }, true) then
					table.insert(ft, v)
				elseif is_str(k) and is_tbl(v) then
					ft[k] = v
				else
					Util.notify.notify("(lazy_cfg.cmp.sources): Couldn't parse the input table value", 'error', {
						title = 'lazy_cfg.cmp.sources',
						timeout = 2000,
					})
				end
			end
		end

		for k, v in next, ft do
			if is_num(k) and is_tbl({ v[1], v[2] }, true) then
				local names = v[1]
				local opts = v[2]

				cmp.setup.filetype(names, opts)
			elseif is_str(k) and is_tbl(v) then
				cmp.setup.filetype(k, v)
			else
				error("Couldn't parse!")
			end
		end

		require('cmp_git').setup()

		for k, v in next, cmdline do
			if is_num(k) and is_tbl({ v[1], v[2] }, true) then
				local names = v[1]
				local opts = v[2]

				cmp.setup.cmdline(names, opts)
			elseif is_str(k) and is_tbl(v) then
				cmp.setup.cmdline(k, v)
			else
				error("Couldn't parse!")
			end
		end
	end,

	buffer = buffer,
	async_path = async_path,
}

function M.new()
	local self = setmetatable({}, { __index = M })

	self.new = M.new
	self.setup = M.setup
	self.buffer = M.buffer
	self.async_path = M.async_path

	return self
end

return M
