---@module 'lazy'

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
---@field fmt? nil|fun(str: string, context?: any)
---@field on_click? nil|fun(clicks?: integer, button: string, mods: any)

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

---@alias LuaLineSection (LuaLine.Components|SectionComponentStr|fun())[]|table

---@class LuaLine.Sections
---@field lualine_a LuaLineSection
---@field lualine_b LuaLineSection
---@field lualine_c LuaLineSection
---@field lualine_x LuaLineSection
---@field lualine_y LuaLineSection
---@field lualine_z LuaLineSection

local User = require('user_api')
local Check = User.check
local Termux = User.distro.termux

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local type_not_empty = Check.value.type_not_empty

local in_list = vim.list_contains

---@type LazySpec
return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    version = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        { 'arkav/lualine-lsp-progress', version = false },
    },
    cond = not in_console(),
    config = function()
        local Lualine = require('lualine')
        local floor = math.floor

        ---@class LuaLine.Presets
        local Presets = {}

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
        Presets.components = {}

        Presets.components.buffers = {
            'buffers',

            filetype_names = {
                TelescopePrompt = 'Telescope',
                dashboard = 'Dashboard',
                packer = 'Packer',
                lazy = 'Lazy',
                fzf = 'FZF',
                alpha = 'Alpha',
                NvimTree = 'Nvim Tree',
                qf = 'Quickfix',
            },

            symbols = {
                modified = ' ●', -- Text to show when the buffer is modified
                alternate_file = '#', -- Text to identify the alternate file
                directory = '', -- Text to show when the buffer is a directory
            },

            buffers_color = {
                active = 'lualine_c_normal',
                inactive = 'lualine_c_inactive',
            },

            max_length = floor(vim.o.columns / 4),
        }

        Presets.components.diff = {
            'diff',
            colored = true,
            diff_color = {
                added = 'LuaLineDiffAdd',
                modified = 'LuaLineDiffChange',
                removed = 'LuaLineDiffDelete',
            },

            symbols = {
                added = '+',
                modified = '~',
                removed = '-',
            },
        }

        Presets.components.branch = { 'branch' }
        Presets.components.encoding = { 'encoding' }
        Presets.components.hostname = { 'hostname' }
        Presets.components.location = { 'location' }
        Presets.components.selectioncount = { 'selectioncount' }
        Presets.components.filesize = { 'filesize' }

        Presets.components.filename = {
            'filename',

            file_status = true,
            newfile_status = true,
            path = 4,
        }

        Presets.components.filetype = {
            'filetype',

            colored = false,
            icon_only = false,
            icon = { align = 'right' },
        }

        Presets.components.fileformat = {
            'fileformat',

            symbols = {
                unix = '', -- e712
                dos = '', -- e70f
                mac = '', -- e711
            },
        }

        Presets.components.searchcount = {
            'searchcount',

            maxcount = 999,
            timeout = 500,
        }

        Presets.components.tabs = {
            'tabs',

            tab_max_length = floor(vim.o.columns / 3),

            mode = 2,
            path = 1,
            tabs_color = {
                active = 'lualine_b_normal',
                inactive = 'lualine_b_inactive',
            },
        }

        Presets.components.windows = {
            'windows',

            max_length = floor(vim.o.columns / 5),

            disabled_buftypes = {
                'help',
                'prompt',
                'quickfix',
                'terminal',
            },

            windows_color = {
                active = 'lualine_z_normal',
                inactive = 'lualine_z_inactive',
            },
        }

        Presets.components.diagnostics = {
            'diagnostics',

            sources = {
                'nvim_workspace_diagnostic',
            },

            sections = { 'error', 'warn' },

            diagnostics_color = {
                error = 'DiagnosticError',
                warn = 'DiagnosticWarn',
                info = 'DiagnosticInfo',
                hint = 'DiagnosticHint',
            },

            symbols = {
                error = '󰅚 ',
                hint = '󰌶 ',
                info = ' ',
                warn = '󰀪 ',
            },

            colored = true,
            update_in_insert = false,
            always_visible = true,
        }

        Presets.components.datetime = {
            'datetime',

            style = 'uk',
        }

        Presets.components.mode = {
            'mode',

            fmt = function(str)
                return str:sub(1, 1)
            end,
        }

        if exists('nvim-possession') then
            Presets.components.possession = {
                require('nvim-possession').status,

                cond = function()
                    return require('nvim-possession').status() ~= nil
                end,
            }
        end

        if exists('lualine.components.lsp_progress') then
            -- Color for highlights
            local colors = {
                red = '#ec5f67',
                green = '#98be65',
                blue = '#51afef',
                yellow = '#ECBE7B',
                cyan = '#008080',
                magenta = '#c678dd',
                violet = '#a9a1e1',
                orange = '#FF8800',
                darkblue = '#081633',
            }

            ---@type LuaLine.Components.Spec
            Presets.components.lsp_progress = {
                'lsp_progress',
                -- display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' } },
                -- With spinner
                colors = {
                    percentage = colors.cyan,
                    title = colors.cyan,
                    message = colors.cyan,
                    spinner = colors.cyan,
                    lsp_client_name = colors.magenta,
                    use = true,
                },
                separators = {
                    component = ' ',
                    progress = ' | ',
                    message = { pre = '(', post = ')' },
                    percentage = { pre = '', post = '%% ' },
                    title = { pre = '', post = ': ' },
                    lsp_client_name = { pre = '[', post = ']' },
                    spinner = { pre = '', post = '' },
                    -- message = { commenced = 'In Progress', completed = 'Completed' },
                },
                display_components = {
                    'lsp_client_name',
                    'spinner',
                    { 'title', 'percentage', 'message' },
                },
                timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
                spinner_symbols = {
                    '🌑 ',
                    '🌒 ',
                    '🌓 ',
                    '🌔 ',
                    '🌕 ',
                    '🌖 ',
                    '🌗 ',
                    '🌘 ',
                },
            }
        end

        Presets.components.noice = {
            hl_get = {},
            command_get = {},
            mode_get = {},
            search_get = {},
        }

        local NoiceAPI = require('noice.api')

        ---@diagnostic disable
        Presets.components.noice = {
            hl_get = {
                NoiceAPI.status.message.get_hl,
                cond = NoiceAPI.status.message.has,
            },
            command_get = {
                NoiceAPI.status.command.get,
                cond = NoiceAPI.status.command.has,
                color = { fg = '#ff9e64' },
            },
            mode_get = {
                NoiceAPI.status.mode.get,
                cond = NoiceAPI.status.mode.has,
                color = { fg = '#ff9e64' },
            },
            search_get = {
                NoiceAPI.status.search.get,
                cond = NoiceAPI.status.search.has,
                color = { fg = '#ff9e64' },
            },
        }

        ---@diagnostic enable

        Presets.default = {
            lualine_a = {
                -- Presets.components.noice.mode_get,
                -- Presets.components.noice.command_get,
                -- Presets.components.noice.search_get,
                -- Presets.components.datetime,
                Presets.components.mode,
            },
            lualine_b = User.distro.termux.validate()
                    and {
                        -- Presets.components.branch,
                        -- Presets.components.possession,
                        Presets.components.filename,
                        -- Presets.components.filesize,
                    }
                or {
                    Presets.components.branch,
                    -- Presets.components.possession,
                    Presets.components.filename,
                    -- Presets.components.filesize,
                },
            lualine_c = User.distro.termux.validate()
                    and {
                        Presets.components.diagnostics,
                        -- Presets.components.diff,
                    }
                or {
                    Presets.components.diagnostics,
                    Presets.components.diff,
                },
            lualine_x = {
                -- Presets.components.encoding,
                Presets.components.lsp_progress,
                Presets.components.fileformat,
                Presets.components.filetype,
            },
            lualine_y = {
                Presets.components.noice.search_get,
                Presets.components.progress,
            },
            lualine_z = {
                Presets.components.location,
            },
        }

        Presets.default_inactive = {
            lualine_a = {},
            lualine_b = {
                Presets.components.filename,
            },
            lualine_c = {},
            lualine_x = {
                Presets.components.noice.command_get,
                Presets.components.filetype,
            },
            lualine_y = {},
            lualine_z = {
                Presets.components.location,
            },
        }

        ---@param theme? ''|'auto'|string
        ---@param force_auto? boolean
        ---@return string
        local function theme_select(theme, force_auto)
            theme = type_not_empty('string', theme) and theme or 'auto'
            force_auto = is_bool(force_auto) and force_auto or false

            -- If `auto` theme and permitted to select from fallbacks.
            -- Keep in mind these fallbacks are the same strings as their `require()` module strings
            if in_list({ 'auto', '' }, theme) or force_auto then
                return 'auto'
            end

            local themes = {
                'tokyonight',
                'catppuccin',
                'nightfox',
                'onedark',
            }
            if not in_list(themes, theme) then
                return 'auto'
            end

            for _, t in next, themes do
                if t == theme and exists(theme) then
                    return theme
                end
            end

            return 'auto'
        end

        local Opts = {
            options = {
                icons_enabled = true,
                theme = theme_select('catppuccin', true),
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                ignore_focus = {},
                always_divide_middle = Termux.validate(),
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = Presets.default,
            inactive_sections = Presets.default_inactive,
            inactive_tabline = {},
            inactive_winbar = {},

            extensions = {
                'lazy',
                'fugitive',
                'man',
            },
        }

        if exists('nvim-tree') and not in_list(Opts.extensions, 'nvim-tree') then
            table.insert(Opts.extensions, 'nvim-tree')
        end
        if exists('toggleterm') and not in_list(Opts.extensions, 'toggleterm') then
            table.insert(Opts.extensions, 'toggleterm')
        end

        Lualine.setup(Opts)
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
