---@diagnostic disable:missing-fields

---@module 'user_api.types.lspconfig'

local User = require('user_api')
local Check = User.check

local function symbol_info()
    local lsp = vim.lsp

    local bufnr = vim.api.nvim_get_current_buf()
    local clangd_client = lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]

    if not (clangd_client and clangd_client.supports_method('textDocument/symbolInfo')) then
        return vim.notify('Clangd client not found', vim.log.levels.ERROR)
    end

    local win = vim.api.nvim_get_current_win()
    local params = lsp.util.make_position_params(win, clangd_client.offset_encoding)

    clangd_client.request('textDocument/symbolInfo', params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is not reason to parse it
            return
        end

        local container = string.format('container: %s', res[1].containerName) ---@type string
        local name = string.format('name: %s', res[1].name) ---@type string

        lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            border = 'single',
            title = 'Symbol Info',
        })
    end, bufnr)
end

---@param bufnr integer
local function switch_source_header(bufnr)
    local lsp = vim.lsp

    local method_name = 'textDocument/switchSourceHeader'
    local client = lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]

    if not client then
        local msg = 'method %s is not supported by any servers active on the current buffer'

        return vim.notify(msg:format(method_name))
    end

    local params = lsp.util.make_text_document_params(bufnr)

    client.request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end

        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end

        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

User:register_plugin('plugin.lsp.server_config')

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

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
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
                --   vim.api.nvim_get_runtime_file('', true),
                -- }
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
                disable = { 'inject-field' },
                enable = true,
                globals = {
                    'vim',
                },
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
                enumsLimit = 30,
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
                progressBar = true,
                statusBar = true,
            },
            workspace = {
                checkThirdParty = false,
                useGitIgnore = true,
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
            completion = {
                editsNearCursor = true,
            },
        },
    },

    on_attach = function()
        vim.api.nvim_buf_create_user_command(
            0,
            'LspClangdSwitchSourceHeader',
            function() switch_source_header(0) end,
            { desc = 'Switch between source/header' }
        )

        vim.api.nvim_buf_create_user_command(
            0,
            'LspClangdShowSymbolInfo',
            function() symbol_info() end,
            { desc = 'Show symbol info' }
        )
    end,
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
        '.git',
    },

    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391' },
                    maxLineLength = 100,
                },
            },
        },
    },
}

return Clients

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
