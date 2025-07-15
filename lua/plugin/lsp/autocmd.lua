---@diagnostic disable:missing-fields

---@module 'plugin._types.lsp'

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check
local Au = User.util.au
local Notify = User.util.notify

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local desc = User.maps.kmap.desc
local au = Au.au_repeated
local notify = Notify.notify

local augroup = vim.api.nvim_create_augroup

local INFO = vim.log.levels.INFO

local function print_workspace_folders()
    local msg = ''

    for _, v in next, vim.lsp.buf.list_workspace_folders() do
        msg = string.format('%s\n - %s', msg, v)
    end

    notify(msg, INFO, {
        title = 'LSP',
        animate = true,
        hide_from_history = false,
        timeout = 5000,
    })
end

---@type Lsp.SubMods.Autocmd|fun(override: AuRepeat?)
local Autocmd = {}

---@type AllModeMaps
Autocmd.AUKeys = {
    n = {
        ['<leader>lf'] = { group = '+File Operations' },
        ['<leader>lw'] = { group = '+Workspace' },

        ['K'] = { vim.lsp.buf.hover, desc('Hover') },
        -- ['<leader>lK'] = { vim.lsp.buf.hover, desc('Hover') },

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
            group = augroup('UserLsp', { clear = true }),

            ---@param args vim.api.keyset.create_autocmd.callback_args
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if client == nil then
                    return
                end

                -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                if client:supports_method('textDocument/completion') then
                    -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                    local chars = {}
                    for i = 32, 126 do
                        table.insert(chars, string.char(i))
                    end
                    client.server_capabilities.completionProvider.triggerCharacters = chars
                end

                -- vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                -- vim.bo[args.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
                vim.bo[args.buf].omnifunc = nil
                vim.bo[args.buf].tagfunc = nil

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
                            _G.LAST_LSP = vim.deepcopy(client)

                            vim.lsp.stop_client(client.id, true)

                            vim.schedule(function()
                                vim.lsp.start(LAST_LSP.config, { bufnr = args.buf })
                            end)
                        end,
                        desc('Force Server Restart'),
                    },
                    ['<leader>lSr'] = {
                        function()
                            _G.LAST_LSP = vim.deepcopy(client)

                            vim.lsp.stop_client(client.id)

                            vim.schedule(function()
                                vim.lsp.start(LAST_LSP.config, { bufnr = args.buf })
                            end)
                        end,
                        desc('Server Restart'),
                    },
                    ['<leader>lSS'] = {
                        function()
                            _G.LAST_LSP = vim.deepcopy(client)

                            vim.lsp.stop_client(client.id, true)
                        end,
                        desc('Force Server Stop'),
                    },
                    ['<leader>lSs'] = {
                        function()
                            vim.lsp.stop_client(client.id)

                            ---@type vim.lsp.Client
                            _G.LAST_LSP = vim.deepcopy(client)
                        end,
                        desc('Server Stop'),
                    },
                    ['<leader>lSi'] = {
                        '<CMD>LspInfo<CR>',
                        desc('Show LSP Info'),
                    },
                }

                Keymaps({ n = Keys }, args.buf)
            end,
        },
    },
    ['LspProgress'] = {
        {
            group = augroup('UserLsp', { clear = false }),

            ---@param args vim.api.keyset.create_autocmd.callback_args
            ---@diagnostic disable-next-line:unused-local
            callback = function(args)
                vim.cmd.redrawstatus()
            end,
        },
    },
}

---@param O? table
---@return table|Lsp.SubMods.Autocmd|fun(override: AuRepeat?)
function Autocmd.new(O)
    O = is_nil(O) and O or {}

    return setmetatable(O, {
        __index = Autocmd,

        ---@param self Lsp.SubMods.Autocmd
        ---@param override? AuRepeat
        __call = function(self, override)
            override = is_tbl(override) and override or {}

            self.autocommands =
                vim.tbl_deep_extend('keep', override, vim.deepcopy(self.autocommands))

            au(self.autocommands)
        end,
    })
end

local A = Autocmd.new()

User:register_plugin('plugin.lsp.autocmd')

return A

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
