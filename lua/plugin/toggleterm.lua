local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_int = Check.value.is_int
local desc = User.maps.desc
local tmap = User.maps.keymap.t

if not exists('toggleterm') then
    User.deregister_plugin('plugin.toggleterm')
    return
end

local floor = math.floor

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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

    open_mapping = [[<C-t>]],

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
    shell = vim.opt.shell:get(),
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
        name_formatter = function(term)
            return term.name
        end,
    },
})

---@param bufnr? integer
local function set_terminal_keymaps(bufnr)
    bufnr = is_int(bufnr) and bufnr or nil

    ---@type AllMaps
    local Keys = {
        ['<Esc>'] = {
            [[<C-\><C-n>]],
            desc('Escape Terminal', true, bufnr),
        },
        ['<C-e>'] = {
            [[<C-\><C-n>]],
            desc('Escape Terminal', true, bufnr),
        },
        ['<C-h>'] = {
            function()
                vim.cmd.wincmd('h')
            end,
            desc('Goto Left Window', true, bufnr),
        },
        ['<C-j>'] = {
            function()
                vim.cmd.wincmd('j')
            end,
            desc('Goto Down Window', true, bufnr),
        },
        ['<C-k>'] = {
            function()
                vim.cmd.wincmd('k')
            end,
            desc('Goto Up Window', true, bufnr),
        },
        ['<C-l>'] = {
            function()
                vim.cmd.wincmd('l')
            end,
            desc('Goto Right Window', true, bufnr),
        },
        ['<C-w>'] = {
            [[<C-\><C-n><C-w>w]],
            desc('Switch Window', true, bufnr),
        },
    }

    Keymaps({ t = Keys }, bufnr)
end

local cmd_str = '<CMD>exe v:count1 . "ToggleTerm"<CR>'

---@type AllModeMaps
local Keys = {
    n = {
        ['<leader>T'] = { group = '+Toggleterm' },

        ['<C-t>'] = {
            cmd_str,
            desc('Toggle Terminal'),
        },
        ['<leader>Tt'] = {
            cmd_str,
            desc('Toggle Terminal'),
        },
    },
    i = {
        ['<C-t>'] = {
            '<Esc>' .. cmd_str,
            desc('Toggle Terminal'),
        },
    },
    t = {
        ['<C-t>'] = {
            cmd_str,
            desc('Toggle Terminal'),
        },
    },
}

Keymaps(Keys)

local group = augroup('ToggleTerm.Hooks', { clear = true })

---@type AuDict
local aus = {
    ['TermEnter'] = {
        group = group,
        pattern = { 'term://*toggleterm#*' },
        callback = function()
            tmap('<c-t>', '<CMD>exe v:count1 . "ToggleTerm"<CR>')
        end,
    },
    ['TermOpen'] = {
        group = group,
        callback = function(args)
            set_terminal_keymaps(args.buf)
        end,
    },
}

for event, v in next, aus do
    au(event, v)
end

User.register_plugin('plugin.toggleterm')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
