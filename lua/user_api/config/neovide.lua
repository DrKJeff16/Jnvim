local executable = require('user_api.check.exists').executable
local is_str = require('user_api.check.value').is_str
local is_tbl = require('user_api.check.value').is_tbl
local is_num = require('user_api.check.value').is_num
local is_bool = require('user_api.check.value').is_bool
local num_range = require('user_api.check.value').num_range

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local INFO = vim.log.levels.INFO

-- Helper function for transparency formatting
---@return string
local function alpha()
    return string.format('%x', math.floor(255 * (vim.g.transparency or 1.0)))
end

---@class Config.Neovide.Opts.G
local g_opts = {
    theme = 'auto',

    refresh_rate = 60,
    refresh_rate_idle = 30,

    no_idle = true,

    ---@type boolean
    confirm_quit = vim.opt.confirm:get(),

    fullscreen = false,

    profiler = false,

    cursor = {
        hack = false,
        animation_length = 0.1,
        short_animation_length = 0.05,

        trail_size = 1.0,

        antialiasing = false,

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
    guifont = 'FiraCode Nerd Font Mono:h19',
}

---@class Config.Neovide.Opts.Opt
local opt_opts = {
    linespace = 0,
}

---@class Config.Neovide.Opts
---@field g Config.Neovide.Opts.G
---@field opt Config.Neovide.Opts.Opt
---@field o Config.Neovide.Opts.O

---@class User.Config.Neovide
local Neovide = {}

Neovide.g_opts = {}

Neovide.active = false

---@return Config.Neovide.Opts
function Neovide.get_defaults()
    return {
        g = g_opts,
        opt = opt_opts,
        o = o_opts,
    }
end

---@return boolean
function Neovide.check()
    Neovide.active = executable('neovide') and vim.g.neovide ~= nil

    return Neovide.active
end

---@param opacity? number
---@param transparency? number
---@param bg? string
function Neovide.set_transparency(opacity, transparency, bg)
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

    Neovide.g_opts.neovide_opacity = opacity
    Neovide.g_opts.transparency = transparency
    Neovide.g_opts.neovide_background_color = bg
end

---@param O any
---@param pfx string
function Neovide.parse_g_opts(O, pfx)
    pfx = (is_str(pfx) and pfx:sub(1, 8) == 'neovide_') and pfx or 'neovide_'

    for k, v in next, O do
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
function Neovide.setup(T, transparent, verbose)
    if not Neovide.check() then
        return
    end

    if not Neovide.active then
        return
    end

    T = is_tbl(T) and T or {}
    transparent = is_bool(transparent) and transparent or false
    verbose = is_bool(verbose) and verbose or false

    local Defaults = Neovide.get_defaults()

    for o, v in next, Defaults.opt do
        vim.opt[o] = v
    end

    for o, v in next, Defaults.o do
        vim.o[o] = v
    end

    ---@type table<string, any>
    Neovide.g_opts = {}

    T = vim.tbl_deep_extend('keep', T, Defaults.g)
    Neovide.parse_g_opts(T, 'neovide_')

    if transparent then
        Neovide.set_transparency()
    end

    local function set_ime(args)
        if args.event:match('Enter$') then
            vim.g.neovide_input_ime = true
        else
            vim.g.neovide_input_ime = false
        end
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

    for k, v in next, Neovide.g_opts do
        vim.g[k] = v
    end

    if verbose then
        vim.notify((inspect or vim.inspect)(Neovide.g_opts), INFO)
    end

    Neovide.setup_maps()
end

return Neovide

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
