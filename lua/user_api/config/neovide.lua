local validate = vim.validate

local executable = require('user_api.check.exists').executable
local is_tbl = require('user_api.check.value').is_tbl
local num_range = require('user_api.check.value').num_range

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

---Helper function for transparency formatting.
--- ---
---@return string
local function alpha()
    return string.format('%x', math.floor(255 * (vim.g.transparency or 1.0)))
end

---@param ev vim.api.keyset.create_autocmd.callback_args
local function set_ime(ev)
    vim.g.neovide_input_ime = ev.event:match('Enter$') ~= nil
end

---@class Config.Neovide.Opts.G
local g_opts = {
    theme = 'auto',

    refresh_rate = 60,
    refresh_rate_idle = 30,

    no_idle = true,

    ---@type boolean
    confirm_quit = vim.o.confirm,

    fullscreen = false,

    profiler = false,

    cursor = {
        hack = false,
        animation_length = 0.05,
        short_animation_length = 0.03,

        trail_size = 1.0,

        antialiasing = false,

        smooth = {
            blink = true,
        },

        animate = {
            in_insert_mode = false,
            command_line = false,
        },
    },

    underline = {
        stroke_scale = 1.0,
    },

    experimental = {
        layer_grouping = false,
    },

    text = {
        contrast = 0.5,
        gamma = 0.0,
    },

    scale_factor = 1.0,

    show_border = true,

    hide_mouse_when_typing = false,

    position = {
        animation = {
            length = 0.1,
        },
    },

    scroll = {
        animation = {
            length = 0.07,
            far_lines = 0,
        },
    },

    remember = {
        window_size = true,
    },

    padding = {
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
    },

    floating = {
        blur_amount_x = 2.0,
        blur_amount_y = 2.0,

        shadow = true,
        z_height = 50,

        corner_radius = 0.5,
    },

    light = {
        angle_degrees = 45,
        radius = 5,
    },
}

---@class Config.Neovide.Opts.O
local o_opts = {
    linespace = 0,
    guifont = 'FiraCode Nerd Font Mono:h19',
}

---@class Config.Neovide.Opts
---@field g Config.Neovide.Opts.G
---@field o Config.Neovide.Opts.O

---@class User.Config.Neovide
local Neovide = {}

---@type table<string, any>
Neovide.g_opts = {}

Neovide.active = false

---@return Config.Neovide.Opts
function Neovide.get_defaults()
    return {
        g = g_opts,
        o = o_opts,
    }
end

---@return boolean
function Neovide.check()
    Neovide.active = executable('neovide') and vim.g.neovide

    return Neovide.active
end

---@param opacity? number
---@param transparency? number
---@param bg? string
function Neovide.set_transparency(opacity, transparency, bg)
    validate('opacity', opacity, 'number', true)
    validate('transparency', transparency, 'number', true)
    validate('bg', bg, 'string', true)

    local eq = { high = true, low = true }

    if opacity ~= nil and not num_range(opacity, 0.0, 1.0, eq) then
        opacity = 0.85
    end
    if transparency ~= nil and not num_range(transparency, 0.0, 1.0, eq) then
        transparency = 1.0
    end

    if bg == nil or bg:len() ~= 7 then
        bg = '#0f1117'
    end

    if bg:sub(1, 1) == '#' then
        local len = string.len(bg)

        bg = ((len ~= 7 and len ~= 9) and '#0f1117' or bg) .. alpha()
    end

    Neovide.g_opts.neovide_opacity = opacity
    Neovide.g_opts.transparency = transparency
    Neovide.g_opts.neovide_background_color = bg
end

---@param O any[]
---@param pfx string
function Neovide.parse_g_opts(O, pfx)
    validate('O', O, 'table', false, 'any[]')
    validate('pfx', pfx, 'string', false)

    pfx = (pfx ~= nil and pfx:sub(1, 8) == 'neovide_') and pfx or 'neovide_'

    for k, v in ipairs(O) do
        local key = pfx .. k

        if is_tbl(v) then
            Neovide.parse_g_opts(v, key .. '_')
        else
            Neovide.g_opts[key] = v
        end
    end
end

function Neovide.setup_maps()
    if not Neovide.check() then
        return
    end

    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps').desc
    local notify = require('user_api.util.notify').notify

    ---@type AllMaps
    local Keys = {
        ['<leader><CR>'] = { group = '+Neovide' },

        ['<leader><CR>V'] = {
            function()
                notify(string.format('Neovide v%s', vim.g.neovide_version), INFO, {
                    title = 'Neovide',
                    animate = true,
                    timeout = 1500,
                    hide_from_history = false,
                })
            end,
            desc('Show Neovide Version'),
        },
    }

    Keymaps({ n = Keys })
end

---@param T? table
---@param transparent? boolean
---@param verbose? boolean
function Neovide.setup(T, transparent, verbose)
    validate('T', T, 'table', true)
    validate('transparent', transparent, 'boolean', true)
    validate('verbose', verbose, 'boolean', true)

    if not (Neovide.check() or Neovide.active) then
        return
    end

    T = T or {}
    transparent = transparent ~= nil and transparent or false
    verbose = verbose ~= nil and verbose or false

    local Defaults = Neovide.get_defaults()

    for o, v in pairs(Defaults.o) do
        vim.o[o] = v
    end

    Neovide.g_opts = {}

    T = vim.tbl_deep_extend('keep', T, Defaults.g)
    Neovide.parse_g_opts(T, 'neovide_')

    if transparent then
        Neovide.set_transparency()
    end

    local ime_input = augroup('ime_input', { clear = true })

    au({ 'InsertEnter', 'InsertLeave' }, {
        group = ime_input,
        pattern = '*',
        callback = set_ime,
    })

    au({ 'CmdlineEnter', 'CmdlineLeave' }, {
        group = ime_input,
        pattern = '[/\\?]',
        callback = set_ime,
    })

    for k, v in pairs(Neovide.g_opts) do
        vim.g[k] = v
    end

    if verbose then
        vim.notify((inspect or vim.inspect)(Neovide.g_opts), INFO)
    end

    Neovide.setup_maps()
end

return setmetatable({}, {
    __index = Neovide,

    __newindex = function(_, _, _)
        error('User.Config.Neovide table is Read-Only!', ERROR)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
