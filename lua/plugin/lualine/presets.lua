---@module 'user_api.types.lualine'

local User = require('user_api')

local exists = User.check.exists.module

local floor = math.floor

User:register_plugin('plugin.lualine.presets')

---@type LuaLine.Presets
---@diagnostic disable-next-line:missing-fields
local Presets = {}

---@type LuaLine.ComponentsDict
---@diagnostic disable-next-line:missing-fields
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
    },

    symbols = {
        modified = ' ●', -- Text to show when the buffer is modified
        alternate_file = '#', -- Text to identify the alternate file
        directory = '', -- Text to show when the buffer is a directory
    },

    buffers_color = {
        active = 'lualine_a_normal',
        inactive = 'lualine_a_inactive',
    },

    max_length = floor(vim.opt.columns:get() / 4),
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

    tab_max_length = floor(vim.opt.columns:get() / 3),

    mode = 2,
    path = 1,
    tabs_color = {
        active = 'lualine_b_normal',
        inactive = 'lualine_b_inactive',
    },
}

Presets.components.windows = {
    'windows',

    max_length = floor(vim.opt.columns:get() / 5),

    disabled_buftypes = {
        'quickfix',
        'prompt',
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

    fmt = function(str) return str:sub(1, 1) end,
}

Presets.components.possession = exists('nvim-possession')
        and {
            require('nvim-possession').status,

            cond = function() return require('nvim-possession').status() ~= nil end,
        }
    or {}

Presets.default = {
    lualine_a = {
        -- Presets.components.datetime,
        Presets.components.mode,
    },
    lualine_b = {
        Presets.components.possession,
        -- Presets.components.branch,
        Presets.components.filename,
        -- Presets.components.filesize,
    },
    lualine_c = {
        -- Presets.components.diff,
        Presets.components.diagnostics,
    },
    lualine_x = {
        -- Presets.components.encoding,
        Presets.components.fileformat,
        Presets.components.filetype,
    },
    lualine_y = {
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
        Presets.components.filetype,
    },
    lualine_y = {},
    lualine_z = {
        Presets.components.location,
    },
}

return Presets

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
