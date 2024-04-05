---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

local types = require('cmp.types')

local api = vim.api
local set = vim.o
local opt = vim.opt
local bo = vim.bo

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

---@param fallback fun()
local n_select = function(fallback)
	local jumpable = Luasnip.expand_or_locally_jumpable
	---@type cmp.SelectOption
	local opts = { behavior = cmp.SelectBehavior.Replace }

	if cmp.visible() then
		cmp.select_next_item(opts)
	elseif jumpable() then
		Luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
		if cmp.visible() then
			cmp.select_next_item(opts)
		end
	else
		fallback()
	end
end

---@param opts? cmp.ConfirmOption
---@return fun(fallback: fun())
local complete = function(opts)
	if not opts or vim.tbl_isempty(opts) then
		opts = { behavior = cmp.ConfirmBehavior.Insert, select = false }
	end
	return function(fallback)
		if cmp.visible() and cmp.get_selected_entry() then
			cmp.confirm(opts)
		else
			fallback()
		end
	end
end

---@class CmpMap
---@field i? fun(fallback: fun())
---@field s? fun(fallback: fun())
---@field c? fun(fallback: fun())

---@class TabMap: CmpMap
---@class CrMap: CmpMap

---@type TabMap
local tab_map = {
	i = n_select,
	s = n_select,
	---@param fallback fun()
	c = function(fallback)
		local opts = { behavior = cmp.SelectBehavior.Insert }

		if cmp.visible() then
			cmp.select_next_item(opts)
		elseif has_words_before() then
			cmp.complete()
		else
			fallback()
		end
	end,
}

---@type CrMap
local cr_map = {
	i = complete({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
	s = complete({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
	c = complete({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
}

---@param fallback fun()
local bs_map = function(fallback)
	if cmp.visible() then
		cmp.abort()
	end
	fallback()
end

cmp.setup({
	---@return boolean
	enabled = function()
		local opt_val = api.nvim_get_option_value

		---@type string
		local ft = opt_val('ft', { scope = 'local' })
		local enable_comments = {
			'lua',
			'c',
			'cpp',
			'python',
			'gitcommit',
			'gitignore',
		}

		if vim.tbl_contains(enable_comments, ft) then
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
		disallow_fuzzy_matching = true,
		disallow_fullfuzzy_matching = false,
		disallow_prefix_unmatching = false,
		disallow_partial_matching = false,
		disallow_partial_fuzzy_matching = true,
		disallow_symbol_nonprefix_matching = false,
	},

	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-j>'] = cmp.mapping.scroll_docs(-4),
		['<C-k>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping(cr_map),
		['<Tab>'] = cmp.mapping(tab_map),
		['<S-Tab>'] = cmp.config.disable,
		['<BS>'] = cmp.mapping(bs_map, { 'i', 's', 'c' }),
		['<Down>'] = cmp.config.disable,
		['<Up>'] = cmp.config.disable,
	}),

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'path' },
	}, {
		{ name = 'luasnip' },
		{ name = 'buffer' },
	}),
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'conventionalcommits' },
		{ name = 'buffer' },
	}, {
		{ name = 'luasnip' },
		{ name = 'git' },
	}),
})

cmp.setup.filetype({ 'org', 'orgagenda', 'orghelp' }, {
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{ name = 'orgmode' },
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

sks.vscode()

-- For debugging.
print('cmp loaded.')
