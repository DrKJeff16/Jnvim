---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lspconfig
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local empty = Check.value.empty
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_nil = Check.value.is_nil
local desc = kmap.desc
local nmap = kmap.n
local hi = User.highlight.hl

if not exists('lspconfig') then
	return
end

local api = vim.api
local bo = vim.bo
local Lsp = vim.lsp
local Diag = vim.diagnostic

local lsp_buf = Lsp.buf
local lsp_handlers = Lsp.handlers

local insp = vim.inspect
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local rt_file = api.nvim_get_runtime_file
-- local sign_define = vim.fn.sign_define

---@type fun(path: string): nil|fun()
local sub_fun = function(path)
	if not is_str(path) or path == '' then
		error('(lazy_cfg.lspconfig:sub_fun): Cannot generate function from type `' .. type(path) .. '`')
	end

	return function()
		if exists(path) then
			require(path)
		end
	end
end

---@type LspSubs
local Sub = {
	kinds = exists('lazy_cfg.lspconfig.kinds', true),
	neoconf = sub_fun('lazy_cfg.lspconfig.neoconf'),
	neodev = sub_fun('lazy_cfg.lspconfig.neodev'),
	clangd = sub_fun('lazy_cfg.lspconfig.clangd'),
	trouble = sub_fun('lazy_cfg.lspconfig.trouble'),
}

-- Now call each.
Sub.neoconf()
Sub.neodev()
Sub.clangd()
Sub.trouble()
Sub.kinds.setup()

local border = {
	{ '🭽', 'FloatBorder' },
	{ '▔', 'FloatBorder' },
	{ '🭾', 'FloatBorder' },
	{ '▕', 'FloatBorder' },
	{ '🭿', 'FloatBorder' },
	{ '▁', 'FloatBorder' },
	{ '🭼', 'FloatBorder' },
	{ '▏', 'FloatBorder' },
}

-- LSP settings (for overriding per client)
local handlers = {
	['textDocument/hover'] = Lsp.with(lsp_handlers.hover, { border = border }),
	['textDocument/signatureHelp'] = Lsp.with(lsp_handlers.signature_help, { border = border }),
}

---@type fun(T: LspServers): LspServers
local populate = function(T)
	---@type LspServers
	local res = {}

	for k, v in next, T do
		if not is_tbl(v) then
			goto continue
		end

		res[k] = vim.deepcopy(v)

		res[k].handlers = handlers

		if exists('cmp_nvim_lsp') then
			res[k].capabilities = require('cmp_nvim_lsp').default_capabilities()
		end

		if exists('schemastore') then
			local SchSt = require('schemastore')

			if k == 'jsonls' then
				res[k].settings = {}
				res[k].settings.json = {
					schemas = SchSt.json.schemas({
						select = {
							'.eslintrc',
							'package.json',
						},
					}),
					validate = { enable = true },
				}
			elseif k == 'yamlls' then
				res[k].settings = {}
				res[k].settings.yaml = {
					schemaStore = { enable = false, url = '' },
					schemas = SchSt.yaml.schemas({}),
				}
			end
		end

		::continue::
	end

	return res
end

---@type LspServers
local srv = {}

srv.lua_ls = executable('lua-language-server') and {} or nil
srv.bashls = executable({ 'bash-language-server', 'shellcheck' }) and {} or nil
srv.clangd = executable('clangd') and {} or nil
srv.cmake = executable('cmake-languqge-server') and {} or nil
srv.html = executable('vscode-html-language-server') and {} or nil
srv.jdtls = executable('jdtls') and {} or nil
srv.jsonls = executable('vscode-json-language-server') and {} or nil
srv.marksman = executable('marksman') and {} or nil
srv.pylsp = executable('pylsp') and {} or nil
srv.texlab = executable('texlab') and {} or nil
srv.yamlls = executable('yaml-language-server') and {} or nil

function srv.new()
	local self = setmetatable({}, { __index = srv })

	self.lua_ls = srv.lua_ls or nil
	self.bashls = srv.bashls or nil
	self.clangd = srv.clangd or nil
	self.cmake = srv.cmake or nil
	self.html = srv.html or nil
	self.jdtls = srv.jdtls or nil
	self.jsonls = srv.jsonls or nil
	self.marksman = srv.marksman or nil
	self.pylsp = srv.pylsp or nil
	self.texlab = srv.texlab or nil
	self.yamlls = srv.yamlls or nil

	return self
end

srv = populate(srv.new())

local lspconfig = require('lspconfig')

for k, v in next, srv do
	lspconfig[k].setup(v)
end

---@type KeyMapDict
local Keys = {
	['<leader>le'] = { Diag.open_float, desc('Diagnostics Float') },
	['<leader>lq'] = { Diag.setloclist, desc('Add Loclist') },
	['<leader>lI'] = {
		function()
			vim.cmd('LspInfo')
		end,
		desc('Get LSP Config Info'),
	},
	['<leader>lR'] = {
		function()
			vim.cmd('LspRestart')
		end,
		desc('Restart Server'),
	},
	['<leader>lH'] = {
		function()
			vim.cmd('LspStop')
		end,
		desc('Stop Server'),
	},
	['<leader>lS'] = {
		function()
			vim.cmd('LspStart')
		end,
		desc('Start Server'),
	},
}

local Keys_WK = WK.convert_dict(Keys)
WK.register(Keys_WK)

--[[ for lhs, v in next, Keys do
	v[2] = is_tbl(v[2]) and v[2] or {}
	nmap(lhs, v[1], v[2])
end ]]

au('LspAttach', {
	group = augroup('UserLspConfig', { clear = true }),

	---@type fun(ev: EvBuf)
	callback = function(ev)
		local buf = ev.buf

		bo[buf].omnifunc = 'v:lua.lsp.omnifunc'

		local K = {
			['<leader>lgD'] = { lsp_buf.declaration, desc('Declaration', true, buf) },
			['<leader>lgd'] = { lsp_buf.definition, desc('Definition', true, buf) },
			['<leader>lk'] = { lsp_buf.hover, desc('Hover', true, buf) },
			['K'] = { lsp_buf.hover, desc('Hover', true, buf) },
			['<leader>lgi'] = { lsp_buf.implementation, desc('Implementation', true, buf) },
			['<leader>lS'] = { lsp_buf.signature_help, desc('Signature Help', true, buf) },
			['<leader>lwa'] = { lsp_buf.add_workspace_folder, desc('Add Workspace Folder', true, buf) },
			['<leader>lwr'] = { lsp_buf.remove_workspace_folder, desc('Remove Workspace Folder', true, buf) },
			['<leader>lwl'] = {
				function()
					local out = lsp_buf.list_workspace_folders()
					local msg = ''
					for _, v in next, out do
						msg = msg .. '\n - ' .. v
					end

					-- Try doing it with `notify` plugin.
					if exists('notify') then
						local Notify = require('notify')

						Notify(msg, 'info', { title = 'Workspace Folders' })
					else
						vim.notify(msg, vim.log.levels.INFO)
					end
				end,
				desc('List Workspace Folders', true, buf),
			},
			['<leader>lD'] = { lsp_buf.type_definition, desc('Type Definition', true, buf) },
			['<leader>lrn'] = { lsp_buf.rename, desc('Rename...', true, buf) },
			['<leader>lgr'] = { lsp_buf.references, desc('References', true, buf) },
			['<leader>lf'] = {
				function()
					lsp_buf.format({ async = true })
				end,
				desc('Format File', true, buf),
			},
		}

		local K2 = WK.convert_dict(K)
		WK.register(K2)

		vim.keymap.set({ 'n', 'v' }, '<leader>lca', lsp_buf.code_action, desc('Code Actions', true, buf))
	end,
})

Diag.config({
	virtual_text = true,
	float = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

---@type AuRepeat
local aus = {
	['ColorScheme'] = {
		{
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { bg = '#2c1a3a' }
				hi('NormalFloat', opts)
			end,
		},
		{
			pattern = '*',
			callback = function()
				---@type HlOpts
				local opts = { fg = '#f0efbf', bg = '#2c1a3a' }
				hi('FloatBorder', opts)
			end,
		},
	},
}

for event, opts_arr in next, aus do
	for _, opts in next, opts_arr do
		au(event, opts)
	end
end

-- FIX: This section causes complaints from nvim due to version bump v0.11.0.
--
--[[ local signs = {
	Error = '󰅚 ',
	Warn = '󰀪 ',
	Hint = '󰌶 ',
	Info = ' ',
}

for type, icon in next, signs do
	local hlite = 'DiagnosticSign' .. type

	sign_define(hlite, { text = icon, texthl = hlite, numhl = hlite })
end ]]
