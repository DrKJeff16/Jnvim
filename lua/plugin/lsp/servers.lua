local User = require('user_api')
local Check = User.check

local type_not_empty = Check.value.type_not_empty
local executable = Check.exists.executable

---@param name string
---@param exe? string
---@return vim.lsp.Config|nil
local function server_load(name, exe)
    if not type_not_empty('string', exe) then
        exe = name
    end

    if not executable(exe) then
        return nil
    end

    local ok, mod = pcall(require, 'plugin.lsp.servers.' .. name)

    return ok and mod or nil
end

---@class Lsp.Server.Clients
local Clients = {
    lua_ls = server_load('lua_ls', 'lua-language-server'),

    bashls = server_load('bashls', 'bash-language-server'),

    pylsp = server_load('pylsp', 'pylsp'),

    clangd = server_load('clangd', 'clangd'),
    cmake = server_load('cmake', 'cmake-language-server'),
    rust_analyzer = server_load('rust_analyzer', 'rust-analyzer'),
    jdtls = server_load('jdtls', 'jdtls'),
    asm_lsp = server_load('asm_lsp', 'asm-lsp'),

    vimls = server_load('vimls', 'vim-language-server'),

    dockerls = server_load('dockerls', 'docker-langserver'),
    docker_compose_language_service = server_load(
        'docker_compose_language_service',
        'docker-compose-langserver'
    ),

    texlab = server_load('texlab', 'texlab'),

    marksman = server_load('marksman', 'marksman'),
    gh_actions_ls = server_load('gh_actions_ls', 'gh-action-language-server'),

    html = server_load('html', 'vscode-html-language-server'),
    jsonls = server_load('jsonls', 'vscode-json-language-server'),
    cssls = server_load('cssls', 'vscode-css-language-server'),
    css_variables = server_load('css_variables', 'css-variables-language-server'),
    cssmodules_ls = server_load('cssmodules_ls', 'cssmodules-language-server'),

    taplo = server_load('taplo', 'taplo'),
    yamlls = server_load('yamlls', 'yaml-language-server'),
    hyprls = server_load('hyprls', 'hyprls'),
}

_G.CLIENTS = Clients

User.register_plugin('plugin.lsp.servers')

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
