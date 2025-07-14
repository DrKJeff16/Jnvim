---@diagnostic disable:missing-fields
---@diagnostic disable:need-check-nil

---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'
---@module 'lua.vim.lsp.diagnostic'
---@module 'plugin._types.lsp'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local type_not_empty = Check.value.type_not_empty
local desc = User.maps.kmap.desc

local mk_caps = vim.lsp.protocol.make_client_capabilities

local INFO = vim.log.levels.INFO

---@type Lsp.SubMods.Kinds
local Kinds = require('plugin.lsp.kinds')
Kinds:setup()

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

    local ok, _ = pcall(require, 'blink.cmp')
    if not ok then
        return caps
    end

    caps = vim.tbl_deep_extend(
        'keep',
        vim.deepcopy(caps),
        require('blink.cmp').get_lsp_capabilities({}, true)
    )

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
            vim.lsp.config('*', {
                capabilities = self.make_capabilities(),
            })

            vim.diagnostic.config({
                signs = true,
                float = true,
                underline = false,
                virtual_lines = false,
                virtual_text = true,
                severity_sort = true,
            })

            for client, v in next, self.Clients do
                local new_client = self.populate(client, v)

                vim.lsp.config(client, new_client)
                vim.lsp.enable(client)

                table.insert(self.client_names, client)
            end

            ---@type AllModeMaps
            local Keys = {
                n = {
                    ['<leader>l'] = { group = '+LSP' },

                    ['<leader>li'] = {
                        function()
                            pcall(vim.cmd, 'LspInfo') ---@diagnostic disable-line
                        end,
                        desc('Get LSP Config Info'),
                    },
                    ['<leader>lH'] = {
                        function()
                            vim.lsp.stop_client(vim.lsp.get_clients(), true)
                        end,
                        desc('Stop LSP Servers'),
                    },
                    ['<leader>lC'] = {
                        function()
                            vim.notify((inspect or vim.inspect)(self.client_names), INFO)
                        end,
                        desc('List Clients'),
                    },
                },

                v = { ['<leader>l'] = { group = '+LSP' } },
            }

            local Keymaps = require('user_api.config.keymaps')
            Keymaps(Keys)

            ---@type Lsp.SubMods.Autocmd
            local Autocmd = require('plugin.lsp.autocmd')
            Autocmd:setup()

            ---@type Lsp.SubMods.Trouble
            local Trouble = require('plugin.lsp.trouble')
            Trouble:setup()
        end,
    })
end

local S = Server.new()

User:register_plugin('plugin.lsp')

return S

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
