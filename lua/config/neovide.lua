---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = require('user_api.check')

local executable = Check.exists.executable
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_num = Check.value.is_num
local is_bool = Check.value.is_bool
local num_range = Check.value.num_range

local INFO = vim.log.levels.INFO

-- Helper function for transparency formatting
---@return string
local function alpha()
    return string.format('%x', math.floor(255 * (vim.g.transparency or 1.0)))
end

---@class Config.Neovide
local Neovide = {}

Neovide.g_opts = {}

Neovide.active = false

---@class Config.Neovide.Opts
Neovide.default_opts = {
    ---@class Config.Neovide.Opts.G
    g = {
        theme = 'auto',

        refresh_rate = 60,
        refresh_rate_idle = 60,

        no_idle = true,

        ---@type boolean
        confirm_quit = vim.opt.confirm:get(),

        fullscreen = false,

        cursor = {
            hack = true,
            animation_length = 0.0,
            short_animation_length = 0.0,

            trail_size = 1.0,

            antialiasing = true,

            smooth = {
                blink = true,
            },

            animate = {
                in_insert_mode = true,
                command_line = true,
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
                length = 0.15,
            },
        },

        scroll = {
            animation = {
                length = 0.07,

                ---@type integer
                far_lines = vim.opt.scrolloff:get(),
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
            z_height = 50,

            corner_radius = 0.2,
        },

        light = {
            angle_degrees = 45,
            radius = 5,
        },
    },

    ---@class Config.Neovide.Opts.O
    o = {
        guifont = 'FiraCode Nerd Font Mono:h19',
    },

    ---@class Config.Neovide.Opts.Opt
    opt = {
        linespace = 0,
    },
}

---@return boolean
function Neovide:check()
    self.active = executable('neovide') and vim.g.neovide ~= nil

    return self.active
end

---@param opacity? number
---@param transparency? number
---@param bg? string
function Neovide:set_transparency(opacity, transparency, bg)
    if not (is_num(opacity) and num_range(opacity, 0.0, 1.0, { high = true, low = true })) then
        opacity = 0.85
    end
    if
        not (
            is_num(transparency) and num_range(transparency, 0.0, 1.0, { high = true, low = true })
        )
    then
        transparency = 1.0
    end

    if bg == nil or bg:len() ~= 7 then
        bg = '#0f1117'
    end

    if bg:sub(1, 1) == '#' then
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

function Neovide:setup_keys()
    if not self:check() then
        return
    end

    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps.kmap').desc
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
function Neovide:setup(T, transparent, verbose)
    if not self:check() then
        return
    end

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

    self:setup_keys()

    User:register_plugin('config.neovide')
end

return Neovide

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
