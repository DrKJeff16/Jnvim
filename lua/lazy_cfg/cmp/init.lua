---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local types = User.types.cmp
local exists = User.check.exists.module

local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local api = vim.api
local set = vim.o
local opt = vim.opt
local bo = vim.bo

local tbl_contains = vim.tbl_contains
local get_mode = api.nvim_get_mode

---@return boolean
local has_words_before = function()
	unpack = unpack or table.unpack
	local buf_lines = api.nvim_buf_get_lines
	local win_cursor = api.nvim_win_get_cursor
	local line, col = unpack(win_cursor(0))
	return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local Luasnip = require('lazy_cfg.cmp.luasnip')
local cmp = require('cmp')
local sks = require('lazy_cfg.cmp.kinds')

local Util = require('lazy_cfg.cmp.util')
local n_select = Util.n_select
local n_shift_select = Util.n_shift_select
local tab_map = Util.tab_map
local s_tab_map = Util.s_tab_map
local cr_map = Util.cr_map
local bs_map = Util.bs_map

cmp.setup({
	---@return boolean
	enabled = function()
		local opt_val = api.nvim_get_option_value

		---@type string
		local ft = opt_val('ft', { scope = 'local' })
		local enable_comments = {
			'bash',
			'c',
			'cpp',
			'css',
			'gitcommit',
			'html',
			'java',
			'lisp',
			'lua',
			'markdown',
			'python',
			'sh',
		}

		if tbl_contains(enable_comments, ft) then
			return true
		end

		local Context = require('cmp.config.context')

		if get_mode().mode == 'c' then
			return true
		end

		return not Context.in_treesitter_capture('comment') and not Context.in_syntax_group('Comment')
	end,

	snippet = {
		---@param args cmp.SnippetExpansionParams
		expand = function(args)
			Luasnip.lsp_expand(args.body)
		end,
	},

	view = sks.view,
	formatting = sks.formatting,
	window = sks.window,

	matching = {
		disallow_fuzzy_matching = false,
		disallow_fullfuzzy_matching = true,
		disallow_prefix_unmatching = false,
		disallow_partial_matching = false,
		disallow_partial_fuzzy_matching = true,
		disallow_symbol_nonprefix_matching = true,
	},

	mapping = cmp.mapping.preset.insert({
		['<C-j>'] = cmp.mapping.scroll_docs(-4),
		['<C-k>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping(cr_map),
		['<Tab>'] = cmp.mapping(tab_map),
		['<S-Tab>'] = cmp.mapping(s_tab_map),
		['<BS>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
		['<Down>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
		['<Up>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
		['<Right>'] = cmp.mapping(bs_map, { 'i', 's' }),
		['<Left>'] = cmp.mapping(bs_map, { 'i', 's' }),
	}),

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
		{ name = 'conventionalcommits' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp_document_symbol' },
	}, {
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{
			name = 'cmdline',
			option = {
				treat_trailing_slash = false,
			},
		},
	})
})

-- sks.vscode()

-- For debugging.
if vim.notify then
	vim.notify('cmp loaded.')
end
