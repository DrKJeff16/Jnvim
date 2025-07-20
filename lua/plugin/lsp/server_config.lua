---@diagnostic disable:missing-fields

---@alias Lsp.Server.Clients.Spec vim.lsp.ClientConfig

---@class Lsp.Server.Clients
---@field lua_ls? Lsp.Server.Clients.Spec
---@field bashls? Lsp.Server.Clients.Spec
---@field clangd? Lsp.Server.Clients.Spec
---@field cmake? Lsp.Server.Clients.Spec
---@field css_variables? Lsp.Server.Clients.Spec
---@field cssls? Lsp.Server.Clients.Spec
---@field html? Lsp.Server.Clients.Spec
---@field jdtls? Lsp.Server.Clients.Spec
---@field jsonls? Lsp.Server.Clients.Spec
---@field julials? Lsp.Server.Clients.Spec
---@field marksman? Lsp.Server.Clients.Spec
---@field pylsp? Lsp.Server.Clients.Spec
---@field taplo? Lsp.Server.Clients.Spec
---@field texlab? Lsp.Server.Clients.Spec
---@field vimls? Lsp.Server.Clients.Spec
---@field yamlls? Lsp.Server.Clients.Spec

local User = require('user_api')

---@param name string
---@return vim.lsp.ClientConfig
local function server_load(name)
    local modstr = 'plugin.lsp.servers.' .. name

    local ok, mod = pcall(require, modstr)

    return ok and mod or {}
end

---@type Lsp.Server.Clients
local Clients = {}

Clients.lua_ls = server_load('lua_ls')
Clients.bashls = server_load('bashls')
Clients.clangd = server_load('clangd')
Clients.pylsp = server_load('pylsp')
Clients.vimls = server_load('vimls')
Clients.jsonls = server_load('jsonls')
Clients.jsonls = server_load('jsonls')
Clients.marksman = server_load('marksman')
Clients.cmake = server_load('cmake')
Clients.html = server_load('html')
Clients.cssls = server_load('cssls')
Clients.css_variables = server_load('css_variables')
Clients.taplo = server_load('taplo')
Clients.yamlls = server_load('yamlls')

_G.CLIENTS = Clients

User:register_plugin('plugin.lsp.server_config')

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
