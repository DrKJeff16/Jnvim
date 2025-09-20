local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('bash-language-server') then
    User.deregister_plugin('plugin.lsp.servers.bashls')
    return nil
end

User.register_plugin('plugin.lsp.servers.bashls')

return {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
    settings = {
        bashIde = {
            backgroundAnalysisMaxFiles = 500,
            enableSourceErrorDiagnostics = true,
            globPattern = '**/*@(.sh|.inc|.bash|.command)',
            includeAllWorkspaceSymbols = true,
            logLevel = 'warning',
            shellcheckPath = 'shellcheck',
            shfmt = {
                binaryNextLine = true,
                caseIndent = true,
                funcNextLine = false,
                ignoreEditorconfig = false,
                keepPadding = true,
                languageDialect = 'auto',
                path = 'shfmt',
                simplifyCode = false,
                spaceRedirects = true,
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
