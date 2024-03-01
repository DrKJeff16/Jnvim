local exists = require('user').exists

if not exists('lspconfig') then
	return
end

local api = vim.api
local bo = vim.bo
local lsp = vim.lsp
local lsp_buf = lsp.buf
local diag = vim.diagnostic
local insp = vim.inspect

-- local fs_stat = vim.loop.fs_stat

local keymap = vim.keymap.set
local map = vim.keymap.set
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local rt_file = api.nvim_get_runtime_file

local Neodev = require('neodev')
Neodev.setup({
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,
	},

	setup_jsonls = true,

	lspconfig = true,
	pathStrict = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities

---@module 'spconfig''
local lspconfig

lspconfig = require('lspconfig')

local srv = {
	{
		'lua_ls',
		{
			capabilities = capabilities(),

			settings = {
				Lua = {
				    runtime = {
				    	version = 'LuaJIT',
				    	fileEncoding = 'utf8',
				    },
				    workspace = {
						checkThirdParty = false,
						library = rt_file('', true),
				    },
					completion = {
						enable = true,
						autoRequire = false,
						callSnippet = 'Replace',
						displayContext = 5,
						showParams = false,
					},
					diagnostics = {
						enable = true,
						globals = {
							'vim',
						},
						workspaceRate = 70,
					},
					hint = {
						arrayIndex = 'Enable',
						enable = true,
						paramName = 'All',
						paramType = true,
						setType = true,
					},
					hover = {
						enable = true,
					},
					semantic = {
						enable = true,
						annotation = true,
						keyword = true,
						variable = true,
					},
					signatureHelp = {
						enable = true,
					},
				},
			},
		},
	},

	{
		'bashls',
		{
			capabilities = capabilities(),
		},
	},

	{
		'clangd',
		{
			capabilities = capabilities(),
		},
	},
	{
		'pylsp',
		{
			capabilities = capabilities(),
			settings = {
				configurationSources = { 'flake8' },

				plugins = {
					autopep8 = {
						enabled = false,
					},
					flake8 = {
						enabled = true,
						hangClosing = true,
						maxLineLength = 100,
						indentSize = 4,
						ignore = {
							'F400',
							'F401',
						},
					},
					jedi = {
						auto_import_modules = {
							'argparse',
							'os',
							're',
							'sys',
							'typing',
						},

					},
					jedi_completion = {
						enabled = true,
						include_params = false,
						include_class_objects = true,
						include_function_objects = true,
						fuzzy = false,
						eager = true,
						resolve_at_most = 30,
						cache_for = {
							'argparse',
							'math',
							'matplotlib',
							'numpy',
							'os',
							'pandas',
							're',
							'setuptools',
							'string',
							'sys',
							'typing',
							'wheel',
						},
					},
					jedi_definition = {
						enabled = true,
						follow_imports = true,
						follow_builtin_imports = true,
						follow_builtin_definitions = true,
					},
					jedi_hover = { enabled = true },
					jedi_references = { enabled = true },
					jedi_signature_help = { enabled = true },
					jedi_symbols = {
						enabled = true,
						all_scopes = false,
						include_import_symbols = true,
					},
					mccabe = {
						enabled = true,
						threshold = 15,
					},
					preload = {
						enabled = true,
						modules = {
							'argparse',
							'math',
							'numpy',
							'os',
							're',
							'string',
							'sys',
							'typing',
						},
					},
					pycodestyle = { enabled = false },
					pydocstyle = {
						enabled = true,
						convention = 'numpy',
						addIgnore = {
							'F400',
							'F401',
						},
						ignore = {
							'F400',
							'F401',
						},
						match = "(?!test_).*\\.py",
						matchDir = "[^\\.].*",
					},
					pyflakes = { enabled = false },
					pylint = { enabled = false },
					rope_autoimport = {
						enabled = true,
						completions = { enabled = true },
						code_actions = { enabled = true },
						memory = true,
					},
					rope_completion = {
						enabled = true,
						eager = true,
					},
					yapf = {
						enabled = true,
					},
				},

				rope = {
					extensionModules = {
						'argparse',
						'math',
						'numpy',
						'os',
						're',
						'string',
						'sys',
						'typing',
					},
					ropeFolder = nil,
				},
			},
		},
	},
}

for _, v in ipairs(srv) do
	lspconfig[v[1]].setup(v[2])
end

local map_opts = { noremap = true, silent = true }

map('n', '<Leader>le', diag.open_float, map_opts)
map('n', '<Leader>l[', diag.goto_prev, map_opts)
map('n', '<Leader>l]', diag.goto_next, map_opts)
map('n', '<Leader>lq', diag.setloclist, map_opts)

au('LspAttach', {
	group = augroup('UserLspConfig', {}),
	callback = function(ev)
	    bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
	    local opts = { buffer = ev.buf }
	    map('n', '<Leader>lgD', lsp_buf.declaration, opts)
	    map('n', '<Leader>lgd', lsp_buf.definition, opts)
	    map('n', '<Leader>lk', lsp_buf.hover, opts)
	    map('n', '<Leader>lgi', lsp_buf.implementation, opts)
	    map('n', '<Leader>lS', lsp_buf.signature_help, opts)
	    map('n', '<Leader>lwa', lsp_buf.add_workspace_folder, opts)
	    map('n', '<Leader>lwr', lsp_buf.remove_workspace_folder, opts)
	    keymap('n', '<Leader>lwl', function()
	    	print(insp(lsp_buf.list_workspace_folders()))
	    	end, opts)
	    map('n', '<Leader>lD', lsp_buf.type_definition, opts)
	    map('n', '<Leader>lrn', lsp_buf.rename, opts)
	    keymap({ 'n', 'v' }, '<Leader>lca', lsp_buf.code_action, opts)
	    map('n', '<Leader>lgr', lsp_buf.references, opts)
	    keymap('n', '<Leader>lf', function()
	    	lsp_buf.format({ async = true })
	    	end, opts)
	end,
})
