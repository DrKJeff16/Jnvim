---@diagnostic disable:missing-fields

---@module 'user_api.types.lsp'

local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check
local Au = User.util.au
local Notify = User.util.notify

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local desc = User.maps.kmap.desc
local au = Au.au_repeated
local notify = Notify.notify

local augroup = vim.api.nvim_create_augroup

local function print_workspace_folders()
    local msg = ''

    for _, v in next, vim.lsp.buf.list_workspace_folders() do
        msg = msg .. '\n - ' .. v
    end

    notify(msg, 'debug', {
        title = 'LSP',
        animate = true,
        hide_from_history = true,
        timeout = 5000,
    })
end

---@type Lsp.SubMods.Autocmd
local Autocmd = {}

---@type AllModeMaps
Autocmd.AUKeys = {
    n = {
        ['<leader>lf'] = { group = '+File Operations' },
        ['<leader>lw'] = { group = '+Workspace' },

        ['K'] = { vim.lsp.buf.hover, desc('Hover') },

        ['<leader>lK'] = { vim.lsp.buf.hover, desc('Hover') },
        ['<leader>lfD'] = { vim.lsp.buf.declaration, desc('Declaration') },
        ['<leader>lfd'] = { vim.lsp.buf.definition, desc('Definition') },
        ['<leader>lfi'] = { vim.lsp.buf.implementation, desc('Implementation') },
        ['<leader>lfS'] = { vim.lsp.buf.signature_help, desc('Signature Help') },
        ['<leader>lwa'] = {
            vim.lsp.buf.add_workspace_folder,
            desc('Add Workspace Folder'),
        },
        ['<leader>lwr'] = {
            vim.lsp.buf.remove_workspace_folder,
            desc('Remove Workspace Folder'),
        },
        ['<leader>lwl'] = {
            print_workspace_folders,
            desc('List Workspace Folders'),
        },
        ['<leader>lfT'] = { vim.lsp.buf.type_definition, desc('Type Definition') },
        ['<leader>lfR'] = { vim.lsp.buf.rename, desc('Rename...') },
        ['<leader>lfr'] = { vim.lsp.buf.references, desc('References') },
        ['<leader>lff'] = {
            function()
                vim.lsp.buf.format({ async = true })
            end,
            desc('Format File'),
        },
        ['<leader>lc'] = { vim.lsp.buf.code_action, desc('Code Action') },
        ['<leader>le'] = { vim.diagnostic.open_float, desc('Open Diagnostics Float') },
        ['<leader>lq'] = { vim.diagnostic.setloclist, desc('Set Loclist') },
    },
    v = {
        ['<leader>lc'] = { vim.lsp.buf.code_action, desc('LSP Code Action') },
    },
}

---@type AuRepeat
Autocmd.autocommands = {
    ['LspAttach'] = {
        {
            group = augroup('UserLsp', { clear = false }),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

                -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                if client:supports_method('textDocument/completion') then
                    -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                    local chars = {}
                    for i = 32, 126 do
                        table.insert(chars, string.char(i))
                    end
                    client.server_capabilities.completionProvider.triggerCharacters = chars
                end

                vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                vim.bo[args.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
                -- vim.bo[args.buf].omnifunc = nil
                -- vim.bo[args.buf].tagfunc = nil

                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })

                local AUKeys = Autocmd.AUKeys
                Keymaps(AUKeys)

                if client.name == 'lua_ls' then
                    require('plugin.lazydev')
                end

                ---@type AllMaps
                local Keys = {
                    ['<leader>lS'] = { group = '+Server', buffer = args.buf },

                    ['<leader>lSR'] = {
                        function()
                            local ClientCfg = vim.deepcopy(client.config)

                            vim.lsp.stop_client(client.id, true)
                            vim.lsp.start(ClientCfg, { bufnr = args.buf })
                        end,
                        desc('Force Server Restart', true, args.buf),
                        buffer = args.buf,
                    },
                    ['<leader>lSr'] = {
                        function()
                            local ClientCfg =
                                vim.tbl_deep_extend('keep', _G.CLIENTS[client.name], client.config)

                            vim.lsp.stop_client(client.id, false)
                            vim.lsp.start(ClientCfg, { bufnr = args.buf })
                        end,
                        desc('Server Restart', true, args.buf),
                        buffer = args.buf,
                    },
                    ['<leader>lSS'] = {
                        function()
                            local ClientCfg =
                                vim.tbl_deep_extend('keep', _G.CLIENTS[client.name], client.config)

                            vim.lsp.stop_client(client.id, true)
                            vim.lsp.start(ClientCfg, { bufnr = args.buf })
                        end,
                        desc('Force Server Stop', true, args.buf),
                        buffer = args.buf,
                    },
                    ['<leader>lSs'] = {
                        function()
                            vim.lsp.stop_client(client.id, false)
                        end,
                        desc('Server Stop', true, args.buf),
                        buffer = args.buf,
                    },
                    ['<leader>lSi'] = {
                        '<CMD>LspInfo<CR>',
                        desc('Show LSP Info', true, args.buf),
                        buffer = args.buf,
                    },
                }

                Keymaps({ n = Keys })
            end,
        },
    },
    ['LspProgress'] = {
        {
            group = augroup('UserLsp', { clear = false }),
            pattern = '*',
            callback = function()
                vim.cmd.redrawstatus()
            end,
        },
    },
}

---@param self Lsp.SubMods.Autocmd
---@param override? AuRepeat
function Autocmd:setup(override)
    override = is_tbl(override) and override or {}

    self.autocommands = vim.tbl_deep_extend('keep', override, vim.deepcopy(self.autocommands))

    au(self.autocommands)
end

---@param O? table
---@return table|Lsp.SubMods.Autocmd
function Autocmd.new(O)
    O = is_nil(O) and O or {}

    return setmetatable(O, { __index = Autocmd })
end

User:register_plugin('plugin.lsp.autocmd')

return Autocmd

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
