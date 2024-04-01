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

local has_words_before = function()
	unpack = unpack or table.unpack
	local buf_lines = api.nvim_buf_get_lines
	local win_cursor = api.nvim_win_get_cursor
	local line, col = unpack(win_cursor(0))
	return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local Luasnip = require('luasnip')
local cmp = require('cmp')

require('lazy_cfg.cmp.luasnip')
local sks = require('lazy_cfg.cmp.kinds')

local tab_map = {
	---@param fallback fun()
	i = function(fallback)
		local jumpable = Luasnip.expand_or_locally_jumpable
		local opts = { behavior = cmp.SelectBehavior.Select }

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
	end,
	---@param fallback fun()
	s = function(fallback)
		local jumpable = Luasnip.expand_or_locally_jumpable
		local opts = { behavior = cmp.SelectBehavior.Select }

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
	end,
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

local cr_map = {
	---@param fallback fun()
	i = function(fallback)
		local opts = { behavior = cmp.ConfirmBehavior.Replace, select = false }

		if cmp.visible() and cmp.get_selected_entry() then
			cmp.confirm(opts)
		else
			fallback()
		end
	end,
	---@param fallback fun()
	s = function(fallback)
		local opts = { select = true }

		if cmp.visible() and cmp.get_selected_entry() then
			cmp.confirm(opts)
		else
			fallback()
		end
	end,
	---@param fallback fun()
	c = function(fallback)
		local opts = { cmp.ConfirmBehavior.Replace, select = true }

		if cmp.visible() and cmp.get_selected_entry() then
			cmp.confirm(opts)
		else
			fallback()
		end
	end,
}

---@param fallback fun()
local bs_map = function(fallback)
	if cmp.visible() then
		cmp.close()
	end
	fallback()
end

cmp.setup({
	---@return boolean
	enabled = function()
		local Context = require('cmp.config.context')

		if get_mode().mode == 'c' then
			return true
		end

		local grammar_check = (not Context.in_treesitter_capture('comment') and not Context.in_syntax_group)
		return grammar_check
	end,

	snippet = {
		expand = function(args)
			Luasnip.lsp_expand(args.body)
		end,
	},

	view = sks.view,

	formatting = sks.formatting,

	matching = {
		disallow_fuzzy_matching = true,
		disallow_fullfuzzy_matching = false,
		disallow_prefix_unmatching = false,
		disallow_partial_matching = false,
		disallow_partial_fuzzy_matching = true,
	},

	window = sks.window,

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
	}, {
		{ name = 'luasnip' },
		{ name = 'buffer' },
	}),
})

cmp.setup.filetype({ 'bash', 'sh' }, {
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
