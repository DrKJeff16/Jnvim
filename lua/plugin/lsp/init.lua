---@diagnostic disable:missing-fields
---@diagnostic disable:inject-field

---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'
---@module 'lua.vim.lsp.diagnostic'

---@alias Lsp.Server.Key
---|'lua_ls'
---|'bashls'
---|'clangd'
---|'cmake'
---|'css_variables'
---|'cssls'
---|'html'
---|'jdtls'
---|'jsonls'
---|'julials'
---|'marksman'
---|'pylsp'
---|'taplo'
---|'texlab'
---|'vimls'
---|'yamlls'
---|string

---@class Lsp.Server
---@field Clients table<Lsp.Server.Key, vim.lsp.ClientConfig>
---@field client_names (string|Lsp.Server.Key)[]|table
---@field make_capabilities fun(T: table|lsp.ClientCapabilities?): lsp.ClientCapabilities|table
---@field populate fun(name: string, client: table|vim.lsp.ClientConfig): (client: table|vim.lsp.ClientConfig)
---@field new fun(O: table?): table|Lsp.Server|fun()

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local type_not_empty = Check.value.type_not_empty
local desc = User.maps.kmap.desc

local mk_caps = vim.lsp.protocol.make_client_capabilities

---@type Lsp.SubMods.Kinds
local Kinds = require('plugin.lsp.kinds')
Kinds()

---@type Lsp.Server|fun()
local Server = {}

---@type (string|Lsp.Server.Key)[]|table
Server.client_names = {}

---@type Lsp.Server.Clients
Server.Clients = require('plugin.lsp.server_config')

---@param T? table|lsp.ClientCapabilities
---@return lsp.ClientCapabilities
function Server.make_capabilities(T)
    T = is_tbl(T) and T or {}

    local caps = vim.tbl_deep_extend('keep', T, mk_caps())

    if not exists('blink.cmp') then
        return caps
    end

    local blink_caps = require('blink.cmp').get_lsp_capabilities

    caps = vim.tbl_deep_extend('keep', vim.deepcopy(caps), blink_caps({}, true))

    return caps
end

---@param name string
---@param client table|vim.lsp.ClientConfig
---@return table|vim.lsp.ClientConfig client
function Server.populate(name, client)
    if type_not_empty('table', client.capabilities) then
        local old_caps = vim.deepcopy(client.capabilities)
        local caps = Server.make_capabilities(old_caps)

        client.capabilities = vim.tbl_deep_extend('keep', old_caps, caps)
    else
        client.capabilities = Server.make_capabilities()
    end

    client.capabilities.textDocument.completion.completionItem.snippetSupport = true

    if exists('schemastore') then
        local ss = require('schemastore')

        if name == 'jsonls' then
            client.settings = is_tbl(client.settings) and client.settings or { json = {} }
            client.settings.json = is_tbl(client.settings.json) and client.settings.json or {}
            client.settings.json.schemas = ss.json.schemas()
            client.settings.json.validate = { enable = true }
        end

        if name == 'yamlls' then
            client.settings = is_tbl(client.settings) and client.settings or { yaml = {} }
            client.settings.yaml = is_tbl(client.settings.yaml) and client.settings.yaml or {}
            client.settings.yaml.schemaStore = { enable = false, url = '' }
            client.settings.yaml.schemas = ss.yaml.schemas()
        end
    end

    return client
end

---@param O? table
---@return table|Lsp.Server|fun()
function Server.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, {
        __index = Server,

        ---@param self Lsp.Server
        __call = function(self)
            vim.lsp.protocol.TextDocumentSyncKind.Full = 1
            vim.lsp.protocol.TextDocumentSyncKind[1] = 'Full'

            vim.lsp.config('*', {
                capabilities = self.make_capabilities(),
            })

            vim.diagnostic.config({
                signs = true,
                float = true,
                underline = true,
                virtual_lines = false,
                virtual_text = true,
                severity_sort = false,
            })

            for client, v in next, self.Clients do
                local new_client = self.populate(client, v)

                vim.lsp.config[client] = new_client
                vim.lsp.enable(client)

                table.insert(self.client_names, client)
            end

            ---@type AllModeMaps
            local Keys = {
                n = {
                    ['<leader>l'] = { group = '+LSP' },

                    ['<leader>li'] = {
                        function()
                            if exists('lspconfig') then
                                vim.cmd.LspInfo()
                            end
                        end,
                        desc('Get LSP Config Info'),
                    },
                    ['<leader>lC'] = {
                        function()
                            vim.print(self.client_names)
                        end,
                        desc('List Clients'),
                    },
                },

                v = { ['<leader>l'] = { group = '+LSP' } },
            }

            local Keymaps = require('user_api.config.keymaps')
            Keymaps(Keys)

            local Autocmd = require('plugin.lsp.autocmd')
            Autocmd()

            local Trouble = require('plugin.lsp.trouble')
            Trouble()
        end,
    })
end

User.register_plugin('plugin.lsp')

return Server.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
