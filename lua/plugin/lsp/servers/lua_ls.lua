local User = require('user_api')

User:register_plugin('plugin.lsp.servers.lua_ls')

return {
    on_init = function(client)
        local fs_stat = vim.uv.fs_stat

        if client.workspace_folders then
            local path = client.workspace_folders[1].name

            if
                path ~= vim.fn.stdpath('config')
                and (fs_stat(path .. '/.luarc.json') or fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        local lua_settings = vim.deepcopy(client.config.settings.Lua)

        local overrides = {
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
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                useGitIgnore = true,
                library = {
                    -- vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file('', true),
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
            },
        }

        client.config.settings.Lua = vim.tbl_deep_extend('force', lua_settings, overrides)
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
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                },
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
