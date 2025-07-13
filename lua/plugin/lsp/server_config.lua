---@diagnostic disable:missing-fields

---@module 'plugin._types.lsp'

local User = require('user_api')

local uv = vim.uv or vim.loop

---@type Lsp.Server.Clients
local Clients = {}

Clients.bashls = {
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

Clients.lua_ls = {
    on_init = function(client)
        local fs_stat = uv.fs_stat

        if client.workspace_folders then
            local path = client.workspace_folders[1].name

            if
                path ~= vim.fn.stdpath('config')
                and (fs_stat(path .. '/.luarc.json') or fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('keep', client.config.settings.Lua, {
            addonManager = { enable = true },
            codeLens = { enable = true },
            completion = {
                autoRequire = false,
                callSnippet = 'Replace',
                displayContext = 8,
                enable = true,
                keywordSnippet = 'Replace',
                postfix = '@',
                requireSeparator = '.',
                showParams = true,
                showWord = 'Enable',
                workspaceWord = true,
            },
            diagnostics = {
                disable = { 'inject-field', 'missing-fields' },
                enable = true,
                globals = { 'vim' },
            },
            format = { enable = true },
            hint = {
                arrayIndex = 'Auto',
                await = true,
                enable = true,
                paramName = 'All',
                paramType = true,
                semicolon = 'SameLine',
                setType = true,
            },
            hover = {
                enable = true,
                enumsLimit = 50,
                expandAlias = true,
                previewFields = 50,
                viewNumber = true,
                viewString = true,
                viewStringMax = 1000,
            },
            semantic = {
                annotation = true,
                enable = true,
                keyword = true,
                variable = true,
            },
            signatureHelp = { enable = true },
            type = {
                castNumberToInteger = false,
                inferParamType = true,
                weakNilCheck = true,
                weakUnionCheck = true,
            },
            window = {
                progressBar = false,
                statusBar = false,
            },
            runtime = {
                fileEncoding = 'utf8',
                pathStrict = false,
                unicodeName = false,
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    -- vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file('', true),
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                },
            },
        })
    end,

    settings = {
        Lua = {
            addonManager = { enable = true },
            codeLens = { enable = true },
            completion = {
                autoRequire = false,
                callSnippet = 'Replace',
                displayContext = 8,
                enable = true,
                keywordSnippet = 'Replace',
                postfix = '@',
                requireSeparator = '.',
                showParams = true,
                showWord = 'Enable',
                workspaceWord = true,
            },
            diagnostics = {
                disable = { 'inject-field', 'missing-fields' },
                enable = true,
                globals = { 'vim' },
            },
            format = { enable = true },
            hint = {
                arrayIndex = 'Auto',
                await = true,
                enable = true,
                paramName = 'All',
                paramType = true,
                semicolon = 'SameLine',
                setType = true,
            },
            hover = {
                enable = true,
                enumsLimit = 50,
                expandAlias = true,
                previewFields = 50,
                viewNumber = true,
                viewString = true,
                viewStringMax = 1000,
            },
            runtime = {
                fileEncoding = 'utf8',
                pathStrict = false,
                unicodeName = false,
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/?.lua',
                    'lua/?/init.lua',
                },
            },
            semantic = {
                annotation = true,
                enable = true,
                keyword = true,
                variable = true,
            },
            signatureHelp = { enable = true },
            type = {
                castNumberToInteger = false,
                inferParamType = true,
                weakNilCheck = true,
                weakUnionCheck = true,
            },
            window = {
                progressBar = false,
                statusBar = false,
            },
            workspace = {
                checkThirdParty = false,
                useGitIgnore = true,
                library = {
                    -- vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file('', true),
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                },
            },
        },
    },
}

Clients.clangd = {
    cmd = { 'clangd' },
    filetypes = {
        'c',
        'cpp',
        'objc',
        'objcpp',
        'cuda',
        'proto',
    },

    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },

    settings = {
        clangd = {
            checkUpdates = false,
            detectExtensionConflicts = true,
            enableCodeCompletion = true,
            onConfigChanged = 'restart',
            path = '/usr/bin/clangd',
            restartAfterCrash = true,
            serverCompletionRanking = false,
        },
    },
}

Clients.pylsp = {
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

Clients.vimls = {
    cmd = { 'vim-language-server', '--stdio' },
    filetypes = { 'vim' },
    init_options = {
        diagnostic = { enable = true },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
            runtimepath = true,
        },
        isNeovim = true,
        iskeyword = '@,48-57,_,192-255,-#',
        runtimepath = '',
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true,
        },
        vimruntime = '',
    },
    root_markers = { '.git' },
}

Clients.jsonls = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = { provideFormatter = true },
    root_markers = { '.git' },
}

Clients.marksman = {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_markers = { '.git', '.marksman.toml' },
}

Clients.cmake = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    init_options = { buildDirectory = 'build' },
    root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
}

Clients.html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html', 'templ' },
    init_options = {
        configurationSection = { 'html', 'css', 'javascript' },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        provideFormatter = true,
    },
    root_markers = { 'package.json', '.git' },
    settings = {},
}

Clients.cssls = {
    cmd = { 'vscode-css-language-server', '--stdio' },

    filetypes = { 'css', 'scss', 'less' },
    init_options = { provideFormatter = true },
    root_markers = { 'package.json', '.git' },

    settings = {
        css = { validate = true },
        less = { validate = true },
        scss = { validate = true },
    },
}

Clients.css_variables = {
    cmd = { 'css-variables-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },

    settings = {
        cssVariables = {
            blacklistFolders = {
                '**/.cache',
                '**/.DS_Store',
                '**/.git',
                '**/.hg',
                '**/.next',
                '**/.svn',
                '**/bower_components',
                '**/CVS',
                '**/dist',
                '**/node_modules',
                '**/tests',
                '**/tmp',
            },
            lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
        },
    },
}

Clients.taplo = {}

Clients.yamlls = {
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

_G.CLIENTS = Clients

User:register_plugin('plugin.lsp.server_config')

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
