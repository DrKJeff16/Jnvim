local User = require('user_api')
local Check = User.check
local Types = User.types.gitsigns
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local is_num = Check.value.is_num
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not executable('git') or not exists('gitsigns') then
    return
end

User.register_plugin('plugin.git.gitsigns')

local GS = require('gitsigns')

GS.setup({
    ---@param bufnr? integer
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
                    desc('Next Hunk', true, bufnr, true, true, true),
                },
                ['<leader>Gh['] = {
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            GS.nav_hunk('prev')
                        end
                    end,
                    desc('Previous Hunk', true, bufnr, true, true, true),
                },

                -- Actions
                ['<leader>Ghs'] = {
                    GS.stage_hunk,
                    desc('Stage Current Hunk', true, bufnr),
                },
                ['<leader>Ghr'] = {
                    GS.reset_hunk,
                    desc('Reset Current Hunk', true, bufnr),
                },
                ['<leader>Ghu'] = {
                    GS.undo_stage_hunk,
                    desc('Undo Hunk Stage', true, bufnr),
                },
                ['<leader>Ghp'] = {
                    GS.preview_hunk,
                    desc('Preview Current Hunk', true, bufnr),
                },
                ['<leader>GhS'] = {
                    GS.stage_buffer,
                    desc('Stage The Whole Buffer', true, bufnr),
                },
                ['<leader>GhR'] = {
                    GS.reset_buffer,
                    desc('Reset The Whole Buffer', true, bufnr),
                },
                ['<leader>Ghb'] = {
                    function() GS.blame_line({ full = true }) end,
                    desc('Blame Current Line', true, bufnr),
                },
                ['<leader>Ghd'] = {
                    GS.diffthis,
                    desc('Diff Against Index', true, bufnr),
                },
                ['<leader>GhD'] = {
                    function() GS.diffthis('~') end,
                    desc('Diff This', true, bufnr),
                },
                ['<leader>Gtb'] = {
                    GS.toggle_current_line_blame,
                    desc('Toggle Line Blame', true, bufnr),
                },
                ['<leader>Gtd'] = {
                    GS.toggle_deleted,
                    desc('Toggle Deleted', true, bufnr),
                },
            },
            v = {
                ['<leader>Ghs'] = {
                    function() GS.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    desc('Stage Selected Hunks', true, bufnr),
                },
                ['<leader>Ghr'] = {
                    function() GS.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    desc('Reset Selected Hunks', true, bufnr),
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

    signcolumn = vim.wo.signcolumn == 'yes', -- Toggle with `:Gitsigns toggle_signs`
    numhl = vim.wo.number, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = false,
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
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
