local User = require('user_api')

User:register_plugin('plugin.lsp.servers.pylsp')

return {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'Pipfile.lock',
        '.git',
    },

    settings = {
        pylsp = {
            configurationSources = { 'flake8' },
            plugins = {
                autopep8 = { enabled = true },
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
                jedi = {
                    auto_import_modules = { 'sys', 'argparse', 'typing' },
                },
                jedi_completion = {
                    enabled = true,
                    eager = true,
                    fuzzy = true,
                    resolve_at_most = 30,

                    cache_for = {
                        'argparse',
                        'numpy',
                        'os',
                        're',
                        'sys',
                        'tensorflow',
                        'typing',
                    },
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
                    all_scopes = false,
                    include_import_symbols = false,
                },
                pycodestyle = {
                    enabled = false,
                    ignore = { 'W391' },
                    maxLineLength = 100,
                },
                preload = { enabled = false },
                mccabe = { enabled = true, threshold = 15 },
                rope_autoimport = {
                    completions = { enabled = false },
                },
                rope_completion = {
                    enabled = true,
                    eager = true,
                },
                yapf = { enabled = false },
            },

            rope = { ropeFolder = nil },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
