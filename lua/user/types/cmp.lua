---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias CmpModes ('i'|'s'|'t')

---@alias CmpMap table<CmpModes, fun(fallback: fun())>
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

---@class SourceTypeOpts
---@field keyword_pattern? string
---@field keyword_length? integer
---@field indexing_interval? number
---@field indexing_branch_size? number
---@field max_indexed_line_length? number

---@class SourceType
---@field name string
---@field option? SourceTypeOpts
---@field priority? integer

---@class SourceAPathOpts: SourceTypeOpts
---@field trailing_slash? boolean
---@field label_trailing_slash? boolean
---@field get_cwd? fun(): string
---@field show_hidden_files_by_default? boolean

---@class SourceBufOpts: SourceTypeOpts
---@field get_bufnrs? fun(): table

---@class SourceAPath: SourceType
---@field option? SourceAPathOpts

---@class SourceBuf: SourceType
---@field option? SourceBufOpts

---@class MultiSources
---@field [1] string[]
---@field [2] cmp.ConfigSchema

---@alias SetupSources table<string, cmp.ConfigSchema>|MultiSources[]

---@class Sources
---@field new fun(): Sources
---@field __index? Sources
---@field setup fun(T: SetupSources?)
---@field buffer fun(priority: integer?): SourceBuf
---@field async_path? fun(priority: integer?): SourceAPath

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
