---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.gitsigns
local Maps = User.maps
local kmap = Maps.kmap
local WK = Maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local is_num = Check.value.is_num
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local desc = kmap.desc
local map_dict = Maps.map_dict

if not executable('git') or not exists('gitsigns') then
    return
end

local GS = require('gitsigns')

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        -- Navigation
        ['<leader>G]c'] = {
            "&diff ? ']c' : '<CMD>Gitsigns next_hunk<CR>'",
            desc('Next Hunk', true, 0, true, true, true),
        },
        ['<leader>G[c'] = {
            "&diff ? '[c' : '<CMD>Gitsigns prev_hunk<CR>'",
            desc('Previous Hunk', true, 0, true, true, true),
        },

        -- Actions
        ['<leader>Ghs'] = { '<CMD>Gitsigns stage_hunk<CR>', desc('Stage Current Hunk', true, 0) },
        ['<leader>Ghr'] = { '<CMD>Gitsigns reset_hunk<CR>', desc('Reset Current Hunk', true, 0) },
        ['<leader>Ghu'] = { '<CMD>Gitsigns undo_stage_hunk<CR>', desc('Undo Hunk Stage', true, 0) },
        ['<leader>Ghp'] = { '<CMD>Gitsigns preview_hunk<CR>', desc('Preview Current Hunk', true, 0) },
        ['<leader>GhS'] = { '<CMD>Gitsigns stage_buffer<CR>', desc('Stage The Whole Buffer', true, 0) },
        ['<leader>GhR'] = { '<CMD>Gitsigns reset_buffer<CR>', desc('Reset The Whole Buffer', true, 0) },
        ['<leader>Ghb'] = {
            function()
                GS.blame_line({ full = true })
            end,
            desc('Blame Current Line', true, 0),
        },
        ['<leader>Ghd'] = { '<CMD>Gitsigns diffthis<CR>', desc('Diff Against Index', true, 0) },
        ['<leader>GhD'] = {
            function()
                GS.diffthis('~')
            end,
            desc('Diff This', true, 0),
        },
        ['<leader>Gtb'] = { '<CMD>Gitsigns toggle_current_line_blame<CR>', desc('Toggle Line Blame', true, 0) },
        ['<leader>Gtd'] = { '<CMD>Gitsigns toggle_deleted<CR>', desc('Toggle Deleted', true, 0) },
    },
    v = {
        ['<leader>Ghs'] = { ':Gitsigns stage_hunk<CR>', desc('Stage Selected Hunks', true, 0) },
        ['<leader>Ghr'] = { ':Gitsigns reset_hunk<CR>', desc('Reset Selected Hunks', true, 0) },
    },
}
---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>G'] = { name = '+Gitsigns' },
        ['<leader>Gh'] = { name = '+Hunks' },
        ['<leader>Gt'] = { name = '+Toggles' },
        ['<leader>G['] = { name = '+Previous Hunk' },
        ['<leader>G]'] = { name = '+Next Hunk' },
    },
    v = {
        ['<leader>G'] = { name = '+Gitsigns' },
        ['<leader>Gh'] = { name = '+Hunks' },
    },
}

GS.setup({
    ---@type fun(bufnr: integer)
    on_attach = function(bufnr)
        bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

        if WK.available() then
            map_dict(Names, 'wk.register', true, nil, bufnr)
        end

        map_dict(Keys, 'wk.register', true, nil, bufnr)
    end,

    ---@type GitSigns
    signs = {
        add = { text = '÷' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = 'X' },
        changedelete = { text = '≈' },
        untracked = { text = '┆' },
    },

    signcolumn = vim.opt.signcolumn:get() == 'yes', -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = false,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 2000,
        ignore_whitespace = false,
        virt_text_priority = 10,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 10,
    update_debounce = 100,
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
})
