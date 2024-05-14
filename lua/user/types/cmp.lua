---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias CmpMap table<'i'|'s'|'t', fun(fallback: fun())>

---@alias TabMap CmpMap

---@alias CrMap CmpMap

---@class FmtKindIcons
---@field Class? string
---@field Color? string
---@field Constant? string
---@field Constructor? string
---@field Enum? string
---@field EnumMember? string
---@field Event? string
---@field Field? string
---@field File? string
---@field Folder? string
---@field Function? string
---@field Interface? string
---@field Keyword? string
---@field Method? string
---@field Module? string
---@field Operator? string
---@field Property? string
---@field Reference? string
---@field Snippet? string
---@field Struct? string
---@field Text? string
---@field TypeParameter? string
---@field Unit? string
---@field Value? string
---@field Variable? string

---@alias FmtOptsMenu table<'buffer'|'nvim_lsp'|'luasnip'|'nvim_lua'|'latex_symbols', string>

---@class CmpKindMod
---@field protected kind_icons FmtKindIcons
---@field protected kind_codicons FmtKindIcons
---@field formatting cmp.FormattingConfig
---@field window cmp.WindowConfig
---@field view cmp.ViewConfig
---@field vscode fun()

---@class MultiSources
---@field [1] string[]
---@field [2] cmp.ConfigSchema

---@alias SetupSources table<string, cmp.ConfigSchema>|MultiSources[]

---@class Sources
---@field new fun(): Sources
---@field __index? Sources
---@field setup fun(T: SetupSources?)
