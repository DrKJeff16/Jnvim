---@alias DiffView.Views
---|'diff1_plain'
---|'diff2_horizontal'
---|'diff2_vertical'
---|'diff3_horizontal'
---|'diff3_vertical'
---|'diff3_mixed'
---|'diff4_mixed'
---|-1

---@alias DiffView.ListStyle 'list'|'tree'
---@alias DiffView.WinConfig.Type 'float'|'split'
---@alias DiffView.WinConfig.Positon 'left'|'top'|'right'|'bottom'
---@alias DiffView.WinConfig.Relative 'editor'|'win'

local min = math.min
local floor = math.floor

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local desc = User.maps.desc
local exists = Check.exists.module
if not exists('diffview') then
    return
end

local DVW = require('diffview')
local Actions = require('diffview.actions')

DVW.setup({
    diff_binaries = false, --- Show diffs for binaries
    enhanced_diff_hl = true, --- See `:h diffview-config-enhanced_diff_hl`
    use_icons = exists('nvim-web-devicons'), --- Requires nvim-web-devicons
    show_help_hints = true, --- Show hints for how to open the help panel
    watch_index = true, --- Update views and index buffers when the git index changes

    --- The git executable followed by default args
    git_cmd = { 'git' },
    --- The hg executable followed by default args
    hg_cmd = { 'hg' },

    --- Only applies when use_icons is true
    icons = {
        folder_closed = '',
        folder_open = '',
    },
    signs = {
        fold_closed = '',
        fold_open = '',
        done = '✓',
    },

    view = {
        --- For more info, see `:h diffview-config-view.x.layout`
        default = {
            --- Config for changed files, and staged files in diff views
            ---@type DiffView.Views
            layout = 'diff2_horizontal',
            --- See `:h diffview-config-view.x.winbar_info`
            winbar_info = true,
        },

        merge_tool = {
            --- Config for conflicted files in diff views during a merge or rebase
            ---@type DiffView.Views
            layout = 'diff3_horizontal',
            disable_diagnostics = true, --- Temporarily disable diagnostics for conflict buffers while in the view
            winbar_info = true, --- See `:h diffview-config-view.x.winbar_info`
        },

        file_history = {
            --- Config for changed files in file history views
            ---@type DiffView.Views
            layout = 'diff2_horizontal',
            --- See `:h diffview-config-view.x.winbar_info`
            winbar_info = true,
        },
    },

    file_panel = {
        ---@type DiffView.ListStyle
        listing_style = 'list',

        --- Only applies when listing_style is `tree`
        tree_options = {
            --- Flatten dirs that only contain one single dir
            flatten_dirs = true,

            ---@type 'never'|'only_folded'|'always'
            folder_statuses = 'always',
        },

        --- See `:h diffview-config-win_config`
        win_config = function()
            local tab = vim.api.nvim_get_current_tabpage()

            return {
                ---@type DiffView.WinConfig.Type
                type = 'split',

                ---@type DiffView.WinConfig.Positon
                position = 'left',

                width = 25,
                height = 20,

                ---@type DiffView.WinConfig.Relative
                relative = 'win',

                win = vim.api.nvim_tabpage_list_wins(tab)[1],

                ---@type table|vim.wo
                win_opts = {
                    number = false,
                    wrap = true,
                    relativenumber = false,
                    signcolumn = 'no',
                    cursorline = true,
                },
            }
        end,
    },

    file_history_panel = {

        --- See `:h diffview-config-log_options`
        log_options = {
            git = {
                single_file = { diff_merges = 'combined' },
                multi_file = { diff_merges = 'first-parent' },
            },
        },

        --- See `:h diffview-config-win_config`
        win_config = function()
            local c = { width = vim.o.columns, height = vim.o.lines }

            return {
                ---@type DiffView.WinConfig.Positon
                position = 'bottom',
                width = min(100, c.width),
                height = min(24, c.height),
                col = floor(vim.o.columns * 0.5 - c.width * 0.5),
                row = floor(vim.o.lines * 0.5 - c.height * 0.5),

                ---@type table|vim.wo
                win_opts = {
                    number = false,
                    wrap = false,
                    relativenumber = false,
                    signcolumn = 'no',
                    cursorline = true,
                },
            }
        end,
    },
    commit_log_panel = {
        --- See `:h diffview-config-win_config`
        win_config = function()
            local c = {
                width = vim.o.columns,
                height = vim.o.lines,
            }

            return {
                ---@type DiffView.WinConfig.Positon
                position = 'bottom',

                width = min(100, c.width),
                height = min(24, c.height),

                col = floor(vim.o.columns * 0.5 - c.width * 0.5),
                row = floor(vim.o.lines * 0.5 - c.height * 0.5),

                ---@type table|vim.wo
                win_opts = {
                    number = false,
                    wrap = false,
                    relativenumber = false,
                    signcolumn = 'no',
                    cursorline = true,
                },
            }
        end,
    },

    --- Default args prepended to the arg-list for the listed commands
    default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },

    --- See `:h diffview-config-hooks`
    hooks = {
        diff_buf_read = function(_)
            --- Change local options in diff buffers
            vim.api.nvim_set_option_value('wrap', true, { scope = 'local' })
            vim.api.nvim_set_option_value('list', true, { scope = 'local' })
            vim.api.nvim_set_option_value('colorcolumn', '120', { scope = 'local' })
        end,

        ---@param view View
        view_opened = function(view)
            print(('A new %s was opened on tab page %d!'):format(view.class:name(), view.tabpage))
        end,
    },

    keymaps = {
        disable_defaults = false, --- Disable the default keymaps
        --- The `view` bindings are active in the diff buffers, only when the current
        --- tabpage is a Diffview
        view = {
            {
                'n',
                '<Tab>',
                Actions.select_next_entry,
                desc('Open the diff for the next file'),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file'),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage'),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split'),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage'),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel'),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel.'),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle through available layouts.'),
            },
            {
                'n',
                '[x',
                Actions.prev_conflict,
                desc('In the merge-tool: jump to the previous conflict'),
            },
            {
                'n',
                ']x',
                Actions.next_conflict,
                desc('In the merge-tool: jump to the next conflict'),
            },
            {
                'n',
                '<leader>co',
                Actions.conflict_choose('ours'),
                desc('Choose the OURS version of a conflict'),
            },
            {
                'n',
                '<leader>ct',
                Actions.conflict_choose('theirs'),
                desc('Choose the THEIRS version of a conflict'),
            },
            {
                'n',
                '<leader>cb',
                Actions.conflict_choose('base'),
                desc('Choose the BASE version of a conflict'),
            },
            {
                'n',
                '<leader>ca',
                Actions.conflict_choose('all'),
                desc('Choose all the versions of a conflict'),
            },
            {
                'n',
                'dx',
                Actions.conflict_choose('none'),
                desc('Delete the conflict region'),
            },
            {
                'n',
                '<leader>cO',
                Actions.conflict_choose_all('ours'),
                desc('Choose the OURS version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cT',
                Actions.conflict_choose_all('theirs'),
                desc('Choose the THEIRS version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cB',
                Actions.conflict_choose_all('base'),
                desc('Choose the BASE version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cA',
                Actions.conflict_choose_all('all'),
                desc('Choose all the versions of a conflict for the whole file'),
            },
            {
                'n',
                'dX',
                Actions.conflict_choose_all('none'),
                desc('Delete the conflict region for the whole file'),
            },
        },
        diff1 = {
            --- Mappings in single window diff layouts
            { 'n', 'g?', Actions.help({ 'view', 'diff1' }), desc('Open the help panel') },
        },
        diff2 = {
            --- Mappings in 2-way diff layouts
            { 'n', 'g?', Actions.help({ 'view', 'diff2' }), desc('Open the help panel') },
        },
        diff3 = {
            --- Mappings in 3-way diff layouts
            {
                { 'n', 'x' },
                '2do',
                Actions.diffget('ours'),
                desc('Obtain the diff hunk from the OURS version of the file'),
            },
            {
                { 'n', 'x' },
                '3do',
                Actions.diffget('theirs'),
                desc('Obtain the diff hunk from the THEIRS version of the file'),
            },
            {
                'n',
                'g?',
                Actions.help({ 'view', 'diff3' }),
                desc('Open the help panel'),
            },
        },
        diff4 = {
            --- Mappings in 4-way diff layouts
            {
                { 'n', 'x' },
                '1do',
                Actions.diffget('base'),
                desc('Obtain the diff hunk from the BASE version of the file'),
            },
            {
                { 'n', 'x' },
                '2do',
                Actions.diffget('ours'),
                desc('Obtain the diff hunk from the OURS version of the file'),
            },
            {
                { 'n', 'x' },
                '3do',
                Actions.diffget('theirs'),
                desc('Obtain the diff hunk from the THEIRS version of the file'),
            },
            {
                'n',
                'g?',
                Actions.help({ 'view', 'diff4' }),
                desc('Open the help panel'),
            },
        },
        file_panel = {
            {
                'n',
                'j',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry'),
            },
            {
                'n',
                '<Down>',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry'),
            },
            {
                'n',
                'k',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry'),
            },
            {
                'n',
                '<Up>',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry'),
            },
            {
                'n',
                '<CR>',
                Actions.select_entry,
                desc('Open the diff for the selected entry'),
            },
            {
                'n',
                'o',
                Actions.select_entry,
                desc('Open the diff for the selected entry'),
            },
            {
                'n',
                'l',
                Actions.select_entry,
                desc('Open the diff for the selected entry'),
            },
            {
                'n',
                '<2-LeftMouse>',
                Actions.select_entry,
                desc('Open the diff for the selected entry'),
            },
            {
                'n',
                '-',
                Actions.toggle_stage_entry,
                desc('Stage / unstage the selected entry'),
            },
            {
                'n',
                's',
                Actions.toggle_stage_entry,
                desc('Stage / unstage the selected entry'),
            },
            {
                'n',
                'S',
                Actions.stage_all,
                desc('Stage all entries'),
            },
            {
                'n',
                'U',
                Actions.unstage_all,
                desc('Unstage all entries'),
            },
            {
                'n',
                'X',
                Actions.restore_entry,
                desc('Restore entry to the state on the left side'),
            },
            {
                'n',
                'L',
                Actions.open_commit_log,
                desc('Open the commit log panel'),
            },
            {
                'n',
                'zo',
                Actions.open_fold,
                desc('Expand fold'),
            },
            {
                'n',
                'h',
                Actions.close_fold,
                desc('Collapse fold'),
            },
            {
                'n',
                'zc',
                Actions.close_fold,
                desc('Collapse fold'),
            },
            {
                'n',
                'za',
                Actions.toggle_fold,
                desc('Toggle fold'),
            },
            {
                'n',
                'zR',
                Actions.open_all_folds,
                desc('Expand all folds'),
            },
            {
                'n',
                'zM',
                Actions.close_all_folds,
                desc('Collapse all folds'),
            },
            {
                'n',
                '<C-b>',
                Actions.scroll_view(-0.25),
                desc('Scroll the view up'),
            },
            {
                'n',
                '<C-f>',
                Actions.scroll_view(0.25),
                desc('Scroll the view down'),
            },
            {
                'n',
                '<Tab>',
                Actions.select_next_entry,
                desc('Open the diff for the next file'),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file'),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage'),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split'),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage'),
            },
            {
                'n',
                'i',
                Actions.listing_style,
                desc("Toggle between 'list' and 'tree' views"),
            },
            {
                'n',
                'f',
                Actions.toggle_flatten_dirs,
                desc('Flatten empty subdirectories in tree listing style'),
            },
            {
                'n',
                'R',
                Actions.refresh_files,
                desc('Update stats and entries in the file list'),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel'),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel'),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle available layouts'),
            },
            {
                'n',
                '[x',
                Actions.prev_conflict,
                desc('Go to the previous conflict'),
            },
            {
                'n',
                ']x',
                Actions.next_conflict,
                desc('Go to the next conflict'),
            },
            {
                'n',
                'g?',
                Actions.help('file_panel'),
                desc('Open the help panel'),
            },
            {
                'n',
                '<leader>cO',
                Actions.conflict_choose_all('ours'),
                desc('Choose the OURS version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cT',
                Actions.conflict_choose_all('theirs'),
                desc('Choose the THEIRS version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cB',
                Actions.conflict_choose_all('base'),
                desc('Choose the BASE version of a conflict for the whole file'),
            },
            {
                'n',
                '<leader>cA',
                Actions.conflict_choose_all('all'),
                desc('Choose all the versions of a conflict for the whole file'),
            },
            {
                'n',
                'dX',
                Actions.conflict_choose_all('none'),
                desc('Delete the conflict region for the whole file'),
            },
        },
        file_history_panel = {
            {
                'n',
                'g!',
                Actions.options,
                desc('Open the option panel'),
            },
            {
                'n',
                '<C-A-d>',
                Actions.open_in_diffview,
                desc('Open the entry under the cursor in a diffview'),
            },
            {
                'n',
                'y',
                Actions.copy_hash,
                desc('Copy the commit hash of the entry under the cursor'),
            },
            {
                'n',
                'L',
                Actions.open_commit_log,
                desc('Show commit details'),
            },
            {
                'n',
                'zR',
                Actions.open_all_folds,
                desc('Expand all folds'),
            },
            {
                'n',
                'zM',
                Actions.close_all_folds,
                desc('Collapse all folds'),
            },
            {
                'n',
                'j',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry'),
            },
            {
                'n',
                '<Down>',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry'),
            },
            {
                'n',
                'k',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry.'),
            },
            {
                'n',
                '<Up>',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry.'),
            },
            {
                'n',
                '<CR>',
                Actions.select_entry,
                desc('Open the diff for the selected entry.'),
            },
            {
                'n',
                'o',
                Actions.select_entry,
                desc('Open the diff for the selected entry.'),
            },
            {
                'n',
                '<2-LeftMouse>',
                vim.o.mouse == '' and '<Nop>' or Actions.select_entry,
                desc('Open the diff for the selected entry.'),
            },
            {
                'n',
                '<C-b>',
                Actions.scroll_view(-0.25),
                desc('Scroll the view up'),
            },
            {
                'n',
                '<C-f>',
                Actions.scroll_view(0.25),
                desc('Scroll the view down'),
            },
            {
                'n',
                '<Tab>',
                Actions.select_next_entry,
                desc('Open the diff for the next file'),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file'),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage'),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split'),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage'),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel'),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel'),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle available layouts'),
            },
            {
                'n',
                'g?',
                Actions.help('file_history_panel'),
                desc('Open the help panel'),
            },
        },
        option_panel = {
            {
                'n',
                '<Tab>',
                Actions.select_entry,
                desc('Change the current option'),
            },
            {
                'n',
                'q',
                Actions.close,
                desc('Close the panel'),
            },
            {
                'n',
                'g?',
                Actions.help('option_panel'),
                desc('Open the help panel'),
            },
        },
        help_panel = {
            {
                'n',
                'q',
                Actions.close,
                desc('Close help menu'),
            },
            {
                'n',
                '<Esc>',
                Actions.close,
                desc('Close help menu'),
            },
        },
    },
})

---@type AllMaps
local Keys = {
    ['<leader>G'] = { group = '+Git' },
    ['<leader>Gv'] = { group = '+DiffView' },

    ['<leader>Gvo'] = {
        DVW.open,
        desc('Open DiffView'),
    },
    ['<leader>Gvc'] = {
        DVW.close,
        desc('Close DiffView'),
    },
}

Keymaps({ n = Keys })

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
