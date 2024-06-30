---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local types = User.types.diffview
local Check = User.check
local Maps = User.maps
local WK = Maps.wk

local exists = Check.exists.module
local desc = Maps.kmap.desc
local map_dict = Maps.map_dict

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
            return {
                ---@type DiffView.WinConfig.Type
                type = 'split',
                ---@type DiffView.WinConfig.Positon
                position = 'left',
                width = 25,
                height = 20,
                ---@type DiffView.WinConfig.Relative
                relative = 'win',
                win = vim.api.nvim_tabpage_list_wins(0)[1],
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
            local c = { width = vim.opt.columns:get(), height = vim.opt.lines:get() }

            return {
                ---@type DiffView.WinConfig.Positon
                position = 'bottom',
                width = math.min(100, c.width),
                height = math.min(24, c.height),
                col = math.floor(vim.opt.columns:get() * 0.5 - c.width * 0.5),
                row = math.floor(vim.opt.lines:get() * 0.5 - c.height * 0.5),
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
            local c = { width = vim.opt.columns:get(), height = vim.opt.lines:get() }

            return {
                ---@type DiffView.WinConfig.Positon
                position = 'bottom',
                width = math.min(100, c.width),
                height = math.min(24, c.height),
                col = math.floor(vim.opt.columns:get() * 0.5 - c.width * 0.5),
                row = math.floor(vim.opt.lines:get() * 0.5 - c.height * 0.5),
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
        ---@param bufnr integer
        diff_buf_read = function(bufnr)
            --- Change local options in diff buffers
            vim.opt_local.wrap = true
            vim.opt_local.list = true
            vim.opt_local.colorcolumn = { 120 }
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
                desc('Open the diff for the next file', true, 0),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file', true, 0),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage', true, 0),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split', true, 0),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage', true, 0),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel', true, 0),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel.', true, 0),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle through available layouts.', true, 0),
            },
            {
                'n',
                '[x',
                Actions.prev_conflict,
                desc('In the merge-tool: jump to the previous conflict', true, 0),
            },
            {
                'n',
                ']x',
                Actions.next_conflict,
                desc('In the merge-tool: jump to the next conflict', true, 0),
            },
            {
                'n',
                '<leader>co',
                Actions.conflict_choose('ours'),
                desc('Choose the OURS version of a conflict', true, 0),
            },
            {
                'n',
                '<leader>ct',
                Actions.conflict_choose('theirs'),
                desc('Choose the THEIRS version of a conflict', true, 0),
            },
            {
                'n',
                '<leader>cb',
                Actions.conflict_choose('base'),
                desc('Choose the BASE version of a conflict', true, 0),
            },
            {
                'n',
                '<leader>ca',
                Actions.conflict_choose('all'),
                desc('Choose all the versions of a conflict', true, 0),
            },
            {
                'n',
                'dx',
                Actions.conflict_choose('none'),
                desc('Delete the conflict region', true, 0),
            },
            {
                'n',
                '<leader>cO',
                Actions.conflict_choose_all('ours'),
                desc('Choose the OURS version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cT',
                Actions.conflict_choose_all('theirs'),
                desc('Choose the THEIRS version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cB',
                Actions.conflict_choose_all('base'),
                desc('Choose the BASE version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cA',
                Actions.conflict_choose_all('all'),
                desc('Choose all the versions of a conflict for the whole file', true, 0),
            },
            {
                'n',
                'dX',
                Actions.conflict_choose_all('none'),
                desc('Delete the conflict region for the whole file', true, 0),
            },
        },
        diff1 = {
            --- Mappings in single window diff layouts
            { 'n', 'g?', Actions.help({ 'view', 'diff1' }), desc('Open the help panel', true, 0) },
        },
        diff2 = {
            --- Mappings in 2-way diff layouts
            { 'n', 'g?', Actions.help({ 'view', 'diff2' }), desc('Open the help panel', true, 0) },
        },
        diff3 = {
            --- Mappings in 3-way diff layouts
            {
                { 'n', 'x' },
                '2do',
                Actions.diffget('ours'),
                desc('Obtain the diff hunk from the OURS version of the file', true, 0),
            },
            {
                { 'n', 'x' },
                '3do',
                Actions.diffget('theirs'),
                desc('Obtain the diff hunk from the THEIRS version of the file', true, 0),
            },
            {
                'n',
                'g?',
                Actions.help({ 'view', 'diff3' }),
                desc('Open the help panel', true, 0),
            },
        },
        diff4 = {
            --- Mappings in 4-way diff layouts
            {
                { 'n', 'x' },
                '1do',
                Actions.diffget('base'),
                desc('Obtain the diff hunk from the BASE version of the file', true, 0),
            },
            {
                { 'n', 'x' },
                '2do',
                Actions.diffget('ours'),
                desc('Obtain the diff hunk from the OURS version of the file', true, 0),
            },
            {
                { 'n', 'x' },
                '3do',
                Actions.diffget('theirs'),
                desc('Obtain the diff hunk from the THEIRS version of the file', true, 0),
            },
            {
                'n',
                'g?',
                Actions.help({ 'view', 'diff4' }),
                desc('Open the help panel', true, 0),
            },
        },
        file_panel = {
            {
                'n',
                'j',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry', true, 0),
            },
            {
                'n',
                '<Down>',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry', true, 0),
            },
            {
                'n',
                'k',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry', true, 0),
            },
            {
                'n',
                '<Up>',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry', true, 0),
            },
            {
                'n',
                '<CR>',
                Actions.select_entry,
                desc('Open the diff for the selected entry', true, 0),
            },
            {
                'n',
                'o',
                Actions.select_entry,
                desc('Open the diff for the selected entry', true, 0),
            },
            {
                'n',
                'l',
                Actions.select_entry,
                desc('Open the diff for the selected entry', true, 0),
            },
            {
                'n',
                '<2-LeftMouse>',
                Actions.select_entry,
                desc('Open the diff for the selected entry', true, 0),
            },
            {
                'n',
                '-',
                Actions.toggle_stage_entry,
                desc('Stage / unstage the selected entry', true, 0),
            },
            {
                'n',
                's',
                Actions.toggle_stage_entry,
                desc('Stage / unstage the selected entry', true, 0),
            },
            {
                'n',
                'S',
                Actions.stage_all,
                desc('Stage all entries', true, 0),
            },
            {
                'n',
                'U',
                Actions.unstage_all,
                desc('Unstage all entries', true, 0),
            },
            {
                'n',
                'X',
                Actions.restore_entry,
                desc('Restore entry to the state on the left side', true, 0),
            },
            {
                'n',
                'L',
                Actions.open_commit_log,
                desc('Open the commit log panel', true, 0),
            },
            {
                'n',
                'zo',
                Actions.open_fold,
                desc('Expand fold', true, 0),
            },
            {
                'n',
                'h',
                Actions.close_fold,
                desc('Collapse fold', true, 0),
            },
            {
                'n',
                'zc',
                Actions.close_fold,
                desc('Collapse fold', true, 0),
            },
            {
                'n',
                'za',
                Actions.toggle_fold,
                desc('Toggle fold', true, 0),
            },
            {
                'n',
                'zR',
                Actions.open_all_folds,
                desc('Expand all folds', true, 0),
            },
            {
                'n',
                'zM',
                Actions.close_all_folds,
                desc('Collapse all folds', true, 0),
            },
            {
                'n',
                '<C-b>',
                Actions.scroll_view(-0.25),
                desc('Scroll the view up', true, 0),
            },
            {
                'n',
                '<C-f>',
                Actions.scroll_view(0.25),
                desc('Scroll the view down', true, 0),
            },
            {
                'n',
                '<Tab>',
                Actions.select_next_entry,
                desc('Open the diff for the next file', true, 0),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file', true, 0),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage', true, 0),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split', true, 0),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage', true, 0),
            },
            {
                'n',
                'i',
                Actions.listing_style,
                desc("Toggle between 'list' and 'tree' views", true, 0),
            },
            {
                'n',
                'f',
                Actions.toggle_flatten_dirs,
                desc('Flatten empty subdirectories in tree listing style', true, 0),
            },
            {
                'n',
                'R',
                Actions.refresh_files,
                desc('Update stats and entries in the file list', true, 0),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel', true, 0),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel', true, 0),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle available layouts', true, 0),
            },
            {
                'n',
                '[x',
                Actions.prev_conflict,
                desc('Go to the previous conflict', true, 0),
            },
            {
                'n',
                ']x',
                Actions.next_conflict,
                desc('Go to the next conflict', true, 0),
            },
            {
                'n',
                'g?',
                Actions.help('file_panel'),
                desc('Open the help panel', true, 0),
            },
            {
                'n',
                '<leader>cO',
                Actions.conflict_choose_all('ours'),
                desc('Choose the OURS version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cT',
                Actions.conflict_choose_all('theirs'),
                desc('Choose the THEIRS version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cB',
                Actions.conflict_choose_all('base'),
                desc('Choose the BASE version of a conflict for the whole file', true, 0),
            },
            {
                'n',
                '<leader>cA',
                Actions.conflict_choose_all('all'),
                desc('Choose all the versions of a conflict for the whole file', true, 0),
            },
            {
                'n',
                'dX',
                Actions.conflict_choose_all('none'),
                desc('Delete the conflict region for the whole file', true, 0),
            },
        },
        file_history_panel = {
            {
                'n',
                'g!',
                Actions.options,
                desc('Open the option panel', true, 0),
            },
            {
                'n',
                '<C-A-d>',
                Actions.open_in_diffview,
                desc('Open the entry under the cursor in a diffview', true, 0),
            },
            {
                'n',
                'y',
                Actions.copy_hash,
                desc('Copy the commit hash of the entry under the cursor', true, 0),
            },
            {
                'n',
                'L',
                Actions.open_commit_log,
                desc('Show commit details', true, 0),
            },
            {
                'n',
                'zR',
                Actions.open_all_folds,
                desc('Expand all folds', true, 0),
            },
            {
                'n',
                'zM',
                Actions.close_all_folds,
                desc('Collapse all folds', true, 0),
            },
            {
                'n',
                'j',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry', true, 0),
            },
            {
                'n',
                '<Down>',
                Actions.next_entry,
                desc('Bring the cursor to the next file entry', true, 0),
            },
            {
                'n',
                'k',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry.', true, 0),
            },
            {
                'n',
                '<Up>',
                Actions.prev_entry,
                desc('Bring the cursor to the previous file entry.', true, 0),
            },
            {
                'n',
                '<CR>',
                Actions.select_entry,
                desc('Open the diff for the selected entry.', true, 0),
            },
            {
                'n',
                'o',
                Actions.select_entry,
                desc('Open the diff for the selected entry.', true, 0),
            },
            {
                'n',
                '<2-LeftMouse>',
                vim.opt.mouse:get() ~= '' and Actions.select_entry or '<Nop>',
                desc('Open the diff for the selected entry.', true, 0),
            },
            {
                'n',
                '<C-b>',
                Actions.scroll_view(-0.25),
                desc('Scroll the view up', true, 0),
            },
            {
                'n',
                '<C-f>',
                Actions.scroll_view(0.25),
                desc('Scroll the view down', true, 0),
            },
            {
                'n',
                '<Tab>',
                Actions.select_next_entry,
                desc('Open the diff for the next file', true, 0),
            },
            {
                'n',
                '<S-Tab>',
                Actions.select_prev_entry,
                desc('Open the diff for the previous file', true, 0),
            },
            {
                'n',
                'gf',
                Actions.goto_file_edit,
                desc('Open the file in the previous tabpage', true, 0),
            },
            {
                'n',
                '<C-w><C-f>',
                Actions.goto_file_split,
                desc('Open the file in a new split', true, 0),
            },
            {
                'n',
                '<C-w>gf',
                Actions.goto_file_tab,
                desc('Open the file in a new tabpage', true, 0),
            },
            {
                'n',
                '<leader>e',
                Actions.focus_files,
                desc('Bring focus to the file panel', true, 0),
            },
            {
                'n',
                '<leader>b',
                Actions.toggle_files,
                desc('Toggle the file panel', true, 0),
            },
            {
                'n',
                'g<C-x>',
                Actions.cycle_layout,
                desc('Cycle available layouts', true, 0),
            },
            {
                'n',
                'g?',
                Actions.help('file_history_panel'),
                desc('Open the help panel', true, 0),
            },
        },
        option_panel = {
            { 'n', '<Tab>', Actions.select_entry, desc('Change the current option', true, 0) },
            { 'n', 'q', Actions.close, desc('Close the panel', true, 0) },
            { 'n', 'g?', Actions.help('option_panel'), desc('Open the help panel', true, 0) },
        },
        help_panel = {
            { 'n', 'q', Actions.close, desc('Close help menu', true, 0) },
            { 'n', '<Esc>', Actions.close, desc('Close help menu', true, 0) },
        },
    },
})

---@type KeyMapDict
local Keys = {
    ['<leader>GDo'] = { DVW.open, desc('Open DiffView') },
    ['<leader>GDc'] = { DVW.close, desc('Close DiffView') },
}
---@type RegKeysNamed
local Names = {
    ['<leader>G'] = { name = '+Git' },
    ['<leader>GD'] = { name = '+DiffView' },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n')
end
map_dict(Keys, 'wk.register', false, 'n')
