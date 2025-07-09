---@diagnostic disable:missing-fields

---@class Config.Neovide.Opts.O
---@field guifont? string

---@class Config.Neovide.Opts.Opt
---@field linespace? integer

---@class Config.Neovide.Opts
---@field o? Config.Neovide.Opts.O
---@field opt? Config.Neovide.Opts.Opt
---@field g? table

---@class Config.Neovide

local User = require('user_api')
local Check = User.check

local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_num = Check.value.is_num
local is_bool = Check.value.is_bool

local INFO = vim.log.levels.INFO

-- Helper function for transparency formatting
---@return string
local function alpha()
    return string.format('%x', math.floor(255 * (vim.g.transparency or 1.0)))
end

local Neovide = {}

---@type table<string, any>
Neovide.g_opts = {}

Neovide.active = false

---@type Config.Neovide.Opts
Neovide.default_opts = {}

Neovide.default_opts.g = {
    theme = 'auto',

    refresh_rate = 60,
    refresh_rate_idle = 30,

    no_idle = true,

    confirm_quit = vim.o.confirm,

    fullscreen = false,

    cursor = {
        hack = true,
        animation_length = 0.03,
        short_animation_length = 0.01,

        trail_size = 1.0,

        antialiasing = true,

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

    show_border = false,

    hide_mouse_when_typing = false,

    position = {
        animation = {
            length = 0.03,
        },
    },

    scroll = {
        animation = {
            length = 0.03,
            far_lines = vim.o.scrolloff,
        },
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
        z_height = 10,

        corner_radius = 0.4,
    },

    light = {
        angle_degrees = 45,
        radius = 5,
    },
}

---@type Config.Neovide.Opts.O
Neovide.default_opts.o = {
    guifont = 'FiraCode Nerd Font Mono:h19',
}

---@type Config.Neovide.Opts.Opt
Neovide.default_opts.opt = {
    linespace = 0,
}

---@param opacity? number
---@param transparency? number
---@param bg? string
function Neovide:set_transparency(opacity, transparency, bg)
    if not (is_num(opacity) and opacity >= 0.0 and opacity <= 1.0) then
        opacity = 0.85
    end
    if not (is_num(transparency) and transparency >= 0.0 and transparency <= 1.0) then
        transparency = 1.0
    end

    if not is_str(bg) then
        bg = '#0f1117'
    end

    if bg:sub(1, 1) == '#' then ---@diagnostic disable-line:need-check-nil
        local len = string.len(bg)

        if len ~= 7 and len ~= 9 then
            bg = '#0f1117' .. alpha()
        elseif len == 7 then
            bg = bg .. alpha()
        end
    end

    self.g_opts.neovide_opacity = opacity
    self.g_opts.transparency = transparency
    self.g_opts.neovide_background_color = bg
end

---@param O any
---@param pfx string
function Neovide:parse_g_opts(O, pfx)
    pfx = (is_str(pfx) and pfx:sub(1, 8) == 'neovide_') and pfx or 'neovide_'

    for k, v in next, O do
        local key = pfx .. k
        if is_tbl(v) then
            self:parse_g_opts(v, key .. '_')
        else
            self.g_opts[key] = v
        end
    end
end

function Neovide:check()
    if vim.g.neovide then
        self.active = true
    end
end

---@param T? table
---@param transparent? boolean
---@param verbose? boolean
function Neovide:setup(T, transparent, verbose)
    self:check()

    if not self.active then
        return
    end

    T = is_tbl(T) and T or {}
    transparent = is_bool(transparent) and transparent or false
    verbose = is_bool(verbose) and verbose or false

    for o, v in next, self.default_opts.opt do
        vim.opt[o] = v
    end

    for o, v in next, self.default_opts.o do
        vim.o[o] = v
    end

    ---@type table<string, any>
    self.g_opts = {}

    T = vim.tbl_deep_extend('keep', T, self.default_opts.g)
    self:parse_g_opts(T, 'neovide_')

    if transparent then
        self:set_transparency()
    end

    for k, v in next, self.g_opts do
        vim.g[k] = v
    end

    if verbose then
        vim.notify((inspect or vim.inspect)(self.g_opts), INFO)
    end

    User:register_plugin('config.neovide')
end

return Neovide

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
