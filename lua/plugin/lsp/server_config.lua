local User = require('user_api')
local executable = require('user_api.check.exists').executable

---@param name string
---@param exe string
---@return vim.lsp.Config|nil
local function server_load(name, exe)
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

    clangd = server_load('clangd', 'clangd'),

    pylsp = server_load('pylsp', 'pylsp'),

    vimls = server_load('vimls', 'vim-language-server'),

    jsonls = server_load('jsonls', 'vscode-json-language-server'),

    docker_compose_language_service = server_load(
        'docker_compose_language_service',
        'docker-compose-langserver'
    ),

    dockerls = server_load('dockerls', 'docker-langserver'),

    marksman = server_load('marksman', 'marksman'),

    cmake = server_load('cmake', 'cmake-language-server'),

    cssls = server_load('cssls', 'vscode-css-language-server'),
    css_variables = server_load('css_variables', 'css-variables-language-server'),
    html = server_load('html', 'vscode-html-language-server'),

    rust_analyzer = server_load('rust_analyzer', 'rust-analyzer'),

    taplo = server_load('taplo', 'taplo'),

    gh_actions_ls = server_load('gh_actions_ls', 'gh-action-language-server'),

    texlab = server_load('texlab', 'texlab'),

    yamlls = server_load('yamlls', 'yaml-language-server'),

    hyprls = server_load('hyprls', 'hyprls'),

    asm_lsp = server_load('asm_lsp', 'asm-lsp'),
}

_G.CLIENTS = Clients

User.register_plugin('plugin.lsp.server_config')

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
