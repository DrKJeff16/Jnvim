local User = require('user')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_fun = Check.value.is_fun

local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local api = vim.api
local set = vim.o
local opt = vim.opt
local bo = vim.bo

local tbl_contains = vim.tbl_contains
local get_mode = api.nvim_get_mode

local Luasnip = require('lazy_cfg.cmp.luasnip')
local cmp = require('cmp')
local Sks = require('lazy_cfg.cmp.kinds')
local Util = require('lazy_cfg.cmp.util')

local tab_map = Util.tab_map
local s_tab_map = Util.s_tab_map
local cr_map = Util.cr_map

local has_words_before = Util.has_words_before
local n_select = Util.n_select
local n_shift_select = Util.n_shift_select
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
			'codeowners',
			'cpp',
			'css',
			'gitattributes',
			'gitconfig',
			'gitignore',
			'html',
			'java',
			'jsonc',
			'less',
			'lisp',
			'lua',
			'markdown',
			'python',
			'scss',
			'sh',
			'zsh',
		}

		if tbl_contains(enable_comments, ft) then
			return true
		end

		local disable_ft = {
			'NvimTree',
			'TelescopePrompt',
			'lazy',
		}

		if tbl_contains(disable_ft, ft) then
			return false
		end

		if get_mode().mode == 'c' then
			return true
		end

		local Context = require('cmp.config.context')

		return not Context.in_treesitter_capture('comment') and not Context.in_syntax_group('Comment')
	end,

	snippet = {
		---@param args cmp.SnippetExpansionParams
		expand = function(args)
			Luasnip.lsp_expand(args.body)
		end,
	},

	completion = {
		completeopt = 'menu,menuone,noselect,noinsert,preview',
		keyword_length = 1,
	},

	view = Sks.view,
	formatting = Sks.formatting,
	window = Sks.window,

	matching = {
		disallow_fullfuzzy_matching = true,
		disallow_fuzzy_matching = false,
		disallow_partial_fuzzy_matching = true,
		disallow_partial_matching = false,
		disallow_prefix_unmatching = true,
		disallow_symbol_nonprefix_matching = true,
	},

	mapping = cmp.mapping.preset.insert({
		['<C-j>'] = cmp.mapping.scroll_docs(-4),
		['<C-k>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(), -- Same as `<Esc>`
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
		{ name = 'nvim_lsp',                priority = 1 },
		{ name = 'luasnip',                 priority = 2 },
		{ name = 'nvim_lsp_signature_help', priority = 3 },
		{ name = 'buffer',                  priority = 4 },
	}),
})

cmp.setup.filetype({ 'sh', 'bash', 'zsh' }, {
	sources = cmp.config.sources({
		{ name = 'nvim_lsp',                priority = 1 },
		{ name = 'async_path',              priority = 2 },
		{ name = 'luasnip',                 priority = 3 },
		{ name = 'nvim_lsp_signature_help', priority = 4 },
		{ name = 'buffer',                  priority = 5 },
	})
})

cmp.setup.filetype('lisp', {
	sources = cmp.config.sources({
		{ name = 'vlime',  priority = 1 },
		{ name = 'buffer', priority = 2 },
	})
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git',                 priority = 3 },
		{ name = 'conventionalcommits', priority = 2 },
		{ name = 'luasnip',             priority = 1 },
		{ name = 'buffer',              priority = 4 },
	}),
})

require('cmp_git').setup()

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp_document_symbol', priority = 1 },
		{ name = 'buffer',                   priority = 2 },
	}),
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{
			name = 'cmdline',
			priority = 1,
			option = { treat_trailing_slash = false },
		},
		{ name = 'async_path', priority = 2 },
	})
})

if is_fun(Sks.vscode) then
	Sks.vscode()
end

-- For debugging.
if exists('notify') then
	local Notify = require('notify')

	Notify('cmp loaded.', 'info', {
		title = 'cmp',
	})
else
	print('cmp loaded.')
end
