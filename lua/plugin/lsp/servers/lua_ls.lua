local User = require('user_api')

local fs_stat = (vim.uv or vim.loop).fs_stat
local extend = vim.tbl_deep_extend

local library = { vim.api.nvim_get_runtime_file('', true) }

table.insert(library, '${3rd}/luv/library')
table.insert(library, '${3rd}/busted/library')

User:register_plugin('plugin.lsp.servers.lua_ls')

return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },

    ---@param client vim.lsp.Client
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path:sub(-5) ~= '/nvim' and path:sub(-5) ~= '.nvim' then
                client.config.settings.Lua = extend('force', client.config.settings.Lua, {
                    runtime = {
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                            '?.lua',
                            '?/?.lua',
                            '?/?/init.lua',
                            'init.lua',
                        },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            path,
                            path .. '/lua',
                            path .. '/types',
                        },
                    },
                })

                return
            end
        end

        client.config.settings.Lua = extend('force', client.config.settings.Lua, {
            diagnostics = {
                enable = true,
                globals = { 'vim' },
            },
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                    '?.lua',
                    '?/?.lua',
                    '?/?/init.lua',
                    'init.lua',
                },
            },
            workspace = {
                checkThirdParty = false,
                useGitIgnore = true,
                library = library,
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
                enable = true,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = 'space',
                    indent_size = 4,
                },
            },
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
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                    '?.lua',
                    '?/?.lua',
                    '?/?/init.lua',
                    'init.lua',
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
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
