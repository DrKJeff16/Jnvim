---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local map_t = User.types.user.maps
local map = User.maps.map
local WK = User.maps.wk

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = map.desc

if not exists('barbar') then
    return
end

local Bar = require('barbar')

vim.g.barbar_auto_setup = 0

Bar.setup({
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

    focus_on_close = 'previous',
    hide = { inactive = false, extensions = false },

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
            custom_colors = false,
            enabled = true,
        },

        separator = { left = '▎', right = '' },
        separator_at_end = true,

        modified = { button = '●' },
        pinned = { button = '', filename = true },

        ---@type 'default'|'powerline'|'slanted'
        preset = 'slanted',

        alternate = { filetype = { enabled = true } },
        current = { buffer_index = false },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
    },

    insert_at_end = false,
    insert_at_start = false,

    maximum_padding = 4,
    minimum_padding = 0,
    maximum_length = 32,
    minimum_length = 0,

    semantic_letters = true,

    sidebar_filetypes = {},

    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    no_name_title = nil,
})

---@type table<MapModes, ApiMapDict>
local Keys = {
    n = {
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
        ['<leader>b<C-b>'] = { '<CMD>BufferOrderByBufferNumber<CR>', desc('Order Buffer By Number') },
        ['<leader>b<C-d>'] = { '<CMD>BufferOrderByDirectory<CR>', desc('Order Buffer By Directory') },
        ['<leader>b<C-l>'] = { '<CMD>BufferOrderByLanguage<CR>', desc('Order Buffer By Language') },
        ['<leader>b<C-n>'] = { '<CMD>BufferOrderByName<CR>', desc('Order Buffer By Name') },
        ['<leader>b<C-w>'] = { '<CMD>BufferOrderByWindowNumber<CR>', desc('Order Buffer By Window Number') },
    },
    v = {
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
        ['<leader>b<C-b>'] = { '<CMD>BufferOrderByBufferNumber<CR>', desc('Order Buffer By Number') },
        ['<leader>b<C-d>'] = { '<CMD>BufferOrderByDirectory<CR>', desc('Order Buffer By Directory') },
        ['<leader>b<C-l>'] = { '<CMD>BufferOrderByLanguage<CR>', desc('Order Buffer By Language') },
        ['<leader>b<C-n>'] = { '<CMD>BufferOrderByName<CR>', desc('Order Buffer By Name') },
        ['<leader>b<C-w>'] = { '<CMD>BufferOrderByWindowNumber<CR>', desc('Order Buffer By Window Number') },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>B'] = { name = '+Barbar Buffer' },
        ['<leader>BM'] = { name = '+Buffer Move' },
    },
    v = {
        ['<leader>B'] = { name = '+Barbar Buffer' },
        ['<leader>BM'] = { name = '+Buffer Move' },
    },
}

for mode, t in next, Keys do
    if WK.available() then
        if is_tbl(Names[mode]) and not empty(Names[mode]) then
            WK.register(Names[mode], { mode = mode })
        end

        WK.register(WK.convert_dict(t), { mode = mode })
    else
        for lhs, v in next, t do
            v[2] = is_tbl(v[2]) and v[2] or {}
            map[mode](lhs, v[1], v[2])
        end
    end
end
