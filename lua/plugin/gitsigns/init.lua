---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
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

GS.setup({
    ---@param bufnr integer
    on_attach = function(bufnr)
        bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

        ---@type table<MapModes, KeyMapDict>
        local Keys = {
            n = {
                -- Navigation
                ['<leader>Gh]'] = {
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            GS.nav_hunk('next')
                        end
                    end,
                    desc('Next Hunk', true, 0, true, true, true),
                },
                ['<leader>Gh['] = {
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            GS.nav_hunk('prev')
                        end
                    end,
                    desc('Previous Hunk', true, 0, true, true, true),
                },

                -- Actions
                ['<leader>Ghs'] = { GS.stage_hunk, desc('Stage Current Hunk') },
                ['<leader>Ghr'] = { GS.reset_hunk, desc('Reset Current Hunk') },
                ['<leader>Ghu'] = { GS.undo_stage_hunk, desc('Undo Hunk Stage') },
                ['<leader>Ghp'] = { GS.preview_hunk, desc('Preview Current Hunk') },
                ['<leader>GhS'] = { GS.stage_buffer, desc('Stage The Whole Buffer') },
                ['<leader>GhR'] = { GS.reset_buffer, desc('Reset The Whole Buffer') },
                ['<leader>Ghb'] = {
                    function() GS.blame_line({ full = true }) end,
                    desc('Blame Current Line'),
                },
                ['<leader>Ghd'] = { GS.diffthis, desc('Diff Against Index') },
                ['<leader>GhD'] = {
                    function() GS.diffthis('~') end,
                    desc('Diff This'),
                },
                ['<leader>Gtb'] = { GS.toggle_current_line_blame, desc('Toggle Line Blame') },
                ['<leader>Gtd'] = { GS.toggle_deleted, desc('Toggle Deleted') },
            },
            v = {
                ['<leader>Ghs'] = {
                    function() GS.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    desc('Stage Selected Hunks'),
                },
                ['<leader>Ghr'] = {
                    function() GS.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    desc('Reset Selected Hunks'),
                },
            },
            o = { ['ih'] = { ':<C-U>Gitsigns select_hunk<CR>' } },
            x = { ['ih'] = { ':<C-U>Gitsigns select_hunk<CR>' } },
        }
        ---@type table<MapModes, RegKeysNamed>
        local Names = {
            n = {
                ['<leader>G'] = { group = '+Git' },
                ['<leader>Gh'] = { group = '+GitSigns Hunks' },
                ['<leader>Gt'] = { group = '+GitSigns Toggles' },
            },
            v = {
                ['<leader>G'] = { group = '+Git' },
                ['<leader>Gh'] = { group = '+GitSigns Hunks' },
            },
        }

        if WK.available() then
            map_dict(Names, 'wk.register', true, nil, bufnr)
        end

        map_dict(Keys, 'wk.register', true, nil, bufnr)
    end,

    ---@type GitSigns
    signs = {
        add = { text = '+' },
        change = { text = '┃' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
    },
    signs_staged = {
        add = { text = '+' },
        change = { text = '┃' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
    },

    signs_staged_enable = true,

    signcolumn = vim.opt.signcolumn:get() == 'yes', -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1500,
        ignore_whitespace = false,
        virt_text_priority = 3,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 4,
    update_debounce = 100,
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    status_formatter = nil,
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
