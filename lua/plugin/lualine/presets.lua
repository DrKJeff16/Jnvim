local user = require('user_api')
local Check = user.check
local types = user.types.lualine

local floor = math.floor

---@type LuaLine.Presets
---@diagnostic disable-next-line:missing-fields
local M = {}

---@diagnostic disable-next-line:missing-fields
M.components = {}
M.components.buffers = {
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

M.components.diff = {
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

M.components.branch = { 'branch' }
M.components.encoding = { 'encoding' }
M.components.hostname = { 'hostname' }
M.components.location = { 'location' }
M.components.selectioncount = { 'selectioncount' }
M.components.filesize = { 'filesize' }

M.components.filename = {
    'filename',

    file_status = true,
    newfile_status = false,
    path = 4,
}

M.components.filetype = {
    'filetype',
    colored = true,
    icon_only = false,
    icon = { align = 'right' },
}

M.components.fileformat = {
    'fileformat',

    symbols = {
        unix = '', -- e712
        dos = '', -- e70f
        mac = '', -- e711
    },
}

M.components.searchcount = {
    'searchcount',
    maxcount = 999,
    timeout = 500,
}

M.components.tabs = {
    'tabs',

    tab_max_length = floor(vim.opt.columns:get() / 3),

    mode = 2,
    path = 1,
    tabs_color = {
        active = 'lualine_b_normal',
        inactive = 'lualine_b_inactive',
    },
}

M.components.windows = {
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

M.components.diagnostics = {
    'diagnostics',

    sources = {
        'nvim_workspace_diagnostic',
    },

    sections = { 'error', 'warn', 'info', 'hint' },

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

M.components.datetime = {
    'datetime',
    style = 'uk',
}

M.components.mode = {
    'mode',
    fmt = function(str) return str:sub(1, 1) end,
}

M.default = {
    lualine_a = {
        M.components.mode,
    },
    lualine_b = {
        M.components.branch,
        M.components.filename,
    },
    lualine_c = {
        M.components.diagnostics,
        M.components.diff,
    },
    lualine_x = {
        M.components.encoding,
        M.components.fileformat,
        M.components.filetype,
    },
    lualine_y = {
        M.components.progress,
    },
    lualine_z = {
        M.components.location,
    },
}

M.default_inactive = {
    lualine_a = {},
    lualine_b = {
        M.components.filename,
    },
    lualine_c = {},
    lualine_x = {
        M.components.filetype,
    },
    lualine_y = {},
    lualine_z = {
        M.components.location,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
