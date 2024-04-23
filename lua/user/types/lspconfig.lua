---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

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

---@class LspSubMods
---@field clangd? fun(): any
---@field kinds? LspKindsMod

---@class LspServerOpts
---@field capabilities? table
---@field cmd? string|string[]
---@field cmd_env? table<string, any>|nil
---@field filetypes? string|string[]
---@field handlers? table<string, fun(...): any>
---@field init_options? table<string, any>
---@field name? string
---@field log_level? number|nil
---@field on_attach? fun(client: table?): any
---@field on_new_config? any
---@field onset_encoding? any
---@field root_dir? any
---@field settings? table
---@field single_file_support? boolean

---@alias LspServers table<string, LspServerOpts>

---@class LspSubs
---@field neoconf? fun()
---@field neodev? fun()
---@field trouble? fun()
---@field clangd? fun()
---@field kinds LspKindsMod
