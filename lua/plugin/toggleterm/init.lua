local User = require('user_api')
local Check = User.check
local types = User.types.toggleterm
local WK = User.maps.wk

local empty = Check.value.empty
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('toggleterm') then
    return
end

User.register_plugin('plugin.toggleterm')

local floor = math.floor

local au = vim.api.nvim_create_autocmd

local TT = require('toggleterm')

local FACTOR = floor(vim.opt.columns:get() * 0.85)

TT.setup({
    ---@param term Terminal
    ---@return integer
    size = function(term)
        if term.direction == 'vertical' then
            return floor(vim.opt.columns:get() * 0.65)
        end

        return FACTOR
    end,

    open_mapping = [[<c-t>]],

    autochdir = true,
    hide_numbers = true,

    ---@type 'float'|'tab'|'horizontal'|'vertical'
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

    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = -30,
    shading_ratio = -3,

    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    shell = vim.o.shell,
    auto_scroll = true,

    persist_size = true,
    persist_mode = true,

    float_opts = {
        border = 'curved',
        ---@type 'left'|'center'|'right'
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
})

function _G.set_terminal_keymaps()
    ---@type KeyMapDict
    local K = {
        ['<esc>'] = {
            [[<C-\><C-n>]],
            desc('Escape Terminal', true, 0),
        },
        ['<C-h>'] = {
            function() vim.cmd.wincmd('h') end,
            desc('Goto Left Window', true, 0),
        },
        ['<C-j>'] = {
            function() vim.cmd.wincmd('j') end,
            desc('Goto Down Window', true, 0),
        },
        ['<C-k>'] = {
            function() vim.cmd.wincmd('k') end,
            desc('Goto Up Window', true, 0),
        },
        ['<C-l>'] = {
            function() vim.cmd.wincmd('l') end,
            desc('Goto Right Window', true, 0),
        },
        ['<C-w>'] = {
            [[<C-\><C-n><C-w>]],
            { buffer = 0, silent = true, noremap = true, nowait = false },
        },
    }

    require('user_api.maps').map_dict(K, 'wk.register', false, 't', 0)
end

local cmd_str = '<CMD>exe v:count1 . "ToggleTerm"<CR>'

---@type KeyMapModeDict
local Keys = {
    n = {
        ['<c-t>'] = {
            cmd_str,
            desc('Toggle', true, 0),
        },
        ['<leader>Tt'] = {
            cmd_str,
            desc('Toggle', true, 0),
        },
    },
    i = {
        ['<c-t>'] = {
            '<Esc>' .. cmd_str,
            desc('Toggle', true, 0),
        },
    },
}

---@type ModeRegKeysNamed
local Names = {
    n = { ['<leader>T'] = { group = '+Toggleterm' } },
}

if WK.available() then
    map_dict(Names, 'wk.register', true)
end
map_dict(Keys, 'wk.register', true)

---@type AuDict
local aus = {
    ['TermEnter'] = {
        pattern = { 'term://*toggleterm#*' },
        callback = function() User.maps.kmap.t('<c-t>', '<CMD>exe v:count1 . "ToggleTerm"<CR>') end,
    },
    ['TermOpen'] = {
        callback = function() set_terminal_keymaps() end,
    },
}

for event, v in next, aus do
    au(event, v)
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
