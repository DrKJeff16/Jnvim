---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local kmap = User.maps.kmap
local types = User.types.lspconfig
local au_t = User.types.user.autocmd
local hl_t = User.types.user.highlight

local exists = Check.exists.module
local modules = Check.exists.modules
local executable = Check.exists.executable
local nmap = kmap.n

if not exists('lspconfig') then
	return
end

local api = vim.api
local bo = vim.bo
local lsp = vim.lsp
local lsp_buf = lsp.buf
local diag = vim.diagnostic
local insp = vim.inspect
local fn = vim.fn

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local rt_file = api.nvim_get_runtime_file
local hi = api.nvim_set_hl
local sign_define = fn.sign_define

---@type LspSubs
local Sub = {
	kinds = exists('lazy_cfg.lspconfig.kinds', true),
}

function Sub.neoconf()
	if exists('lazy_cfg.lspconfig.neoconf') then
		return require('lazy_cfg.lspconfig.neoconf')
	end
end
function Sub.neodev()
	if exists('lazy_cfg.lspconfig.neodev') then
		return require('lazy_cfg.lspconfig.neodev')
	end
end

function Sub.trouble()
	if exists('lazy_cfg.lspconfig.trouble') then
		return require('lazy_cfg.lspconfig.trouble')
	end
end

-- Now call each.
Sub.neoconf()
Sub.neodev()
-- Sub.trouble()
Sub.kinds.setup()

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = border }),
}

---@param srv_tbl LspServers
---@return LspServers res
local add_caps = function(srv_tbl)
	---@type LspServers
	local res = {}

	for k, v in next, srv_tbl do
		if not Check.value.is_nil(v) then
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

srv.bashls = (executable({ 'bash-language-server', 'shellcheck' }) and {} or nil)
srv.clangd = (executable('clangd') and {} or nil)
srv.cmake = (executable('cmake-languqge-server') and {} or nil)
srv.html = (executable('vscode-html-language-server') and {} or nil)
srv.jsonls = (executable('vscode-json-language-server') and {} or nil)
srv.yamlls = (executable('yaml-language-server') and {} or nil)
srv.pylsp = (executable('pylsp') and {} or nil)

srv = add_caps(srv)

for k, v in next, srv do
	lspconfig[k].setup(v)
end

nmap('<Leader>le', diag.open_float, { desc = 'Diagnostics Float' })
nmap('<Leader>l[', diag.goto_prev, { desc = 'Previous Diagnostic' })
nmap('<Leader>l]', diag.goto_next, { desc = 'Previous Diagnostic' })
nmap('<Leader>lq', diag.setloclist, { desc = 'Add Loclist (Diagnostics)' })

lsp.set_log_level('INFO')

au('LspAttach', {
	group = augroup('UserLspConfig', {}),
	---@class EvBuf
	---@field buf integer

	---@param ev EvBuf
	callback = function(ev)
		bo[ev.buf].omnifunc = 'v:lua.lsp.omnifunc'
		local opts = { buffer = ev.buf }
		opts.desc = 'Declaration'
		nmap('<Leader>lgD', lsp_buf.declaration, opts)
		opts.desc = 'Definition'
		nmap('<Leader>lgd', lsp_buf.definition, opts)
		opts.desc = 'Hover'
		nmap('<Leader>lk', lsp_buf.hover, opts)
		nmap('K', lsp_buf.hover, opts)
		opts.desc = 'Implementation'
		nmap('<Leader>lgi', lsp_buf.implementation, opts)
		opts.desc = 'Signature Help'
		nmap('<Leader>lS', lsp_buf.signature_help, opts)
		opts.desc = 'Add Workspace Folder'
		nmap('<Leader>lwa', lsp_buf.add_workspace_folder, opts)
		opts.desc = 'Remove Workspace Folder'
		nmap('<Leader>lwr', lsp_buf.remove_workspace_folder, opts)
		opts.desc = 'List Workspace Folders'
		nmap('<Leader>lwl', function()
			local out = insp(lsp_buf.list_workspace_folders())
			-- Try doing it with `notify` plugin.
			if exists('notify') then
				vim.notify(out)
			else
				print(out)
			end
		end, opts)
		opts.desc = 'Type Definition'
		nmap('<Leader>lD', lsp_buf.type_definition, opts)
		opts.desc = 'Rename...'
		nmap('<Leader>lrn', lsp_buf.rename, opts)
		opts.desc = 'Code Actions'
		vim.keymap.set({ 'n', 'v' }, '<Leader>lca', lsp_buf.code_action, opts)
		opts.desc = 'References'
		nmap('<Leader>lgr', lsp_buf.references, opts)
		opts.desc = 'Format File'
		nmap('<Leader>lf', function()
			lsp_buf.format({ async = true })
		end, opts)
	end,
})

diag.config({
	virtual_text = true,
	float = true,
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

vim.o.updatetime = 250
