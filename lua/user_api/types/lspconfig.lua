---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user_api.types.user.autocmd')
require('user_api.types.user.highlight')

---@class EvBuf
---@field buf integer

---@class LspKindsIconsMod
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

---@class LspKindsMod
---@field icons LspKindsIconsMod
---@field setup fun()

---@class LspServerOpts
---@field capabilities? table
---@field cmd? string|string[]
---@field cmd_env? table<string, any>|nil
---@field filetypes? string|string[]
---@field handlers? table<string, fun(...): any>
---@field init_options? table<string, any>
---@field name? string
---@field log_level? number|nil
---@field on_attach? fun(client: vim.lsp.Client): any
---@field on_new_config? any
---@field onset_encoding? any
---@field root_dir? any
---@field settings? table
---@field single_file_support? boolean

---@class LspServers
---@field lua_ls? LspServerOpts|nil
---@field bashls? LspServerOpts|nil
---@field clangd? LspServerOpts|nil
---@field cmake? LspServerOpts|nil
---@field html? LspServerOpts|nil
---@field jdtls? LspServerOpts|nil
---@field jsonls? LspServerOpts|nil
---@field marksman? LspServerOpts|nil
---@field pylsp? LspServerOpts|nil
---@field taplo? LspServerOpts|nil
---@field texlab? LspServerOpts|nil
---@field yamlls? LspServerOpts|nil
---@field new fun(): LspServers

---@class LspSubs
---@field neoconf fun()|nil
---@field neodev fun()|nil
---@field trouble? fun()|nil
---@field clangd? fun()|nil
---@field kinds LspKindsMod

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
