---@meta

---@module 'user_api.types.user.autocmd'
---@module 'user_api.types.user.highlight'
---@module 'trouble'

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
---@field lua_ls? Lsp.Server.Clients.Spec|nil
---@field bashls? Lsp.Server.Clients.Spec|nil
---@field clangd? Lsp.Server.Clients.Spec|nil
---@field cmake? Lsp.Server.Clients.Spec|nil
---@field css_variables? Lsp.Server.Clients.Spec|nil
---@field cssls? Lsp.Server.Clients.Spec|nil
---@field html? Lsp.Server.Clients.Spec|nil
---@field jdtls? Lsp.Server.Clients.Spec|nil
---@field jsonls? Lsp.Server.Clients.Spec|nil
---@field julials? Lsp.Server.Clients.Spec|nil
---@field marksman? Lsp.Server.Clients.Spec|nil
---@field pylsp? Lsp.Server.Clients.Spec|nil
---@field taplo? Lsp.Server.Clients.Spec|nil
---@field texlab? Lsp.Server.Clients.Spec|nil
---@field vimls? Lsp.Server.Clients.Spec|nil
---@field yamlls? Lsp.Server.Clients.Spec|nil

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
---@field Clients Lsp.Server.Clients
---@field make_capabilities fun(): lsp.ClientCapabilities
---@field populate fun(self: Lsp.Server)
---@field new fun(O: table?): table|Lsp.Server

---@class Lsp.SubMods
---@field neodev fun()|nil
---@field trouble? fun()|nil
---@field clangd? fun()|nil
---@field kinds Lsp.SubMods.Kinds

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
