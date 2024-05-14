local User = require('user')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_fun = Check.value.is_fun

if not exists('cmp') or not exists('luasnip') then
	return
end

local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local tbl_contains = vim.tbl_contains
local get_mode = vim.api.nvim_get_mode

local Sks = require('lazy_cfg.cmp.kinds')
local Util = require('lazy_cfg.cmp.util')
local Sources = require('lazy_cfg.cmp.sources')

local Luasnip = exists('lazy_cfg.cmp.luasnip') and require('lazy_cfg.cmp.luasnip') or require('luasnip')
local cmp = require('cmp')

local tab_map = Util.tab_map
local s_tab_map = Util.s_tab_map
local cr_map = Util.cr_map

local bs_map = Util.bs_map

---@type table<string, cmp.MappingClass|fun(fallback: function):nil>
local Mappings = {
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
}

---@type cmp.ConfigSchema
local opts = {
	---@type fun(): boolean
	enabled = function()
		local disable_ft = {
			'NvimTree',
			'TelescopePrompt',
			'checkhealth',
			'help',
			'lazy',
		}

		local enable_comments = {
			'bash',
			'c',
			'codeowners',
			'cpp',
			'crontab',
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
			'vim',
			'zsh',
		}

		---@type string
		local ft = vim.api.nvim_get_option_value('ft', { scope = 'local' })

		if tbl_contains(disable_ft, ft) then
			return false
		end
		if tbl_contains(enable_comments, ft) then
			return true
		end
		if get_mode().mode == 'c' then
			return true
		end

		local Context = require('cmp.config.context')

		local in_ts_capture = Context.in_treesitter_capture
		local in_syntax_group = Context.in_syntax_group

		return not in_ts_capture('comment') and not in_syntax_group('Comment')
	end,

	snippet = {
		---@type fun(args: cmp.SnippetExpansionParams)
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

	mapping = cmp.mapping.preset.insert(Mappings),

	sources = cmp.config.sources({
		{ name = 'nvim_lsp',                priority = 1 },
		{ name = 'nvim_lsp_signature_help', priority = 2 },
		{ name = 'luasnip',                 priority = 3 },
		{ name = 'buffer',                  priority = 4 },
	}),
}

cmp.setup(opts)

Sources.setup()

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
