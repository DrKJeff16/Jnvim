---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@module 'user_api.types.user.maps'

local User = require('user_api')
local Keymaps = require('config.keymaps')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = User.maps.kmap.desc

if not exists('barbar') then
    return
end

User:register_plugin('plugin.barbar')

local Barbar = require('barbar')

vim.g.barbar_auto_setup = 0

local Opts = {
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = false,

    exclude_ft = {
        'TelescopePrompt',
        'lazy',
        'qf',
        'help',
        -- 'NvimTree',
    },

    focus_on_close = 'left',
    hide = { inactive = false, extensions = true, alternate = true },

    highlight_alternate = false,
    highlight_inactive_file_icons = false,
    highlight_visible = true,

    icons = {
        buffer_index = false,
        buffer_number = false,

        diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
            [vim.diagnostic.severity.WARN] = { enabled = true },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = false },
        },

        gitsigns = {
            added = { enabled = true, icon = '+' },
            changed = { enabled = true, icon = '~' },
            deleted = { enabled = true, icon = '-' },
        },

        filetype = {
            custom_colors = true,
            enabled = exists('nvim-web-devicons'),
        },

        separator = { left = '▎', right = '' },
        separator_at_end = true,

        modified = { button = '●' },
        pinned = { button = '', filename = true },

        ---@type 'default'|'powerline'|'slanted'
        preset = 'default',

        alternate = { filetype = { enabled = false } },
        current = { buffer_index = false },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = true } },
    },

    insert_at_end = false,
    insert_at_start = false,

    maximum_padding = 2,
    minimum_padding = 0,
    maximum_length = 28,
    minimum_length = 0,

    semantic_letters = true,

    sidebar_filetypes = {
        NvimTree = true,
    },

    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    no_name_title = nil,
}

Barbar.setup(Opts)

---@type AllModeMaps
local Keys = {
    n = {
        ['<leader>b'] = { group = '+Barbar Buffer' },
        ['<leader>bM'] = { group = '+Buffer Move' },

        ['<leader>bp'] = { '<CMD>BufferPrevious<CR>', desc('Previous Buffer') },
        ['<leader>bn'] = { '<CMD>BufferNext<CR>', desc('Next Buffer') },
        ['<leader>bl'] = { '<CMD>BufferLast<CR>', desc('Last Buffer') },
        ['<leader>bf'] = { '<CMD>BufferFirst<CR>', desc('First Buffer') },
        ['<leader>b1'] = { '<CMD>BufferGoto 1<CR>', desc('Goto Buffer 1') },
        ['<leader>b2'] = { '<CMD>BufferGoto 2<CR>', desc('Goto Buffer 2') },
        ['<leader>b3'] = { '<CMD>BufferGoto 3<CR>', desc('Goto Buffer 3') },
        ['<leader>b4'] = { '<CMD>BufferGoto 4<CR>', desc('Goto Buffer 4') },
        ['<leader>b5'] = { '<CMD>BufferGoto 5<CR>', desc('Goto Buffer 5') },
        ['<leader>b6'] = { '<CMD>BufferGoto 6<CR>', desc('Goto Buffer 6') },
        ['<leader>b7'] = { '<CMD>BufferGoto 7<CR>', desc('Goto Buffer 7') },
        ['<leader>b8'] = { '<CMD>BufferGoto 8<CR>', desc('Goto Buffer 8') },
        ['<leader>b9'] = { '<CMD>BufferGoto 9<CR>', desc('Goto Buffer 9') },
        ['<leader>bMp'] = { '<CMD>BufferMovePrevious<CR>', desc('Move Previous Buffer') },
        ['<leader>bMn'] = { '<CMD>BufferMoveNext<CR>', desc('Move Next Buffer') },
        ['<leader>bd'] = { '<CMD>BufferClose<CR>', desc('Close Buffer') },
        ['<leader>b<C-p>'] = { '<CMD>BufferPin<CR>', desc('Pin Buffer') },
        ['<leader>b<C-P>'] = { '<CMD>BufferPick<CR>', desc('Pick Buffer') },
        ['<leader>b<C-b>'] = {
            '<CMD>BufferOrderByBufferNumber<CR>',
            desc('Order Buffer By Number'),
        },
        ['<leader>b<C-d>'] = {
            '<CMD>BufferOrderByDirectory<CR>',
            desc('Order Buffer By Directory'),
        },
        ['<leader>b<C-l>'] = { '<CMD>BufferOrderByLanguage<CR>', desc('Order Buffer By Language') },
        ['<leader>b<C-n>'] = { '<CMD>BufferOrderByName<CR>', desc('Order Buffer By Name') },
        ['<leader>b<C-w>'] = {
            '<CMD>BufferOrderByWindowNumber<CR>',
            desc('Order Buffer By Window Number'),
        },
    },
    v = {
        ['<leader>b'] = { group = '+Barbar Buffer' },
        ['<leader>bM'] = { group = '+Buffer Move' },

        ['<leader>bp'] = { '<CMD>BufferPrevious<CR>', desc('Previous Buffer') },
        ['<leader>bn'] = { '<CMD>BufferNext<CR>', desc('Next Buffer') },
        ['<leader>bl'] = { '<CMD>BufferLast<CR>', desc('Last Buffer') },
        ['<leader>bf'] = { '<CMD>BufferFirst<CR>', desc('First Buffer') },
        ['<leader>b1'] = { '<CMD>BufferGoto 1<CR>', desc('Goto Buffer 1') },
        ['<leader>b2'] = { '<CMD>BufferGoto 2<CR>', desc('Goto Buffer 2') },
        ['<leader>b3'] = { '<CMD>BufferGoto 3<CR>', desc('Goto Buffer 3') },
        ['<leader>b4'] = { '<CMD>BufferGoto 4<CR>', desc('Goto Buffer 4') },
        ['<leader>b5'] = { '<CMD>BufferGoto 5<CR>', desc('Goto Buffer 5') },
        ['<leader>b6'] = { '<CMD>BufferGoto 6<CR>', desc('Goto Buffer 6') },
        ['<leader>b7'] = { '<CMD>BufferGoto 7<CR>', desc('Goto Buffer 7') },
        ['<leader>b8'] = { '<CMD>BufferGoto 8<CR>', desc('Goto Buffer 8') },
        ['<leader>b9'] = { '<CMD>BufferGoto 9<CR>', desc('Goto Buffer 9') },
        ['<leader>bMp'] = { '<CMD>BufferMovePrevious<CR>', desc('Move Previous Buffer') },
        ['<leader>bMn'] = { '<CMD>BufferMoveNext<CR>', desc('Move Next Buffer') },
        ['<leader>bd'] = { '<CMD>BufferClose<CR>', desc('Close Buffer') },
        ['<leader>b<C-p>'] = { '<CMD>BufferPin<CR>', desc('Pin Buffer') },
        ['<leader>b<C-P>'] = { '<CMD>BufferPick<CR>', desc('Pick Buffer') },
        ['<leader>b<C-b>'] = {
            '<CMD>BufferOrderByBufferNumber<CR>',
            desc('Order Buffer By Number'),
        },
        ['<leader>b<C-d>'] = {
            '<CMD>BufferOrderByDirectory<CR>',
            desc('Order Buffer By Directory'),
        },
        ['<leader>b<C-l>'] = { '<CMD>BufferOrderByLanguage<CR>', desc('Order Buffer By Language') },
        ['<leader>b<C-n>'] = { '<CMD>BufferOrderByName<CR>', desc('Order Buffer By Name') },
        ['<leader>b<C-w>'] = {
            '<CMD>BufferOrderByWindowNumber<CR>',
            desc('Order Buffer By Window Number'),
        },
    },
}

Keymaps:setup(Keys)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
