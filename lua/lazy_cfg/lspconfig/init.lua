---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.user.highlight')

local User = require('user')
local exists = User.exists
local maps = User.maps()

if not exists('lspconfig') or not exists('neodev') then
	return
end

require('user.types.lspconfig')

local pfx = 'lazy_cfg.lspconfig.'

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

---@class LspSubMods
---@field clangd? fun(): any
---@field kinds? fun(): LspKindsMod

---@return LspSubMods subs
local function src()
	local prefix = 'lazy_cfg.lspconfig.'

	---@type LspSubMods
	local subs = {}

	-- Iterate for each submodule and
	-- create a caller function in its
	-- respective table field.
	for _, v in next, { 'clangd', 'kinds' } do
		local path = prefix..v

		-- If submodule exists.
		if exists(path) then
			---@return any
			subs[v] = function()
				return require(path)
			end
		end
	end

	return subs
end

local submods = src()
if submods.clangd then
	submods.clangd()
end
if submods.kinds then
	submods.kinds().setup()
end
---@class LspAu
---@field event string|string[]
---@field opts AuOpts

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

--- TODO: Redo the annotation below.

---@alias SrvTbl { [string]: table }

---@param srv_tbl SrvTbl
---@return SrvTbl res
local add_caps = function(srv_tbl)
	---@type SrvTbl
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
			end
			if k == 'yamlls' then
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

---@type SrvTbl
local srv = {
	['lua_ls'] = {
		settings = {
			Lua = {
				runtime = { version = 'LuaJIT' },
				workspace = { checkThirdParty = false },
				completion = {
					enable = true,
					autoRequire = false,
					callSnippet = 'Replace',
					displayContext = 5,
					showParams = false,
				},
				diagnostics = {
					enable = true,
					globals = { 'vim' },
					workspaceRate = 70,
				},
				hint = {
					arrayIndex = 'Enable',
					enable = true,
					paramName = 'All',
					paramType = true,
					setType = true,
				},
				hover = { enable = true },
				semantic = {
					enable = true,
					annotation = true,
					keyword = true,
					variable = true,
				},
				signatureHelp = { enable = true },
			},
		},
	},

	['bashls'] = {},
	['clangd'] = {},
	['cmake'] = {},
	['css_variables'] = {},
	['html'] = {},
	['jsonls'] = {},
	['yamlls'] = {},
	['pylsp'] = {
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
	},
}

srv = add_caps(srv)

for k, v in next, srv do
	lspconfig[k].setup(v)
end

local map_opts = { noremap = true, silent = true }

nmap('<Leader>le', diag.open_float, map_opts)
nmap('<Leader>l[', diag.goto_prev, map_opts)
nmap('<Leader>l]', diag.goto_next, map_opts)
nmap('<Leader>lq', diag.setloclist, map_opts)

lsp.set_log_level('TRACE')

au('LspAttach', {
	group = augroup('UserLspConfig', {}),
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
	virtual_text = { source = 'if_many' },
	float = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

---@type LspAu[]
local aus = {
	{
		event = 'ColorScheme',
		opts = {
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { bg = '#2c1a3a' }
				hi(0, 'NormalFloat', opts)
			end,
		},
	},
	{
		event = 'ColorScheme',
		opts = {
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { fg = '#f0efbf', bg = '#2c1a3a' }
				hi(0, 'FloatBorder', opts)
			end,
		},
	},
}

for _, t in next, aus do
	au(t.event, t.opts)
end

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hlite = "DiagnosticSign" .. type
	vim.fn.sign_define(hlite, { text = icon, texthl = hlite, numhl = hlite })
end

vim.o.updatetime = 250
-- api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 	group = api.nvim_create_augroup("float_diagnostic", { clear = true }),
-- 	callback = function()
-- 		diag.open_float(nil, {focus=false, scope = 'cursor'})
-- 	end
-- })

-- -- To instead override globally
-- local orig_util_open_floating_preview = lsp.util.open_floating_preview
-- function lsp.util.open_floating_preview(contents, syntax, opts, ...)
-- 	opts = opts or {}
-- 	opts.border = opts.border or border
-- 	return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end
