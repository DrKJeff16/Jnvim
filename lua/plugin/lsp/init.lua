---@diagnostic disable:missing-fields
---@diagnostic disable:need-check-nil

---@module 'user_api.types.lspconfig'

local User = require('user_api')
local Check = User.check
local Maps = User.maps

local exists = Check.exists.module
local executable = Check.exists.executable
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local desc = Maps.kmap.desc
local hi = User.highlight.hl

if not exists('lspconfig') then
    return
end

User:register_plugin('plugin.lsp')

require('plugin.lsp.mason')
require('plugin.lsp.neoconf')
require('plugin.lsp.trouble')

---@type Lsp.SubMods.Kinds
local Kinds = require('plugin.lsp.kinds')

Kinds:setup()

local api = vim.api
local bo = vim.bo
local Lsp = vim.lsp
local Diag = vim.diagnostic
local lsp_buf = Lsp.buf
-- local lsp_handlers = Lsp.handlers

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

---@type Lsp.Server
local Server = {}

---@type Lsp.Server.Clients
Server.clients = require('plugin.lsp.server_config')

---@param self Lsp.Server
function Server:populate()
    for k, v in next, self.clients do
        if not is_tbl(v) then
            goto continue
        end

        if exists('blink.cmp') then
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            capabilities = vim.tbl_deep_extend(
                'force',
                capabilities,
                require('blink.cmp').get_lsp_capabilities({}, false)
            )

            self.clients[k].capabilities = capabilities
        end

        if k == 'jsonls' then
            self.clients[k].capabilities.textDocument.completion.completionItem.snippetSupport =
                true
        end

        if exists('schemastore') then
            local SchSt = require('schemastore')

            if k == 'jsonls' then
                self.clients[k].settings = {}
                self.clients[k].settings.json = {
                    schemas = SchSt.json.schemas(),
                    validate = { enable = true },
                }
            elseif k == 'yamlls' then
                self.clients[k].settings = {}
                self.clients[k].settings.yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = SchSt.yaml.schemas(),
                }
            end
        end

        ::continue::
    end
end

---@param O? table
---@return Lsp.Server|table
function Server.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Server })
end

Server:populate()

for client, v in next, Server.clients do
    -- lspconfig[client].setup(v)
    vim.lsp.config(client, v)
    vim.lsp.enable(client)
end

---@type KeyMapDict|RegKeysNamed
local Keys = {
    ['<leader>l'] = { group = '+LSP' },

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

vim.schedule(function()
    local Keymaps = require('config.keymaps')

    Keymaps:setup({
        n = Keys,
    })
end)

local group = augroup('UserLspConfig', { clear = false })

au('LspAttach', {
    group = group,

    callback = function(args)
        local buf = args.buf
        local client = Lsp.get_client_by_id(args.data.client_id)

        if is_nil(client) then
            return
        end

        bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        Lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })

        bo[buf].tagfunc = 'v:lua.vim.lsp.tagfunc'

        -- local on_references = Lsp.handlers['textDocument/references']
        -- Lsp.handlers['textDocument/references'] = Lsp.with(on_references, { loclist = true })
        --
        -- Lsp.handlers['textDocument/publishDiagnostics'] =
        --     Lsp.with(Lsp.diagnostic.on_publish_diagnostics, {
        --         signs = true,
        --         virtual_text = true,
        --     })

        ---@type KeyMapDict|RegKeysNamed
        local NK = {
            ['<leader>lc'] = { group = '+Code Actions' },
            ['<leader>lf'] = { group = '+File Analysis' },
            ['<leader>lw'] = { group = '+Workspace' },

            ['<leader>lfD'] = { lsp_buf.declaration, desc('Declaration') },
            ['<leader>lfd'] = { lsp_buf.definition, desc('Definition') },
            -- ['<leader>lk'] = { lsp_buf.hover, desc('Hover') },
            ['K'] = { lsp_buf.hover, desc('Hover') },
            ['<leader>lfi'] = { lsp_buf.implementation, desc('Implementation') },
            ['<leader>lfS'] = { lsp_buf.signature_help, desc('Signature Help') },
            ['<leader>lwa'] = {
                lsp_buf.add_workspace_folder,
                desc('Add Workspace Folder'),
            },
            ['<leader>lwr'] = {
                lsp_buf.remove_workspace_folder,
                desc('Remove Workspace Folder'),
            },
            ['<leader>lwl'] = {
                function()
                    local out = lsp_buf.list_workspace_folders()
                    local msg = ''

                    local notify = require('user_api.util.notify').notify
                    for _, v in next, out do
                        msg = msg .. '\n - ' .. v
                    end

                    notify(msg, 'info', {
                        title = 'Workspace Folders',
                        hide_from_history = false,
                        timeout = 500,
                    })
                end,
                desc('List Workspace Folders'),
            },
            ['<leader>lfT'] = { lsp_buf.type_definition, desc('Type Definition') },
            ['<leader>lfR'] = { lsp_buf.rename, desc('Rename...') },
            ['<leader>lfr'] = { lsp_buf.references, desc('References') },
            ['<leader>lff'] = {
                function() lsp_buf.format({ async = true }) end,
                desc('Format File'),
            },
            ['<leader>lca'] = { lsp_buf.code_action, desc('Code Actions') },
            ['<leader>le'] = { Diag.open_float, desc('Diagnostics Float') },
            ['<leader>lq'] = { Diag.setloclist, desc('Add Loclist') },
        }
        local VK = {
            ['<leader>lc'] = { group = '+Code Actions' },

            ['<leader>lca'] = { lsp_buf.code_action, desc('Code Actions') },
        }

        vim.schedule(function()
            local Keymaps = require('config.keymaps')

            Keymaps:setup({ n = NK, v = VK })
        end)

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
