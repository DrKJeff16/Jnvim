---@meta

---@alias SectionComponentStr
---|'branch'
---|'buffers'
---|'datetime'
---|'diagnostics'
---|'diff'
---|'encoding'
---|'fileformat'
---|'filename'
---|'filesize'
---|'filetype'
---|'hostname'
---|'location'
---|'mode'
---|'progress'
---|'searchcount'
---|'selectioncount'
---|'tabs'
---|'windows'
---|string

---@class SectionSeparator
---@field left string
---@field right string

---@class LuaLine.Components.Spec
---@field icons_enabled? boolean
---@field icon? string|nil
---@field separator? nil|string|SectionSeparator
---@field cond? nil|fun()
---@field draw_empty? boolean
---@field color? nil|vim.api.keyset.highlight|string
---@field type? any
---@field padding? integer
---@field fmt? nil|fun(str: string, context: any?)
---@field on_click? nil|fun(clicks: integer?, button: string, mods: any)

---@class ComponentsColor
---@field active
---|'lualine_a_normal'
---|'lualine_b_normal'
---|'lualine_c_normal'
---|'lualine_x_normal'
---|'lualine_y_normal'
---|'lualine_z_normal'
---@field inactive
---|'lualine_a_inactive'
---|'lualine_b_inactive'
---|'lualine_c_inactive'
---|'lualine_x_inactive'
---|'lualine_y_inactive'
---|'lualine_z_inactive'

---@class BuffersSymbols
---@field modified string
---@field alternate_file string
---@field directory string

---@class LuaLine.Components.Buffers: LuaLine.Components.Spec
---@field [1] 'buffers'
---@field show_filename_only? boolean
---@field hide_filename_extension? boolean
---@field show_modified_status? boolean
---@field mode? 0|1|2|3|4
---@field max_length? number
---@field filetype_names? table<string, string>
---@field use_mode_colors? boolean
---@field buffers_color? ComponentsColor
---@field symbols? BuffersSymbols

---@class LuaLine.Components.DateTime: LuaLine.Components.Spec
---@field [1] 'datetime'
---@field style? 'default'|'us'|'uk'|'iso'|string

---@class DiagnosticsInteger
---@field error? string|integer
---@field warn? string|integer
---@field info? string|integer
---@field hint? string|integer

---@class DiagnosticsColor: DiagnosticsInteger
---@field error? string|integer
---@field warn? string|integer
---@field info? string|integer
---@field hint? string|integer

---@class DiagnosticsSections
---@field [1]? 'error'
---@field [2]? 'warn'
---@field [3]? 'info'
---@field [4]? 'hint'

---@class LuaLine.Components.Diagnostics: LuaLine.Components.Spec
---@field [1] 'diagnostics'
---@field sources?
---|('nvim_lsp'|'nvim_diagnostic'|'nvim_workspace_diagnostic'|'coc'|'ale'|'vim_lsp')[]
---|fun(...): DiagnosticsInteger
---@field sections? ('error'|'warn'|'info'|'hint')[]|DiagnosticsSections
---@field diagnostics_color? DiagnosticsColor
---@field symbols? DiagnosticsColor
---@field colored? boolean
---@field update_in_insert? boolean
---@field always_visible? boolean

---@class DiffColor
---@field added string
---@field modified string
---@field removed string

---@class DiffSource: DiffColor
---@field added integer
---@field modified integer
---@field removed integer

---@class LuaLine.Components.Diff: LuaLine.Components.Spec
---@field [1] 'diff'
---@field colored? boolean
---@field diff_color? DiffColor
---@field symbols? DiffColor
---@field source?
---|fun(...): (nil|DiffSource)
---|integer

---@class FileFormatSymbols
---@field unix string
---@field dos string
---@field mac string

---@class LuaLine.Components.Fileformat: LuaLine.Components.Spec
---@field [1] 'fileformat'
---@field symbols? FileFormatSymbols

---@class FileNameSymbols
---@field modified string
---@field readonly string
---@field unnamed string
---@field newfile string

---@class LuaLine.Components.Filename: LuaLine.Components.Spec
---@field [1] 'filename'
---@field file_status? boolean
---@field newfile_status? boolean
---@field path? 0|1|2|3|4
---@field shorting_target? integer
---@field symbols? FileNameSymbols

---@class FileTypeIcon
---@field [1]? string
---@field align string

---@class LuaLine.Components.Filetype: LuaLine.Components.Spec
---@field [1] 'filetype'
---@field colored? boolean
---@field icon_only? boolean
---@field icon? FileTypeIcon

---@class LuaLine.Components.Searchcount: LuaLine.Components.Spec
---@field [1] 'searchcount'
---@field maxcount? integer
---@field timeout? integer

---@class TabsSymbols
---@field modified string

---@class LuaLine.Components.Tabs: LuaLine.Components.Spec
---@field [1] 'tabs'
---@field tab_max_length? integer
---@field max_length? number
---@field mode? 0|1|2
---@field path? 0|1|2|3
---@field use_mode_colors? boolean
---@field tabs_color? ComponentsColor
---@field show_modified_status? boolean
---@field symbols? TabsSymbols
---@field fmt? fun(name: string, context: table?): string

---@class LuaLine.Components.Windows: LuaLine.Components.Spec
---@field show_filename_only? boolean
---@field show_modified_status? boolean
---@field mode? 0|1|2
---@field max_length? number
---@field filetype_names? table<string, string>
---@field diabled_buftypes? string[]
---@field use_mode_colors? boolean
---@field windows_color? ComponentsColor

---@class LuaLine.Components.Filesize: LuaLine.Components.Spec
---@field [1] 'filesize'

---@class LuaLine.Components.Branch: LuaLine.Components.Spec
---@field [1] 'branch'

---@class LuaLine.Components.Encoding: LuaLine.Components.Spec
---@field [1] 'encoding'

---@class LuaLine.Components.Hostname: LuaLine.Components.Spec
---@field [1] 'hostname'

---@class LuaLine.Components.Mode
---@field [1] 'mode'
---@field fmt? fun(str: string): string

---@class LuaLine.Components.Progress: LuaLine.Components.Spec
---@field [1] 'progress'

---@class LuaLine.Components.Location: LuaLine.Components.Spec
---@field [1] 'location'

---@class LuaLine.Components.Selectioncount: LuaLine.Components.Spec
---@field [1] 'selectioncount'

---@alias LuaLine.Components
---|LuaLine.Components.Branch
---|LuaLine.Components.Buffers
---|LuaLine.Components.DateTime
---|LuaLine.Components.Diagnostics
---|LuaLine.Components.Diff
---|LuaLine.Components.Encoding
---|LuaLine.Components.Fileformat
---|LuaLine.Components.Filename
---|LuaLine.Components.Filesize
---|LuaLine.Components.Filetype
---|LuaLine.Components.Hostname
---|LuaLine.Components.Location
---|LuaLine.Components.Mode
---|LuaLine.Components.Progress
---|LuaLine.Components.Searchcount
---|LuaLine.Components.Selectioncount
---|LuaLine.Components.Spec
---|LuaLine.Components.Tabs
---|LuaLine.Components.Windows

---@class LuaLine.ComponentsDict
---@field branch LuaLine.Components.Branch
---@field buffers LuaLine.Components.Buffers
---@field datetime LuaLine.Components.DateTime
---@field diagnostics LuaLine.Components.Diagnostics
---@field diff LuaLine.Components.Diff
---@field encoding LuaLine.Components.Encoding
---@field fileformat LuaLine.Components.Fileformat
---@field filename LuaLine.Components.Filename
---@field filesize LuaLine.Components.Filesize
---@field filetype LuaLine.Components.Filetype
---@field hostname LuaLine.Components.Hostname
---@field location LuaLine.Components.Location
---@field mode LuaLine.Components.Mode
---@field progress LuaLine.Components.Progress
---@field searchcount LuaLine.Components.Searchcount
---@field selectioncount LuaLine.Components.Selectioncount
---@field tabs LuaLine.Components.Tabs
---@field windows LuaLine.Components.Windows

---@class LuaLine.Sections
---@field lualine_a (LuaLine.Components|SectionComponentStr|fun())[]|table
---@field lualine_b (LuaLine.Components|SectionComponentStr|fun())[]|table
---@field lualine_c (LuaLine.Components|SectionComponentStr|fun())[]|table
---@field lualine_x (LuaLine.Components|SectionComponentStr|fun())[]|table
---@field lualine_y (LuaLine.Components|SectionComponentStr|fun())[]|table
---@field lualine_z (LuaLine.Components|SectionComponentStr|fun())[]|table

---@class LuaLine.Presets
---@field components LuaLine.ComponentsDict
---@field default LuaLine.Sections
---@field default_inactive LuaLine.Sections

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
