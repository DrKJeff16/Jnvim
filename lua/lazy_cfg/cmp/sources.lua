local User = require('user')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str

local cmp = require('cmp')

---@type SetupSources
local ft = {
	{
		{ 'sh', 'bash', 'crontab', 'zsh', 'html', 'markdown' },
		{
			sources = cmp.config.sources({
				{ name = 'nvim_lsp',                priority = 1 },
				{ name = 'async_path',              priority = 2 },
				{ name = 'luasnip',                 priority = 3 },
				{ name = 'nvim_lsp_signature_help', priority = 4 },
				{ name = 'buffer',                  priority = 5 },
			}),
		},
	},
	{
		{ 'conf', 'config', 'cfg', 'confini' },
		{
			sources = cmp.config.sources({
				{ name = 'luasnip', priority = 1 },
				{ name = 'async_path', priority = 2 },
				{ name = 'buffer', priority = 2 },
			}),
		}
	},
	['lisp'] = {
		sources = cmp.config.sources({
			{ name = 'vlime',   priority = 1 },
			{ name = 'luasnip', priority = 2 },
			{ name = 'buffer',  priority = 3 },
		})
	},
	['gitcommit'] = {
		sources = cmp.config.sources({
			{ name = 'git',                 priority = 1 },
			{ name = 'conventionalcommits', priority = 2 },
			{ name = 'luasnip',             priority = 3 },
			{ name = 'buffer',              priority = 4 },
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
				{ name = 'buffer',                   priority = 2 },
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
			{ name = 'async_path', priority = 2 },
		})
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

		require('cmp_git').setup()

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
}

function M.new()
	local self = setmetatable({}, { __index = M })
	self.new = M.new
	self.setup = M.setup

	return self
end

return M
