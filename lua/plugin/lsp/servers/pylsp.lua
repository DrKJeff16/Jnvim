local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('pylsp') then
    User.deregister_plugin('plugin.lsp.servers.pylsp')
    return nil
end

User.register_plugin('plugin.lsp.servers.pylsp')

return {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },

    settings = {
        pylsp = {
            ---@type { [1]: 'pycodestyle'|'flake8', [2]: 'flake8'|'pycodestyle' }
            configurationSources = { 'pycodestyle' },

            plugins = {
                autopep8 = { enabled = true },
                flake8 = {
                    enabled = false,
                    executable = 'flake8',
                    hangClosing = true,
                    indentSize = 4,
                    maxComplexity = 15,
                    maxLineLength = 100,
                    ignore = { 'D400', 'D401', 'F401' },
                },
                jedi_completion = {
                    enabled = true,
                    eager = true,
                    fuzzy = true,
                    resolve_at_most = 30,
                },
                jedi_definition = {
                    enabled = true,
                    follow_imports = true,
                    follow_builtin_imports = true,
                    follow_builtin_definitions = true,
                },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = {
                    enabled = true,
                    all_scopes = true,
                    include_import_symbols = true,
                },
                mccabe = { enabled = true, threshold = 15 },
                preload = {
                    enabled = true,
                    modules = {
                        'sys',
                        'typing',
                        'os',
                        'argparse',
                        'string',
                        're',
                    },
                },
                pycodestyle = {
                    enabled = true,
                    ignore = { 'D400', 'D401', 'F401' },
                    maxLineLength = 100,
                    indentSize = 4,
                    hangClosing = false,
                },
                pydocstyle = {
                    enabled = true,
                    convention = 'numpy',
                    addIgnore = { 'D400', 'D401' },
                    ignore = { 'D400', 'D401' },
                },
                pyflakes = { enabled = true },
                pylint = { enabled = false },
                rope_autoimport = { completions = { enabled = true } },
                rope_completion = { enabled = true, eager = true },
                yapf = { enabled = false },
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
