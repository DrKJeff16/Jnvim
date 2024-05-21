local User = require('user')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str

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

---@type SetupSources
local ft = {
	{
		{ 'sh', 'bash', 'crontab', 'zsh', 'html', 'markdown' },
		{
			sources = cmp.config.sources({
				{ name = 'nvim_lsp',                priority = 1 },
				async_path(2),
				{ name = 'nvim_lsp_signature_help', priority = 3 },
				{ name = 'luasnip',                 priority = 4 },
				buffer(5),
			}),
		},
	},
	{
		{ 'conf', 'config', 'cfg', 'confini' },
		{
			sources = cmp.config.sources({
				{ name = 'luasnip', priority = 1 },
				async_path(2),
				buffer(3),
			}),
		}
	},
	['lua'] = {
		sources = cmp.config.sources({
			{ name = 'nvim_lsp',                priority = 1 },
			{ name = 'nvim_lsp_signature_help', priority = 2 },
			{ name = 'nvim_lua',                priority = 3 },
			{ name = 'luasnip',                 priority = 4 },
			buffer(5),
		})
	},
	['lisp'] = {
		sources = cmp.config.sources({
			{ name = 'vlime',   priority = 1 },
			{ name = 'luasnip', priority = 2 },
			buffer(3),
		})
	},
	['gitcommit'] = {
		sources = cmp.config.sources({
			{ name = 'git',                 priority = 1 },
			{ name = 'conventionalcommits', priority = 2 },
			{ name = 'luasnip',             priority = 3 },
			async_path(4),
			buffer(5),
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
				{ name = 'nvim_lsp_document_symbol', priority = 1 },
				buffer(2),
			}),
		}
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
		matching = { disallow_symbol_nonprefix_matching = false },
	},
}

---@type Sources
local M = {
	setup = function(T)
		if is_tbl(T) then
			for k, v in next, T do
				if is_num(k) and is_tbl({ v[1], v[2] }, true) then
					table.insert(ft, v)
				elseif is_str(k) and is_tbl(v) then
					ft[k] = v
				elseif exists('notify') then
					require('notify')('Couldn\'t parse!', 'error', {
						title = '(lazy_cfg.cmp.sources)'
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
				error('Couldn\'t parse!')
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
				error('Couldn\'t parse!')
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
