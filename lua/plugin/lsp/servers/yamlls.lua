local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('yaml-language-server') then
    User.deregister_plugin('plugin.lsp.servers.yamlls')
    return nil
end

User.register_plugin('plugin.lsp.servers.yamlls')

return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
    root_markers = { '.git' },
    settings = {
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
