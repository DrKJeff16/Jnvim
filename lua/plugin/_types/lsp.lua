---@meta

error('(plugin._types.lsp): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

-- HACK: Call builtin annotations manually
---@module 'lua.vim.lsp'
---@module 'lua.vim.diagnostic'

---@module 'trouble'
---@module 'user_api.types.autocmd'
---@module 'user_api.types.highlight'

---@class EvBuf
---@field buf integer

---@class Lsp.SubMods.Kinds.Icons
---@field Class? string
---@field Color? string
---@field Constant? string
---@field Constructor? string
---@field Enum? string
---@field EnumMember? string
---@field Field? string
---@field File? string
---@field Folder? string
---@field Function? string
---@field Interface? string
---@field Keyword? string
---@field Method? string
---@field Module? string
---@field Property? string
---@field Snippet? string
---@field Struct? string
---@field Text? string
---@field Unit? string
---@field Value? string
---@field Variable? string

---@class Lsp.SubMods.Kinds
---@field icons Lsp.SubMods.Kinds.Icons
---@field setup fun(self: Lsp.SubMods.Kinds)
---@field new fun(O: table?): table|Lsp.SubMods.Kinds

---@class Lsp.SubMods.Trouble
---@field Opts trouble.Config
---@field Keys AllModeMaps
---@field setup fun(self: Lsp.SubMods.Trouble, O: table|trouble.Config?)
---@field new fun(O: table?): table|Lsp.SubMods.Trouble

---@class Lsp.SubMods.Autocmd
---@field AUKeys AllModeMaps
---@field autocommands AuRepeat
---@field setup fun(self: Lsp.SubMods.Autocmd, override: AuRepeat?)
---@field new fun(O: table?): table|Lsp.SubMods.Autocmd

---@alias Lsp.Server.Clients.Spec vim.lsp.ClientConfig

---@class Lsp.Server.Clients
---@field lua_ls? Lsp.Server.Clients.Spec
---@field bashls? Lsp.Server.Clients.Spec
---@field clangd? Lsp.Server.Clients.Spec
---@field cmake? Lsp.Server.Clients.Spec
---@field css_variables? Lsp.Server.Clients.Spec
---@field cssls? Lsp.Server.Clients.Spec
---@field html? Lsp.Server.Clients.Spec
---@field jdtls? Lsp.Server.Clients.Spec
---@field jsonls? Lsp.Server.Clients.Spec
---@field julials? Lsp.Server.Clients.Spec
---@field marksman? Lsp.Server.Clients.Spec
---@field pylsp? Lsp.Server.Clients.Spec
---@field taplo? Lsp.Server.Clients.Spec
---@field texlab? Lsp.Server.Clients.Spec
---@field vimls? Lsp.Server.Clients.Spec
---@field yamlls? Lsp.Server.Clients.Spec

---@alias Lsp.Server.Key
---|'lua_ls'
---|'bashls'
---|'clangd'
---|'cmake'
---|'css_variables'
---|'cssls'
---|'html'
---|'jdtls'
---|'jsonls'
---|'julials'
---|'marksman'
---|'pylsp'
---|'taplo'
---|'texlab'
---|'vimls'
---|'yamlls'
---|string

---@class Lsp.Server
---@field Clients table<Lsp.Server.Key, vim.lsp.ClientConfig>
---@field client_names (string|Lsp.Server.Key)[]|table
---@field make_capabilities fun(T: table|lsp.ClientCapabilities?): lsp.ClientCapabilities|table
---@field populate fun(name: string, client: table|vim.lsp.ClientConfig): (client: table|vim.lsp.ClientConfig)
---@field new fun(O: table?): table|Lsp.Server|fun()

---@class Lsp.SubMods
---@field neodev fun()|nil
---@field trouble? fun()|nil
---@field clangd? fun()|nil
---@field kinds Lsp.SubMods.Kinds

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
