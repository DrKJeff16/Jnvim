---@diagnostic disable:missing-fields

---@module 'user_api.types.lspconfig'
---@module 'user_api.types.user.check'
---@module 'user_api.types.user.maps'
---@module 'user_api.types.user.util'

local User = require('user_api')
local Keymaps = require('config.keymaps')

local Check = User.check
local Au = User.util.au
local Notify = User.util.notify

local is_tbl = Check.value.is_tbl
local desc = User.maps.kmap.desc
local au = Au.au_repeated
local notify = Notify.notify

local augroup = vim.api.nvim_create_augroup

User:register_plugin('plugin.lsp.autocmd')

local function print_workspace_folders()
    local msg = ''

    for _, v in next, vim.lsp.buf.list_workspace_folders() do
        msg = msg .. '\n - ' .. v
    end

    notify(msg, vim.log.levels.INFO)
end

---@type Lsp.SubMods.Autocmd
local Autocmd = {}

---@type AllModeMaps
Autocmd.AUKeys = {
    n = {
        ['<leader>lc'] = { group = '+Code Actions' },
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
            function() vim.lsp.buf.format({ async = true }) end,
            desc('Format File'),
        },
        ['<leader>lca'] = { vim.lsp.buf.code_action, desc('Code Actions') },
        ['<leader>le'] = { vim.diagnostic.open_float, desc('Open Diagnostics Float') },
        ['<leader>lq'] = { vim.diagnostic.setloclist, desc('Set Loclist') },
    },
    v = {
        ['<leader>lc'] = { group = '+Code Actions' },

        ['<leader>lca'] = { vim.lsp.buf.code_action, desc('Code Action') },
    },
}

---@type AuRepeat
Autocmd.autocommands = {
    ['LspAttach'] = {
        {
            group = augroup('UserLsp', {}),
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

                -- vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                -- vim.bo[args.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
                vim.bo[args.buf].omnifunc = nil
                vim.bo[args.buf].tagfunc = nil

                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })

                Keymaps:setup(Autocmd.AUKeys)

                if client.name == 'lua_ls' then
                    require('plugin.lazydev')
                end
            end,
        },
    },
    ['LspProgress'] = {
        {
            group = augroup('UserLsp', {}),
            pattern = '*',
            callback = function() vim.cmd('redrawstatus') end,
        },
    },
}

---@param self Lsp.SubMods.Autocmd
---@param T? AuRepeat
function Autocmd:setup(T)
    T = is_tbl(T) and T or {}
    au(self.autocommands)
end

---@param O? table
---@return table|Lsp.SubMods.Autocmd
function Autocmd.new(O)
    O = is_nil(O) and O or {}
    return setmetatable(O, { __index = Autocmd })
end

return Autocmd

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
