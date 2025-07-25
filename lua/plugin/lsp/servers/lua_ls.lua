local User = require('user_api')

local extend = vim.tbl_deep_extend
local copy = vim.deepcopy
local fs_stat = (vim.uv or vim.loop).fs_stat

local stdpath = vim.fn.stdpath('config')

---@param client vim.lsp.Client
local function on_init(client)
    if not client.workspace_folders then
        return
    end

    local path = client.workspace_folders[1].name
    local luarc = {
        path .. '/luarc.json',
        path .. '/.luarc.json',
    }

    if path ~= stdpath and (fs_stat(luarc[1]) or fs_stat(luarc[2])) then
        return
    end

    local library = {
        -- vim.env.VIMRUNTIME,
        vim.api.nvim_get_runtime_file('', true),

        '${3rd}/luv/library',
        '${3rd}/busted/library',
    }

    client.config.settings.Lua = extend('force', copy(client.config.settings.Lua), {
        diagnostics = {
            enable = true,
            globals = { 'vim' },
        },
        runtime = {
            pathStrict = false,
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
                '?.lua',
                'lua/?.lua',
                'lua/?/init.lua',
            },
        },
        workspace = {
            checkThirdParty = false,
            useGitIgnore = true,
            library = library,
        },
    })
end

User.register_plugin('plugin.lsp.servers.lua_ls')

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

    on_init = on_init,

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
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
