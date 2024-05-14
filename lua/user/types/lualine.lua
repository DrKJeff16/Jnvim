---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

-- Displays diagnostics for the defined severity types
---@alias DiagLvl 'error'|'warn'|'info'|'hint'
---@alias DiagLvls (DiagLvl)[]

---@alias TabLine.Comps.Diag.Spec table<DiagLvl, any>
---@alias TabLine.Comps.Diag.Src table<DiagLvl, any>
---@alias TabLine.Comps.Diag.Colors table<DiagLvl, any>
---@alias TabLine.Comps.Diag.Symbols table<DiagLvl, any>

---@alias Tabline.Comps.DateTime.style 'default'|'us'|'uk'|'iso'|string

--- Table of diagnostic sources, available sources are:
---   `'nvim_lsp'`, `'nvim_diagnostic'`, `'nvim_workspace_diagnostic'`, `'coc'`, `'ale'`, `'vim_lsp'`.
--- or a function that returns a table as such:
--- ```lua
--- {
---		error = error_count,
---		warn = warn_count,
---		info = info_count,
---		hint = hint_count
--- }
--- ```
---@alias DiagOpt ('nvim_lsp'|'nvim_diagnostic'|'nvim_workspace_diagnostic'|'coc'|'ale'|'vim_lsp')[]|fun(): TabLine.Comps.Diag.Src

---@class TabLine.Comps.Spec
---@field icons_enabled? boolean
---@field icon? any
---@field separator? table<string, string>|nil
---@field cond? any
---@field draw_empty? boolean
---@field color? table<string, string>|nil
---@field type? 'lua_expr'|'vim_fun'|nil
---@field on_click? nil|fun(...)

---@class TabLine.Comps.Buffer: TabLine.Comps.Spec
---@field show_filename_only? boolean
---@field hide_filename_extension? boolean
---@field show_modified_status? boolean

---@class TabLine.Comps.Buffer.Colors
---@field active? string
---@field inactive? string

---@class TabLine.Comps.Buffer.Symbols
---@field modified? string
---@field alternate_file? string
---@field directory? string

---@class TabLine.Comps.Diff.Colors
---@field added? string
---@field modified? string
---@field removed? string

---@class TabLine.Comps.Diff.Symbols: TabLine.Comps.Diff.Colors
---@class TabLine.Comps.Diff.Src: TabLine.Comps.Diff.Colors

---@class TabLine.Comps.FF.Symbols
---@field unix? string
---@field dos? string
---@field mac? string

---@class TabLine.Comps.DateTime: TabLine.Comps.Spec
---@class TabLine.Comps.Diag: TabLine.Comps.Spec
---@class TabLine.Comps.Diff: TabLine.Comps.Spec
---@class TabLine.Comps.File: TabLine.Comps.Spec
---@class TabLine.Comps.FT: TabLine.Comps.Spec

---@class TabLine.Comps.FF: TabLine.Comps.Spec
---@field symbols? TabLine.Comps.FF.Symbols

---@class TabLine.Comps.SC: TabLine.Comps.Spec
---@field maxcount? integer
---@field timeout? number

---@alias TabLine.AllComps
---|TabLine.Comps.Buffer
---|TabLine.Comps.DateTime
---|TabLine.Comps.Diag
---|TabLine.Comps.Diff
---|TabLine.Comps.FF
---|TabLine.Comps.FT
---|TabLine.Comps.File
---|TabLine.Comps.SC
---|TabLine.Comps.Spec
---|string
---|table

---@class TabLine.Sections.Spec
---@field lualine_a? table|(TabLine.AllComps)[]
---@field lualine_b? table|(TabLine.AllComps)[]
---@field lualine_c? table|(TabLine.AllComps)[]
---@field lualine_x? table|(TabLine.AllComps)[]
---@field lualine_y? table|(TabLine.AllComps)[]
---@field lualine_z? table|(TabLine.AllComps)[]

---@class TabLine.Sections
---@field active TabLine.Sections.Spec
---@field inactive TabLine.Sections.Spec

---@class TabLine.Comps
---@field basic? TabLine.Comps.Spec
---@field buffers? TabLine.Comps.Buffer
---@field datetime? TabLine.Comps.DateTime
---@field diagnostics? TabLine.Comps.Diag
---@field diff? TabLine.Comps.Diff
---@field fileformat? TabLine.Comps.FF
---@field filetype? TabLine.Comps.FT
---@field filename? TabLine.Comps.File
---@field searchcount? TabLine.Comps.SC

---@class TabLine.Preset
---@field default table

---@class TabLine
---@field public components TabLine.Comps
---@field public new fun(): TabLine
---@field protected __index? TabLine
---@field public __call fun(self: TabLine, preset?: string): TabLine.Preset
