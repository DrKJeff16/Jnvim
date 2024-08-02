---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local types = User.types.lspconfig
local WK = User.maps.wk
local Highlight = User.highlight

local exists = Check.exists.module
local executable = Check.exists.executable
local empty = Check.value.empty
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_nil = Check.value.is_nil
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict
local hi = Highlight.hl

if not exists('lspconfig') then
    return
end

local api = vim.api
local bo = vim.bo
local Lsp = vim.lsp
local Diag = vim.diagnostic

local lsp_buf = Lsp.buf
local lsp_handlers = Lsp.handlers

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local on_windows = vim.uv.os_uname().version:match('Windows')

---@type fun(...): string
local function join_paths(...)
    local path_sep = on_windows and '\\' or '/'
    return table.concat({ ... }, path_sep)
end

require('plugin.lspconfig.mason')
require('plugin.lspconfig.neoconf')
require('plugin.lspconfig.trouble')
require('plugin.lspconfig.kinds').setup()

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
    ['textDocument/publishDiagnostics'] = Lsp.with(Lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        virtual_text = true,
    }),
    ['textDocument/references'] = Lsp.with(Lsp.handlers['textDocument/references'], {
        loclist = true,
    }),
}

---@type fun(T: LspServers): LspServers
local function populate(T)
    ---@type LspServers
    ---@diagnostic disable-next-line
    local res = {}

    for k, v in next, T do
        if not is_tbl(v) then
            goto continue
        end

        res[k] = vim.deepcopy(v)

        res[k].handlers = handlers

        if exists('cmp_nvim_lsp') then
            res[k].capabilities = require('cmp_nvim_lsp').default_capabilities()

            if k == 'jsonls' then
                res[k].capabilities.textDocument.completion.completionItem.snippetSupport = true
            end
        end

        if exists('schemastore') then
            local SchSt = require('schemastore')

            if k == 'jsonls' then
                res[k].settings = {}
                res[k].settings.json = {
                    schemas = SchSt.json.schemas(),
                    validate = { enable = true },
                }
            elseif k == 'yamlls' then
                res[k].settings = {}
                res[k].settings.yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = SchSt.yaml.schemas(),
                }
            end
        end

        ::continue::
    end

    return res
end

---@type LspServers
---@diagnostic disable-next-line:missing-fields
local srv = {}

srv.lua_ls = executable('lua-language-server') and {} or nil
srv.bashls = executable({ 'bash-language-server', 'shellcheck' }) and {} or nil
srv.clangd = executable('clangd') and {} or nil
srv.cmake = executable('cmake-languqge-server') and {} or nil
srv.html = executable('vscode-html-language-server') and {} or nil
srv.jdtls = executable('jdtls') and {} or nil
srv.jsonls = executable('vscode-json-language-server') and {} or nil
srv.julials = executable('julia') and {} or nil
srv.marksman = executable('marksman') and {} or nil
srv.pylsp = executable('pylsp') and {} or nil
srv.rust_analyzer = executable('rust-analyzer') and {} or nil
srv.taplo = executable('taplo') and {} or nil
srv.texlab = executable('texlab') and {} or nil
srv.yamlls = executable('yaml-language-server') and {} or nil

function srv.new()
    local self = setmetatable({}, { __index = srv })

    self.lua_ls = srv.lua_ls
    self.bashls = srv.bashls
    self.clangd = srv.clangd
    self.cmake = srv.cmake
    self.html = srv.html
    self.jdtls = srv.jdtls
    self.jsonls = srv.jsonls
    self.julials = srv.julials
    self.marksman = srv.marksman
    self.pylsp = srv.pylsp
    self.rust_analyzer = srv.rust_analyzer
    self.taplo = srv.taplo
    self.texlab = srv.texlab
    self.yamlls = srv.yamlls

    return self
end

SERVERS = populate(srv.new())

local lspconfig = require('lspconfig')

for k, v in next, SERVERS do
    lspconfig[k].setup(v)
end

---@type KeyMapDict
local Keys = {
    ['<leader>lI'] = {
        function() vim.cmd('LspInfo') end,
        desc('Get LSP Config Info'),
    },
    ['<leader>lR'] = {
        function() vim.cmd('LspRestart') end,
        desc('Restart Server'),
    },
    ['<leader>lH'] = {
        function() vim.cmd('LspStop') end,
        desc('Stop Server'),
    },
    ['<leader>lS'] = {
        function() vim.cmd('LspStart') end,
        desc('Start Server'),
    },
}
---@type RegKeysNamed
local Names = {
    ['<leader>l'] = { group = '+LSP' },
}

if WK.available() then
    if WK.available() then
        map_dict(Names, 'wk.register', false, 'n')
    end

    map_dict(Keys, 'wk.register', false, 'n')
end

local group = augroup('UserLspConfig', { clear = true })

au('LspAttach', {
    group = group,

    callback = function(args)
        local buf = args.buf
        local client = Lsp.get_client_by_id(args.data.client_id)

        if client.supports_method('textDocument/completion') then
            bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            Lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
        end

        --[[ if client.supports_method('textDocument/formatting') then
            au('BufWritePre', {
                buffer = args.buf,
                callback = function()
                    Lsp.buf.format({ bufnr = args.buf, id = client.id })
                end,
            })
        end ]]

        if client.supports_method('textDocument/definition') then
            bo[buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
        end

        if client.supports_method('textDocument/references') then
            local on_references = Lsp.handlers['textDocument/references']
            Lsp.handlers['textDocument/references'] = Lsp.with(on_references, {
                loclist = true,
            })
        end
        if client.supports_method('textDocument/publishDiagnostics') then
            Lsp.handlers['textDocument/publishDiagnostics'] =
                Lsp.with(Lsp.diagnostic.on_publish_diagnostics, {
                    signs = true,
                    virtual_text = true,
                })
        end

        ---@type table<MapModes, KeyMapDict>
        local K = {
            n = {
                ['<leader>lfD'] = { lsp_buf.declaration, desc('Declaration', true, buf) },
                ['<leader>lfd'] = { lsp_buf.definition, desc('Definition', true, buf) },
                -- ['<leader>lk'] = { lsp_buf.hover, desc('Hover', true, buf) },
                ['K'] = { lsp_buf.hover, desc('Hover', true, buf) },
                ['<leader>lfi'] = { lsp_buf.implementation, desc('Implementation', true, buf) },
                ['<leader>lfS'] = { lsp_buf.signature_help, desc('Signature Help', true, buf) },
                ['<leader>lwa'] = {
                    lsp_buf.add_workspace_folder,
                    desc('Add Workspace Folder', true, buf),
                },
                ['<leader>lwr'] = {
                    lsp_buf.remove_workspace_folder,
                    desc('Remove Workspace Folder', true, buf),
                },
                ['<leader>lwl'] = {
                    function()
                        local out = lsp_buf.list_workspace_folders()
                        local msg = ''

                        local notify = require('user_api.util.notify').notify
                        for _, v in next, out do
                            msg = msg .. '\n - ' .. v
                        end

                        notify(msg, 'info', { title = 'Workspace Folders' })
                    end,
                    desc('List Workspace Folders', true, buf),
                },
                ['<leader>lfT'] = { lsp_buf.type_definition, desc('Type Definition', true, buf) },
                ['<leader>lfR'] = { lsp_buf.rename, desc('Rename...', true, buf) },
                ['<leader>lfr'] = { lsp_buf.references, desc('References', true, buf) },
                ['<leader>lff'] = {
                    function() lsp_buf.format({ async = true }) end,
                    desc('Format File', true, buf),
                },
                ['<leader>lca'] = { lsp_buf.code_action, desc('Code Actions', true, buf) },
                ['<leader>le'] = { Diag.open_float, desc('Diagnostics Float', true, buf) },
                ['<leader>lq'] = { Diag.setloclist, desc('Add Loclist', true, buf) },
            },
            v = { ['<leader>lca'] = { lsp_buf.code_action, desc('Code Actions', true, buf) } },
        }
        ---@type table<MapModes, RegKeysNamed>
        local Names2 = {
            n = {
                ['<leader>lc'] = { group = '+Code Actions' },
                ['<leader>lf'] = { group = '+File Analysis' },
                ['<leader>lw'] = { group = '+Workspace' },
            },
            v = { ['<leader>lc'] = { group = '+Code Actions' } },
        }

        if WK.available() then
            map_dict(Names2, 'wk.register', true, nil, buf)
        end
        map_dict(K, 'wk.register', true, nil, buf)

        if client.name == 'lua_ls' then
            require('plugin.lazydev')
        end
    end,
})
au('LspDetach', {
    group = group,

    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- Do something with the client
        vim.cmd('setlocal tagfunc< omnifunc<')
    end,
})
au('LspProgress', {
    group = group,
    pattern = '*',
    callback = function() vim.cmd('redrawstatus') end,
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
                hi('NormalFloat', { bg = '#2c1a3a' })
                hi('FloatBorder', { fg = '#f0efbf', bg = '#2c1a3a' })
            end,
        },
    },
}

for event, opts_arr in next, aus do
    for _, opts in next, opts_arr do
        au(event, opts)
    end
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
