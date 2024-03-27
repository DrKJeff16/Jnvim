---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local exists = User.exists

if not exists('cmp') then
	return
end

local pfx = 'lazy_cfg.cmp.'
local sub_kinds = pfx..'kinds'

local api = vim.api
local set = vim.o
local opt = vim.opt

if exists(pfx..'luasnip') then
	require(pfx..'luasnip')
end

local sk = require(sub_kinds)
sk:setup()

local hi = api.nvim_set_hl
local get_mode = api.nvim_get_mode

set.completeopt = 'menu,menuone,noinsert,noselect,preview'
opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }

local has_words_before = function()
	unpack = unpack or table.unpack
	local buf_lines = api.nvim_buf_get_lines
	local win_cursor = api.nvim_win_get_cursor
	local line, col = unpack(win_cursor(0))
	return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
local Luasnip = require('luasnip')

local Config = cmp.config
local Context = require('cmp.config.context')

local Confirm = cmp.SelectBehavior
local Select = cmp.SelectBehavior

local map = cmp.mapping

local map_close = function(fallback)
	if cmp.visible() then
		cmp.close()
	end
	fallback()
end

local tab_map = {
	i = function(fallback)
		local jumpable = Luasnip.expand_or_locally_jumpable
		local opts = { behavior = cmp.SelectBehavior.Select }
		-- local num_entries = #cmp.get_entries()
		if cmp.visible() then
			cmp.select_next_item(opts)
		elseif jumpable() then
			Luasnip.expand_or_jump()
		elseif has_words_before() then
			cmp.complete()
			cmp.select_next_item(opts)
		else
			fallback()
		end
	end,
	s = function(fallback)
		local jumpable = Luasnip.expand_or_locally_jumpable
		local opts = { behavior = cmp.SelectBehavior.Select }
		if cmp.visible() and #cmp.get_entries() >= 1 then
			cmp.select_next_item(opts)
		elseif jumpable() then
			Luasnip.expand_or_jump()
		elseif has_words_before() then
			cmp.complete()
			cmp.select_next_item(opts)
		else
			fallback()
		end
	end,
	c = function(fallback)
		local opts = { behavior = cmp.SelectBehavior.Replace }
		if cmp.visible() and #cmp.get_entries() >= 1 then
			cmp.select_next_item(opts)
		elseif has_words_before() then
			cmp.complete()
			cmp.select_next_entry(opts)
		else
			fallback()
		end
	end,
}

local stab_map = cmp.config.disable

local cr_map = function(fallback)
	if cmp.visible() then
		cmp.close()
	end
	fallback()
end

local bs_map = {
	i = function(fallback)
		if not cmp.visible() or not has_words_before() then
			cmp.abort()
		elseif not cmp.get_selected_entry() and not cmp.get_active_entry() then
			cmp.close()
		end
		fallback()
		if has_words_before() then
			cmp.complete()
		end
	end,
	s = function(fallback)
		fallback()
		if not cmp.visible() or not has_words_before() then
			cmp.abort()
		elseif not cmp.get_selected_entry() and not cmp.get_active_entry() then
			cmp.close()
		end
		if has_words_before() then
			cmp.complete()
		end
	end,
	c = function(fallback)
		local was_open = cmp.visible()

		fallback()
		if not cmp.visible() and not has_words_before() then
			cmp.abort()
		elseif not cmp.get_selected_entry() and not cmp.get_active_entry() then
			cmp.close()
		end

		if was_open and has_words_before() then
			cmp.complete()
		end
	end,
}
local du_map = function(fallback)
	if cmp.visible() then
		cmp.abort()
	end
	fallback()
end

local r_map = function(fallback)
	local was_open = cmp.visible()
	fallback()
	if has_words_before() and was_open then
		cmp.complete()
	elseif cmp.visible() then
		cmp.close()
	end
end

local l_map = function(fallback)
	if cmp.visible() then
		cmp.close()
	end
	fallback()
end

cmp.setup({
	---@return boolean
	enabled = function()
		local grammar_check = (not Context.in_treesitter_capture('comment') and not Context.in_syntax_group)
		if get_mode().mode == 'c' then
			return true
		end
		return grammar_check
	end,

	view = {
		entries = {
			name = 'custom',
			selection_order = 'near_cursor',
		},
		docs = { auto_open = true },
	},

	completion = {
		autocomplete = {
			require('cmp.types').cmp.TriggerEvent.TextChanged,
		},
	},

	formatting = sk.formatting,

	matching = {
		disallow_fuzzy_matching = false,
		disallow_fullfuzzy_matching = true,
		disallow_prefix_unmatching = false,
		disallow_partial_matching = false,
		disallow_partial_fuzzy_matching = true,
	},
	snippet = {
		expand = function(args)
			Luasnip.lsp_expand(args.body)
		end,
	},
	window = sk.window,
	mapping = map.preset.insert({
		['<C-b>'] = map.scroll_docs(-4),
		['<C-f>'] = map.scroll_docs(4),
		['<C-j>'] = map.scroll_docs(-4),
		['<C-k>'] = map.scroll_docs(4),
		['<C-Space>'] = map.complete(),
		['<CR>'] = map(cr_map, { 'i', 's', 'c' }),
		['<Tab>'] = map(tab_map),
		['<S-Tab>'] = map(stab_map),
		['<BS>'] = map(bs_map),
		['<Down>'] = map(du_map, { 'i', 's', 'c' }),
		['<Up>'] = map(du_map, { 'i', 's', 'c' }),
		['<Left>'] = map(l_map, { 'i', 's', 'c' }),
		['<Right>'] = map(r_map, { 'i', 's', 'c' }),
	}),

	sources = Config.sources({
		-- { name = 'nvim_lsp' },
		{
			name = 'nvim_lsp',
		},
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
		{ name = 'path' },
	}),
})

cmp.setup.filetype({ 'bash', 'sh', 'zsh' }, {
	sources = Config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
})

if exists('orgmode') then
	cmp.setup.filetype({ 'org', 'orgagenda', 'orghelp' }, {
		sources = Config.sources({
			{ name = 'async_path' },
			{ name = 'buffer' },
		}, {
			{ name = 'orgmode' },
			{ name = 'buffer' },
		}),
	})
end

cmp.setup.filetype('lua', {
	sources = Config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
	}, {
		{ name = 'nvim_lua' },
		{ name = 'buffer' },
	})
})

cmp.setup.filetype('gitcommit', {
	sources = Config.sources({
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'conventionalcommits' },
	}, {
		{ name = 'git' },
		{ name = 'buffer' },
	}),
})
cmp.setup.cmdline({ '/', '?' }, {
	mapping = map.preset.cmdline(),
	completion = {
		autocomplete = {
			require('cmp.types').cmp.TriggerEvent.TextChanged,
		},
	},
	sources = Config.sources({
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline(':', {
	mapping = map.preset.cmdline(),
	sources = Config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

print('cmp loaded.')
