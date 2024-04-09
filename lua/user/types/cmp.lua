---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class CmpMap
---@field i? fun(fallback: fun())
---@field s? fun(fallback: fun())
---@field c? fun(fallback: fun())

---@class TabMap: CmpMap

---@class CrMap: CmpMap

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

---@class FmtOptsMenu
---@field buffer? string
---@field nvim_lsp? string
---@field luasnip? string
---@field nvim_lua? string
---@field latex_symbols? string

---@class CmpKindMod
---@field protected kind_icons FmtKindIcons
---@field protected kind_codicons FmtKindIcons
---@field formatting cmp.FormattingConfig
---@field window cmp.WindowConfig
---@field view cmp.ViewConfig
---@field vscode fun()

