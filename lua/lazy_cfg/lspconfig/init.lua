---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local maps = User.maps
local au_t = User.types.user.autocmd
local hl_t = User.types.user.highlight

if not exists('lspconfig') or not exists('neodev') then
	return
end

-- NOTE: This MUST go after plugin check.
local types = User.types.lspconfig

local api = vim.api
local bo = vim.bo
local lsp = vim.lsp
local lsp_buf = lsp.buf
local diag = vim.diagnostic
local insp = vim.inspect

local kmap = maps.kmap
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local rt_file = api.nvim_get_runtime_file
local hi = api.nvim_set_hl

local nmap = kmap.n

---@type LspSubs
local Sub = {}

function Sub.neoconf()
	if exists('lazy_cfg.lspconfig.neoconf') then
		return require('lazy_cfg.lspconfig.neoconf')
	end
end
function Sub.clangd()
	if exists('lazy_cfg.lspconfig.clangd') then
		return require('lazy_cfg.lspconfig.clangd')
	end
end
function Sub.trouble()
	if exists('lazy_cfg.lspconfig.trouble') then
		return require('lazy_cfg.lspconfig.trouble')
	end
end

Sub.kinds = require('lazy_cfg.lspconfig.kinds')

-- Now call each.
Sub.neoconf()
Sub.clangd()
Sub.trouble()
Sub.kinds.setup()

local border = {
	{"🭽", "FloatBorder"},
	{"▔", "FloatBorder"},
	{"🭾", "FloatBorder"},
	{"▕", "FloatBorder"},
	{"🭿", "FloatBorder"},
	{"▁", "FloatBorder"},
	{"🭼", "FloatBorder"},
	{"▏", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
	["textDocument/hover"] =  lsp.with(lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] =  lsp.with(lsp.handlers.signature_help, { border = border  }),
}

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

---@param srv_tbl LspServers
---@return LspServers res
local add_caps = function(srv_tbl)
	---@type LspServers
	local res = {}

	for k, v in next, srv_tbl do
		res[k] = v

		if handlers then
			res[k].handlers = handlers
		end

		if exists('cmp_nvim_lsp') then
			local caps = require('cmp_nvim_lsp').default_capabilities()
			res[k].capabilities = caps
		end

		if exists('schemastore') then
			local SchSt = require('schemastore')

			if k == 'jsonls' then
				res[k].settings = {
					json = {
						schemas = SchSt.json.schemas({
							select = {
								'.eslintrc',
								'package.json',
							},
						}),
						validate = { enable = true },
					},
				}
			elseif k == 'yamlls' then
				res[k].settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = '',
						},
						schemas = SchSt.yaml.schemas({}),
					},
				}
			end
		end
	end

	return res
end

local lspconfig = require('lspconfig')

---@type LspServers
local srv = {}
srv.lua_ls = {
	settings = {
		Lua = {
			completion = { callSnippet = 'Replace' },
		},
	},
}

srv.bashls = {}
srv.clangd = {}
srv.cmake = {}
srv.html = {}
srv.jsonls = {}
srv.yamlls = {}
srv.pylsp = {
	settings = {
		configurationSources = { 'flake8' },
		plugins = {
			autopep8 = {
				enabled = true,
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
			mccabe = { enabled = true, threshold = 15 },
			preload = {
				enabled = false,
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
				addIgnore = { 'D400', 'D401' },
				ignore = { 'D400', 'D401' },
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
			rope_completion = { enabled = true, eager = true },
			yapf = { enabled = false },
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
}

srv = add_caps(srv)

for k, v in next, srv do
	lspconfig[k].setup(v)
end

nmap('<Leader>le', diag.open_float)
nmap('<Leader>l[', diag.goto_prev)
nmap('<Leader>l]', diag.goto_next)
nmap('<Leader>lq', diag.setloclist)

lsp.set_log_level('INFO')

au('LspAttach', {
	group = augroup('UserLspConfig', {}),
	---@class EvBuf
	---@field buf integer

	---@param ev EvBuf
	callback = function(ev)
		bo[ev.buf].omnifunc = 'v:lua.lsp.omnifunc'
		local opts = { buffer = ev.buf }
		nmap('<Leader>lgD', lsp_buf.declaration, opts)
		nmap('<Leader>lgd', lsp_buf.definition, opts)
		nmap('<Leader>lk', lsp_buf.hover, opts)
		nmap('K', lsp_buf.hover, opts)
		nmap('<Leader>lgi', lsp_buf.implementation, opts)
		nmap('<Leader>lS', lsp_buf.signature_help, opts)
		nmap('<Leader>lwa', lsp_buf.add_workspace_folder, opts)
		nmap('<Leader>lwr', lsp_buf.remove_workspace_folder, opts)
		nmap('<Leader>lwl', function()
			print(insp(lsp_buf.list_workspace_folders()))
		end, opts)
		nmap('<Leader>lD', lsp_buf.type_definition, opts)
		nmap('<Leader>lrn', lsp_buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<Leader>lca', lsp_buf.code_action, opts)
		nmap('<Leader>lgr', lsp_buf.references, opts)
		nmap('<Leader>lf', function()
			lsp_buf.format({ async = true })
		end, opts)
	end,
})

diag.config({
	virtual_text = true,
	float = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

---@type AuRepeat
local aus = {
	['ColorScheme'] = {
		{
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { bg = '#2c1a3a' }
				hi(0, 'NormalFloat', opts)
			end,
		},
		{
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { fg = '#f0efbf', bg = '#2c1a3a' }
				hi(0, 'FloatBorder', opts)
			end,
		},
	},
}

-- TODO: Do this using the API.
for event, opts_arr in next, aus do
	for _, opts in next, opts_arr do
		au(event, opts)
	end
end

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in next, signs do
	local hlite = "DiagnosticSign" .. type
	vim.fn.sign_define(hlite, { text = icon, texthl = hlite, numhl = hlite })
end

-- vim.o.updatetime = 250
