---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'
---@module 'lua.vim.lsp.diagnostic'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty
local executable = Check.exists.executable
local desc = User.maps.desc

local in_list = vim.list_contains
local mk_caps = vim.lsp.protocol.make_client_capabilities
local d_extend = vim.tbl_deep_extend
local copy = vim.deepcopy

---@param original lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
---@param inserts? lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
---@return lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
local function insert_client(original, inserts)
    return d_extend('keep', inserts or {}, original)
end

---@class Lsp.Server
local Server = {}

Server.client_names = {} ---@type string[]
Server.Clients = require('plugin.lsp.servers')

---@param T lsp.ClientCapabilities|nil
---@return lsp.ClientCapabilities caps
function Server.make_capabilities(T)
    local caps = d_extend('keep', T or {}, mk_caps())
    if not exists('blink.cmp') then
        return caps
    end

    local blink_caps = require('blink.cmp').get_lsp_capabilities
    caps = d_extend('keep', copy(caps), blink_caps({}, true))
    return caps
end

---@param name string
---@param config vim.lsp.Config
---@return vim.lsp.Config config
function Server.populate(name, config)
    if type_not_empty('table', config.capabilities) then
        local old_caps = copy(config.capabilities)
        local caps = Server.make_capabilities(old_caps)
        config.capabilities = insert_client(copy(config.capabilities), caps)
    else
        config.capabilities = Server.make_capabilities()
    end

    if in_list({ 'html', 'jsonls' }, name) then
        config.capabilities = insert_client(copy(config.capabilities), {
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
            },
        })
        return config
    end

    if name == 'rust_analyzer' then
        config.capabilities = insert_client(copy(config.capabilities), {
            experimental = {
                serverStatusNotification = true,
            },
        })
        return config
    end
    if name == 'clangd' then
        config.capabilities = insert_client(copy(config.capabilities), {
            offsetEncoding = { 'utf-8', 'utf-16' },
            textDocument = {
                completion = {
                    editsNearCursor = true,
                },
            },
        })
        return config
    end
    if name == 'gh_actions_ls' then
        config.capabilities = insert_client(copy(config.capabilities), {
            workspace = {
                didChangeWorkspaceFolders = {
                    dynamicRegistration = true,
                },
            },
        })
        return config
    end
    if name == 'lua_ls' and exists('lazydev') then
        config.root_dir = function(bufnr, on_dir)
            on_dir(require('lazydev').find_workspace(bufnr))
        end
        return config
    end
    if exists('schemastore') then
        if name == 'jsonls' then
            if not config.settings then
                config.settings = {}
            end
            config.settings = insert_client(copy(config.settings), {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            })
        end
        if name == 'yamlls' then
            if not config.settings then
                config.settings = {}
            end
            config.settings = insert_client(copy(config.settings), {
                yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = require('schemastore').yaml.schemas(),
                },
            })
        end
    end
    return config
end

function Server.setup()
    vim.lsp.protocol.TextDocumentSyncKind.Full = 1
    vim.lsp.protocol.TextDocumentSyncKind[1] = 'Full'

    vim.lsp.config('*', {
        capabilities = Server.make_capabilities(),
    })

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '',
                [vim.diagnostic.severity.HINT] = '󰌵',
            },
        },
        float = true,
        underline = true,
        virtual_lines = false,
        virtual_text = true,
        severity_sort = false,
    })

    vim.lsp.log.set_level(vim.log.levels.WARN)

    for name, client in next, Server.Clients do
        if client then
            vim.lsp.config(name, Server.populate(name, client))
            if not in_list(Server.client_names, name) then
                table.insert(Server.client_names, name)
            end
        end
    end

    vim.lsp.enable(Server.client_names)
    local Keys = { ---@type AllModeMaps
        n = {
            ['<leader>l'] = { group = '+LSP' },
            ['<leader>li'] = {
                function()
                    if exists('lspconfig') then
                        vim.cmd.LspInfo()
                    end
                end,
                desc('Get LSP Config Info'),
            },
            ['<leader>lC'] = {
                function()
                    vim.print(Server.client_names)
                end,
                desc('List Clients'),
            },
        },

        v = { ['<leader>l'] = { group = '+LSP' } },
    }

    local Keymaps = require('user_api.config.keymaps')
    Keymaps(Keys)

    local Autocmd = require('plugin.lsp.autocmd')
    Autocmd()

    local Kinds = require('plugin.lsp.kinds')
    Kinds()

    local Trouble = require('plugin.lsp.trouble')
    Trouble()
end

---@param config vim.lsp.Config
---@param name string
---@param exe? string
function Server.add(config, name, exe)
    exe = type_not_empty('string', exe) and exe or name

    if not executable(exe) then
        return
    end

    local cfg = Server.Clients[name]

    Server.Clients[name] = cfg and d_extend('force', cfg, config) or config
    Server.Clients[name] = Server.populate(name, copy(Server.Clients[name]))

    Server.setup()
end

return Server

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
