---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('which-key') then
    return
end

vim.opt.timeout = true
vim.opt.timeoutlen = 300

local WK = require('which-key')
local presets = require('which-key.plugin.presets')

WK.setup({
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = vim.opt.spell:get(), -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 0, -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = 'Comments' },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ['<space>'] = 'SPC',
        ['<cr>'] = 'RET',
        ['<tab>'] = 'TAB',
    },
    motions = { count = true },
    icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },
    window = {
        border = 'single', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 2, 4, 2, 4 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        padding = { 2, 1, 2, 1 }, -- extra window padding [top, right, bottom, left]
        winblend = 20, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000, -- positive value to position WhichKey above other floating windows.
    },
    layout = {
        height = { min = 4, max = math.floor(vim.opt.lines:get() / 3) }, -- min and max height of the columns
        width = { min = 25, max = math.floor(vim.opt.columns:get() * 3 / 4) }, -- min and max width of the columns
        spacing = 1, -- spacing between columns
        align = 'center', -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' }, -- hide mapping boilerplate
    show_help = true, -- show a help message in the command line for using WhichKey
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
    triggers = 'auto', -- automatically setup triggers
    -- triggers = {'<leader>'} -- or specifiy a list manually
    -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
    triggers_nowait = {
        -- marks
        '`',
        "'",
        'g`',
        'g"',
        -- registers
        '"',
        '<c-r>',
        -- -- spelling
        -- 'z=',
    },
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = { 'j', 'k', '<space>', '<leader>' },
        v = { 'j', 'k', 'v' },
        n = { 'j', 'k', 'v' },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by default for Telescope
    disable = {
        buftypes = {},
        filetypes = {},
    },
})

presets.operators['v'] = nil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
