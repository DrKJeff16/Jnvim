---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local types = User.types.toggleterm
local Maps = User.maps
local WK = Maps.wk

local empty = Check.value.empty
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = Maps.map_dict

if not exists('toggleterm') then
    return
end

local floor = math.floor

local au = vim.api.nvim_create_autocmd

local TT = require('toggleterm')

local FACTOR = floor(vim.opt.columns:get() * 0.85)

local Opts = {
    ---@type fun(term: Terminal): integer
    size = function(term)
        if term.direction == 'vertical' then
            return floor(vim.opt.columns:get() * 0.65)
        end

        return FACTOR
    end,

    autochdir = true,
    hide_numbers = true,
    direction = 'float',
    close_on_exit = true,

    opts = {
        border = 'rounded',
        title_pos = 'center',
        width = FACTOR,
    },

    highlights = {
        Normal = { guibg = '#291d3f' },
        NormalFloat = { link = 'Normal' },
        FloatBorder = {
            guifg = '#c5c7a1',
            guibg = '#21443d',
        },
    },

    shade_terminals = true,

    start_in_insert = true,
    insert_mappings = true,
    shell = vim.opt.shell:get(),
    auto_scroll = true,

    persist_size = true,
    persist_mode = true,

    float_opts = {
        border = 'double',
        title_pos = 'center',
        zindex = 100,
        winblend = 3,
    },

    winbar = {
        enabled = true,

        ---@param term Terminal
        ---@return string
        name_formatter = function(term) return term.name end,
    },
}

TT.setup(Opts)

---@type AuDict
local aus = {
    ['TermEnter'] = {
        pattern = { 'term://*toggleterm#*' },
        callback = function() User.maps.kmap.t('<c-t>', '<CMD>exe v:count1 . "ToggleTerm"<CR>') end,
    },
}

for event, v in next, aus do
    au(event, v)
end

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<c-t>'] = {
            '<CMD>exe v:count1 . "ToggleTerm"<CR>',
            desc('Toggle'),
        },
        ['<leader>Tt'] = {
            '<CMD>exe v:count1 . "ToggleTerm"<CR>',
            desc('Toggle'),
        },
    },
    i = {
        ['<c-t>'] = {
            '<Esc><CMD>exe v:count1 . "ToggleTerm"<CR>',
            desc('Toggle'),
        },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = { ['<leader>T'] = { name = '+Toggleterm' } },
}

if WK.available() then
    map_dict(Names, 'wk.register', true)
end
map_dict(Keys, 'wk.register', true)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
