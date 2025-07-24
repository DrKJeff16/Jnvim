local User = require('user_api')

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
            configurationSources = { 'flake8' },
            plugins = {
                autopep8 = { enabled = false },
                flake8 = {
                    enabled = true,
                    executable = 'flake8',
                    hangClosing = true,
                    indentSize = 4,
                    maxComplexity = 15,
                    maxLineLength = 100,
                    ignore = {
                        'D400',
                        'D401',
                        'F401',
                    },
                },
                pydocstyle = {
                    enabled = true,
                    convention = 'numpy',
                    addIgnore = {
                        'D400',
                        'D401',
                    },
                    ignore = {
                        'D400',
                        'D401',
                    },
                },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
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
                pycodestyle = {
                    enabled = false,
                },
                preload = { enabled = false },
                mccabe = { enabled = true, threshold = 15 },
                rope_autoimport = {
                    completions = { enabled = true },
                },
                rope_completion = {
                    enabled = true,
                    eager = true,
                },
                yapf = { enabled = true },
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
