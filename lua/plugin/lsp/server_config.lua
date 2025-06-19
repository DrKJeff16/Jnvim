---@diagnostic disable:missing-fields

---@module 'user_api.types.lspconfig'

local User = require('user_api')
local Check = User.check

User:register_plugin('plugin.lsp.server_config')

---@type Lsp.Server.Clients
local Clients = {}

Clients.bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git', '.stylua.toml', 'stylua.toml' },
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
        local fs_stat = (vim.uv or vim.loop).fs_stat

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
                    'init.lua',
                    '?.lua',
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --     vim.api.nvim_get_runtime_file('', true),
                -- },
            },
        })
    end,

    settings = {
        Lua = {
            addonManager = {
                enable = true,
            },
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
                version = 'LuaJIT',
                path = {
                    'init.lua',
                    '?.lua',
                    'lua/?.lua',
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
                    vim.env.VIMRUNTIME,
                    -- vim.api.nvim_get_runtime_file('', true),
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

    capabilities = {
        offsetEncoding = { 'utf-8', 'utf-16' },

        textDocument = {
            completion = { editsNearCursor = true },
        },
    },

    settings = {
        clangd = {
            checkUpdates = true,
            detectExtensionConflicts = true,
            enableCodeCompletion = true,
            inactiveRegions = {
                opacity = 0.90,
                useBackgroundHighlight = false,
            },
            onConfigChanged = 'restart',
            path = '/usr/bin/clangd',
            restartAfterCrash = true,
            serverCompletionRanking = true,
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

            rope = {
                ropeFolder = nil,
            },
        },
    },
}

Clients.vimls = {
    cmd = { 'vim-language-server', '--stdio' },
    filetypes = { 'vim' },
    init_options = {
        diagnostic = {
            enable = true,
        },
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
    init_options = {
        provideFormatter = true,
    },
    root_markers = { '.git' },
}

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
