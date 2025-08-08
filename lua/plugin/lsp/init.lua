---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'
---@module 'lua.vim.lsp.diagnostic'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty
local desc = User.maps.kmap.desc

local in_tbl = vim.tbl_contains
local mk_caps = vim.lsp.protocol.make_client_capabilities
local d_extend = vim.tbl_deep_extend
local copy = vim.deepcopy

local Kinds = require('plugin.lsp.kinds')
Kinds()

---@param original lsp.ClientCapabilities|vim.lsp.ClientConfig
---@param inserts lsp.ClientCapabilities|vim.lsp.ClientConfig|table
---@return lsp.ClientCapabilities|table
local function insert_client(original, inserts)
    return d_extend('keep', inserts or {}, original)
end

---@class Lsp.Server
local Server = {}

---@type string[]|table
Server.client_names = {}

Server.Clients = require('plugin.lsp.server_config')

---@param T? lsp.ClientCapabilities
---@return lsp.ClientCapabilities caps
function Server.make_capabilities(T)
    local caps = d_extend('keep', T or {}, mk_caps())

    if not exists('blink.cmp') then
        return caps
    end

    local blink_caps = require('blink.cmp').get_lsp_capabilities

    caps = d_extend('keep', copy(caps), blink_caps({}, true))

    return caps
end

---@param name string
---@param client vim.lsp.ClientConfig
---@return vim.lsp.ClientConfig client
function Server.populate(name, client)
    if type_not_empty('table', client.capabilities) then
        local old_caps = copy(client.capabilities)
        local caps = Server.make_capabilities(old_caps)

        client.capabilities = insert_client(copy(client.capabilities), caps)
    else
        client.capabilities = Server.make_capabilities()
    end

    if in_tbl({ 'html', 'jsonls' }, name) then
        client.capabilities = insert_client(copy(client.capabilities), {
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
            },
        })
    end

    if name == 'rust_analyzer' then
        client.capabilities = insert_client(copy(client.capabilities), {
            experimental = {
                serverStatusNotification = true,
            },
        })
    end

    if name == 'clangd' then
        client.capabilities = insert_client(copy(client.capabilities), {
            offsetEncoding = { 'utf-8', 'utf-16' },
            textDocument = {
                completion = {
                    editsNearCursor = true,
                },
            },
        })
    end

    if name == 'gh_actions_ls' then
        client.capabilities = insert_client(copy(client.capabilities), {
            workspace = {
                didChangeWorkspaceFolders = {
                    dynamicRegistration = true,
                },
            },
        })
    end

    if exists('schemastore') then
        local ss = require('schemastore')

        if name == 'jsonls' then
            if client.settings == nil then
                client.settings = { json = {} }
            elseif client.settings.json == nil then
                client.settings.json = {}
            end

            client.settings = insert_client(copy(client.settings), {
                json = {
                    schemas = ss.json.schemas(),
                    validate = { enable = true },
                },
            })
        end

        if name == 'yamlls' then
            if client.settings == nil then
                client.settings = { yaml = {} }
            elseif client.settings.yaml == nil then
                client.settings.yaml = {}
            end

            client.settings = insert_client(copy(client.settings), {
                yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = ss.yaml.schemas(),
                },
            })
        end
    end

    return client
end

---@return table|Lsp.Server|fun()
function Server.new()
    return setmetatable({}, {
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

            User.register_plugin('plugin.lsp')
        end,
    })
end

return Server.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
