---@diagnostic disable:missing-fields
---@diagnostic disable:need-check-nil

---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'
---@module 'lua.vim.lsp.diagnostic'
---@module 'user_api.types.lsp'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local desc = User.maps.kmap.desc

---@type Lsp.SubMods.Kinds
local Kinds = require('plugin.lsp.kinds')
Kinds:setup()

---@type Lsp.Server
local Server = {}

---@type (string|Lsp.Server.Key)[]|table
Server.client_names = {}

---@type Lsp.Server.Clients
Server.Clients = require('plugin.lsp.server_config')

---@param T? table|lsp.ClientCapabilities
---@return lsp.ClientCapabilities
function Server.make_capabilities(T)
    T = is_tbl(T) and T or {}

    T = vim.tbl_deep_extend('keep', T, vim.lsp.protocol.make_client_capabilities())

    local ok, _ = pcall(require, 'blink.cmp')
    if not ok then
        return T
    end

    local caps = vim.tbl_deep_extend(
        'keep',
        vim.deepcopy(T),
        require('blink.cmp').get_lsp_capabilities({}, true)
    )

    return caps
end

---@param self Lsp.Server
function Server:populate()
    for k, v in next, self.Clients do
        if not is_tbl(v) then
            goto continue
        end

        ---@type Lsp.Server.Key
        local key = k

        if not is_tbl(self.Clients[key].capabilities) then
            self.Clients[key].capabilities = self.make_capabilities()
        else
            local old_caps = self.Clients[key].capabilities

            self.Clients[key].capabilities =
                vim.tbl_deep_extend('keep', old_caps, self.make_capabilities(old_caps))
        end

        if vim.tbl_contains({ 'html', 'jsonls' }, key) then
            self.Clients[key].capabilities.textDocument.completion.completionItem.snippetSupport =
                true
        end

        if exists('schemastore') then
            local ss = require('schemastore')

            if key == 'jsonls' then
                self.Clients[key].settings =
                    vim.tbl_deep_extend('force', self.Clients[key].settings or {}, {
                        json = {
                            schemas = ss.json.schemas(),
                            validate = { enable = true },
                        },
                    })
            end

            if key == 'yamlls' then
                self.Clients[k].settings =
                    vim.tbl_deep_extend('force', self.Clients[key].settings or {}, {
                        yaml = {
                            schemaStore = { enable = false, url = '' },
                            schemas = ss.yaml.schemas(),
                        },
                    })
            end
        end

        ::continue::
    end
end

---@param self Lsp.Server
function Server:setup() end

---@param O? table
---@return table|Lsp.Server
function Server.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, {
        __index = Server,

        ---@param self Lsp.Server
        __newindex = function(self, key, value) rawset(self, key, value) end,

        ---@param self Lsp.Server
        __call = function(self)
            self:populate()

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
                vim.lsp.config(client, v)
                vim.lsp.enable(client)

                table.insert(self.client_names, client)
            end

            ---@type AllModeMaps
            local Keys = {
                n = {
                    ['<leader>l'] = { group = '+LSP' },

                    ['<leader>lI'] = {
                        ---@diagnostic disable-next-line
                        function() pcall(vim.cmd, 'LspInfo') end,
                        desc('Get LSP Config Info'),
                    },
                    ['<leader>lH'] = {
                        function() vim.lsp.stop_client(vim.lsp.get_clients(), true) end,
                        desc('Stop LSP Servers'),
                    },
                },

                v = { ['<leader>l'] = { group = '+LSP' } },
            }

            ---@type Config.Keymaps
            local Keymaps = require('config.keymaps')
            Keymaps:setup(Keys)

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

_G.CLIENT_CONFS = vim.deepcopy(S.Clients)

User:register_plugin('plugin.lsp')

return S

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
