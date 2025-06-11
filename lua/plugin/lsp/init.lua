---@diagnostic disable:missing-fields
---@diagnostic disable:need-check-nil

---@module 'user_api.types.lspconfig'

local User = require('user_api')
local Check = User.check
local Maps = User.maps

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local desc = Maps.kmap.desc

if not exists('lspconfig') then
    return
end

User:register_plugin('plugin.lsp')

require('plugin.lsp.mason')
require('plugin.lsp.neoconf')

---@type Lsp.SubMods.Kinds
local Kinds = require('plugin.lsp.kinds')
Kinds:setup()

---@type Lsp.SubMods.Trouble
local Trouble = require('plugin.lsp.trouble')
Trouble:setup()

---@type Lsp.Server
local Server = {}

---@type Lsp.Server.Clients
Server.Clients = require('plugin.lsp.server_config')

---@return lsp.ClientCapabilities
function Server.make_capabilities()
    local caps = vim.lsp.protocol.make_client_capabilities()

    local ok, _ = pcall(require, 'blink.cmp')
    if not ok then
        return caps
    end

    caps = vim.tbl_deep_extend(
        'force',
        vim.deepcopy(caps),
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

        self.Clients[key].capabilities = self.make_capabilities()

        if key == 'jsonls' then
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

---@param O? table
---@return table|Lsp.Server
function Server.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Server })
end

vim.lsp.config('*', {
    capabilities = Server.make_capabilities(),
})

Server:populate()

for client, v in next, Server.Clients do
    vim.lsp.config(client, v)
    vim.lsp.enable(client)
end

vim.diagnostic.config({
    signs = true,
    float = true,
    underline = true,
    virtual_lines = false,
    virtual_text = true,
})

---@type AllModeMaps
local Keys = {
    n = {
        ['<leader>l'] = { group = '+LSP' },

        ['<leader>lI'] = {
            function() vim.cmd('LspInfo') end,
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
