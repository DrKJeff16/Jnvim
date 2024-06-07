---@alias SectionComponentStr
---|'mode'
---|'filetype'
---|'encoding'
---|'fileformat'
---|'filename'
---|'branch'
---|'diff'
---|'diagnostics'
---|'datetime'
---|'progress'
---|'location'
---|'buffers'
---|'filesize'
---|'hostname'
---|'searchcount'
---|'selectioncount'
---|'tabs'
---|'windows'
---|string

---@class SectionSeparator
---@field left string
---@field right string

---@class LuaLine.Components.Spec
---@field [1] SectionComponentStr
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

---@class LuaLine.Components.Buffers: LuaLine.Components.Spec
---@field [1] 'buffers'
---@field show_filename_only? boolean
---@field hide_filename_extension? boolean
---@field show_modified_status? boolean
---@field mode? 0|1|2|3|4
---@field max_length? number
---@field filetype_names? table<string, string>
---@field use_mode_colors? boolean
---@field buffers_color? table<'active'|'inactive', string>
---@field symbols? table<'modified'|'alternate_file'|'directory', string>

---@class LuaLine.Components.DateTime: LuaLine.Components.Spec
---@field [1] 'datetime'
---@field style? 'default'|'us'|'uk'|'iso'|string

---@class LuaLine.Components.Diagnostics: LuaLine.Components.Spec
---@field [1] 'diagnostics'
---@field sources?
---|('nvim_lsp'|'nvim_diagnostic'|'nvim_workspace_diagnostic'|'coc'|'ale'|'vim_lsp')[]
---|fun(...): table<'error'|'warn'|'info'|'hint', integer>
---@field sections? ('error'|'warn'|'info'|'hint')[]
---@field diagnostics_color? table<'error'|'warn'|'info'|'hint', string>
---@field symbols? table<'error'|'warn'|'info'|'hint', string>
---@field colored? boolean
---@field update_in_insert? boolean
---@field always_visible? boolean

---@class LuaLine.Components.Diff: LuaLine.Components.Spec
---@field [1] 'diff'
---@field colored? boolean
---@field diff_color? table<'added'|'modified'|'removed', string>
---@field symbols? table<'added'|'modified'|'removed', string>
---@field source?
---|fun(...): (nil|table<'added'|'modified'|'removed', integer>)
---|integer

---@class LuaLine.Components.Fileformat: LuaLine.Components.Spec
---@field [1] 'fileformat'
---@field symbols? table<'unix'|'dos'|'mac', string>

---@class LuaLine.Components.Filename: LuaLine.Components.Spec
---@field [1] 'filename'
---@field file_status? boolean
---@field newfile_status? boolean
---@field path? 0|1|2|3|4
---@field shorting_target? integer
---@field symbols? table<'modified'|'readonly'|'unnamed'|'newfile', string>

---@class LuaLine.Components.Filetype: LuaLine.Components.Spec
---@field [1] 'filetype'
---@field colored? boolean
---@field icon_only? boolean
---@field icon?
---|{ ['align']: string }
---|{ [1]: string, ['align']: string }

---@class LuaLine.Components.Searchcount: LuaLine.Components.Spec
---@field [1] 'searchcount'
---@field maxcount? integer
---@field timeout? integer

---@class LuaLine.Components.Tabs: LuaLine.Components.Spec
---@field [1] 'tabs'
---@field tab_max_length? integer
---@field max_length? number
---@field mode? 0|1|2
---@field path? 0|1|2|3
---@field use_mode_colors? boolean
---@field tabs_color? table<'active'|'inactive', string>
---@field show_modified_status? boolean
---@field symbols? { ['modified']: string }
---@field fmt? fun(name: string, context: table): string

---@class LuaLine.Components.Windows: LuaLine.Components.Spec
---@field show_filename_only? boolean
---@field show_modified_status? boolean
---@field mode? 0|1|2
---@field max_length? number
---@field filetype_names? table<string, string>
---@field diabled_buftypes? string[]
---@field use_mode_colors? boolean
---@field windows_color? table<'active'|'inactive', string>

---@class LuaLine.Components.Filesize: LuaLine.Components.Spec
---@field [1] 'filesize'

---@class LuaLine.Components.Branch: LuaLine.Components.Spec
---@field [1] 'branch'

---@class LuaLine.Components.Encoding: LuaLine.Components.Spec
---@field [1] 'encoding'

---@class LuaLine.Components.Hostname: LuaLine.Components.Spec
---@field [1] 'hostname'

---@class LuaLine.Components.Mode: LuaLine.Components.Spec
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
---@field locatios LuaLine.Components.Location
---@field mode LuaLine.Components.Mode
---@field progress LuaLine.Components.Progress
---@field searchcount LuaLine.Components.Searchcount
---@field selectioncount LuaLine.Components.Selectioncount
---@field tabs LuaLine.Components.Tabs
---@field windows LuaLine.Components.Windows

---@class LuaLine.Sections
---@field lualine_a (table|LuaLine.Components|SectionComponentStr|fun())[]
---@field lualine_b (table|LuaLine.Components|SectionComponentStr|fun())[]
---@field lualine_c (table|LuaLine.Components|SectionComponentStr|fun())[]
---@field lualine_x (table|LuaLine.Components|SectionComponentStr|fun())[]
---@field lualine_y (table|LuaLine.Components|SectionComponentStr|fun())[]
---@field lualine_z (table|LuaLine.Components|SectionComponentStr|fun())[]

---@class LuaLine.Presets
---@field default LuaLine.Sections
---@field components LuaLine.ComponentsDict
