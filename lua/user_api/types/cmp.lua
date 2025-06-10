---@meta

---@module 'cmp'

---@alias CmpModes ('i'|'s'|'c')

---@class CmpMap
---@field c fun(fallback: fun())
---@field i fun(fallback: fun())
---@field s fun(fallback: fun())

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

---@alias FmtOptsMenu table<string, string>

---@class CmpKindMod
---@field kind_icons FmtKindIcons
---@field kind_codicons FmtKindIcons
---@field formatting cmp.FormattingConfig
---@field window cmp.WindowConfig
---@field view cmp.ViewConfig
---@field vscode fun()
---@field hilite fun()

---@class SourceTypeOpts
---@field keyword_pattern? string
---@field keyword_length? integer
---@field indexing_interval? number
---@field indexing_branch_size? number
---@field max_indexed_line_length? number

---@class SourceType
---@field name string
---@field option? SourceTypeOpts
---@field group_index? integer

---@class LspKeywordPatterns
---@field keyword_pattern? string

---@alias SourceLspOpts table|table<string, LspKeywordPatterns>

---@class SourcePathOpts
---@field trailing_slash? boolean
---@field label_trailing_slash? boolean
---@field get_cwd? fun(): string

---@class SourceAsyncPathOpts: SourcePathOpts
---@field show_hidden_files_by_default? boolean

---@class SourceBufOpts: SourceTypeOpts
---@field get_bufnrs? fun(): integer[]

---@class SourceAsyncPath: SourceType
---@field option? SourceAsyncPathOpts

---@class SourceBuf: SourceType
---@field option? SourceBufOpts

---@class SourceLsp: SourceType
---@field option? SourceLspOpts

---@class MultiSources
---@field [1] string[]
---@field [2] cmp.ConfigSchema

---@class CmpUtil
---@field feedkey fun(key: string, mode: MapModes|'')
---@field has_words_before fun(): boolean
---@field confirm fun(opts: cmp.ConfirmationConfig?): fun(fallback: fun())
---@field bs_map fun(fallback: fun())
---@field n_select fun(fallback: fun())
---@field n_shift_select fun(fallback: fun())
---@field tab_map CmpMap
---@field s_tab_map CmpMap
---@field cr_map CmpMap

---@alias SetupSources MultiSources[]|table<string, cmp.ConfigSchema>

---@class Sources
---@field setup fun(T: SetupSources?)
---@field buffer fun(group_index: integer?, all_bufs: boolean?): SourceBuf
---@field async_path fun(group_index: integer?): SourceAsyncPath
---@field Sources table<string, (cmp.SourceConfig|SourceBuf|SourceAsyncPath)[]>
---@field ft SetupSources
---@field cmdline SetupSources

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
