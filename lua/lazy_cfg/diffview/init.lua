---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('diffview') then
	return
end

local DVW = require('diffview')
local Actions = require('diffview.actions')

require("diffview").setup({
	diff_binaries = false,    -- Show diffs for binaries
	enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
	git_cmd = { "git" },      -- The git executable followed by default args.
	hg_cmd = { "hg" },        -- The hg executable followed by default args.
	use_icons = true,         -- Requires nvim-web-devicons
	show_help_hints = true,   -- Show hints for how to open the help panel
	watch_index = true,       -- Update views and index buffers when the git index changes.
	icons = {                 -- Only applies when use_icons is true.
		folder_closed = "",
		folder_open = "",
	},
	signs = {
		fold_closed = "",
		fold_open = "",
		done = "✓",
	},
	view = {
		-- Configure the layout and behavior of different types of views.
		-- Available layouts:
		--  'diff1_plain'
		--    |'diff2_horizontal'
		--    |'diff2_vertical'
		--    |'diff3_horizontal'
		--    |'diff3_vertical'
		--    |'diff3_mixed'
		--    |'diff4_mixed'
		-- For more info, see ':h diffview-config-view.x.layout'.
		default = {
			-- Config for changed files, and staged files in diff views.
		---@type
		--- |'diff1_plain'
		--- |'diff2_horizontal'
		--- |'diff2_vertical'
		--- |'diff3_horizontal'
		--- |'diff3_vertical'
		--- |'diff3_mixed'
		--- |'diff4_mixed'
			layout = "diff2_horizontal",
			winbar_info = true,          -- See ':h diffview-config-view.x.winbar_info'
		},
		merge_tool = {
			-- Config for conflicted files in diff views during a merge or rebase.
			layout = "diff3_horizontal",
			disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
			winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
		},
		file_history = {
			-- Config for changed files in file history views.
			layout = "diff2_horizontal",
			winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
		},
	},
	file_panel = {
		listing_style = "tree",             -- One of 'list' or 'tree'
		tree_options = {                    -- Only applies when listing_style is 'tree'
			flatten_dirs = true,              -- Flatten dirs that only contain one single dir
			folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
		},
		win_config = {                      -- See ':h diffview-config-win_config'
			position = "left",
			width = 35,
			win_opts = {}
		},
	},
	file_history_panel = {
		log_options = {   -- See ':h diffview-config-log_options'
			git = {
				single_file = {
					diff_merges = "combined",
				},
				multi_file = {
					diff_merges = "first-parent",
				},
			},
			hg = {
				single_file = {},
				multi_file = {},
			},
		},
		win_config = {    -- See ':h diffview-config-win_config'
			position = "bottom",
			height = 16,
			win_opts = {}
		},
	},
	commit_log_panel = {
		win_config = {   -- See ':h diffview-config-win_config'
			win_opts = {},
		}
	},
	default_args = {    -- Default args prepended to the arg-list for the listed commands
		DiffviewOpen = {},
		DiffviewFileHistory = {},
	},
	hooks = {
		diff_buf_read = function(bufnr)
			-- Change local options in diff buffers
			vim.opt_local.wrap = false
			vim.opt_local.list = false
			vim.opt_local.colorcolumn = { 80 }
		end,
		view_opened = function(view)
			print(
			("A new %s was opened on tab page %d!")
			:format(view.class:name(), view.tabpage)
			)
		end,
	},         -- See ':h diffview-config-hooks'
	keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		view = {
			-- The `view` bindings are active in the diff buffers, only when the current
			-- tabpage is a Diffview.
			{ "n", "<tab>",       Actions.select_next_entry,              { desc = "Open the diff for the next file" } },
			{ "n", "<s-tab>",     Actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
			{ "n", "gf",          Actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
			{ "n", "<C-w><C-f>",  Actions.goto_file_split,                { desc = "Open the file in a new split" } },
			{ "n", "<C-w>gf",     Actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
			{ "n", "<leader>e",   Actions.focus_files,                    { desc = "Bring focus to the file panel" } },
			{ "n", "<leader>b",   Actions.toggle_files,                   { desc = "Toggle the file panel." } },
			{ "n", "g<C-x>",      Actions.cycle_layout,                   { desc = "Cycle through available layouts." } },
			{ "n", "[x",          Actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
			{ "n", "]x",          Actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
			{ "n", "<leader>co",  Actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
			{ "n", "<leader>ct",  Actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
			{ "n", "<leader>cb",  Actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
			{ "n", "<leader>ca",  Actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
			{ "n", "dx",          Actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
			{ "n", "<leader>cO",  Actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
			{ "n", "<leader>cT",  Actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
			{ "n", "<leader>cB",  Actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
			{ "n", "<leader>cA",  Actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
			{ "n", "dX",          Actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
		},
		diff1 = {
			-- Mappings in single window diff layouts
			{ "n", "g?", Actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
		},
		diff2 = {
			-- Mappings in 2-way diff layouts
			{ "n", "g?", Actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
		},
		diff3 = {
			-- Mappings in 3-way diff layouts
			{ { "n", "x" }, "2do",  Actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
			{ { "n", "x" }, "3do",  Actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
			{ "n",          "g?",   Actions.help({ "view", "diff3" }),  { desc = "Open the help panel" } },
		},
		diff4 = {
			-- Mappings in 4-way diff layouts
			{ { "n", "x" }, "1do",  Actions.diffget("base"),            { desc = "Obtain the diff hunk from the BASE version of the file" } },
			{ { "n", "x" }, "2do",  Actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
			{ { "n", "x" }, "3do",  Actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
			{ "n",          "g?",   Actions.help({ "view", "diff4" }),  { desc = "Open the help panel" } },
		},
		file_panel = {
			{ "n", "j",              Actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
			{ "n", "<down>",         Actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
			{ "n", "k",              Actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
			{ "n", "<up>",           Actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
			{ "n", "<cr>",           Actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
			{ "n", "o",              Actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
			{ "n", "l",              Actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
			{ "n", "<2-LeftMouse>",  Actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
			{ "n", "-",              Actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
			{ "n", "s",              Actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
			{ "n", "S",              Actions.stage_all,                      { desc = "Stage all entries" } },
			{ "n", "U",              Actions.unstage_all,                    { desc = "Unstage all entries" } },
			{ "n", "X",              Actions.restore_entry,                  { desc = "Restore entry to the state on the left side" } },
			{ "n", "L",              Actions.open_commit_log,                { desc = "Open the commit log panel" } },
			{ "n", "zo",             Actions.open_fold,                      { desc = "Expand fold" } },
			{ "n", "h",              Actions.close_fold,                     { desc = "Collapse fold" } },
			{ "n", "zc",             Actions.close_fold,                     { desc = "Collapse fold" } },
			{ "n", "za",             Actions.toggle_fold,                    { desc = "Toggle fold" } },
			{ "n", "zR",             Actions.open_all_folds,                 { desc = "Expand all folds" } },
			{ "n", "zM",             Actions.close_all_folds,                { desc = "Collapse all folds" } },
			{ "n", "<c-b>",          Actions.scroll_view(-0.25),             { desc = "Scroll the view up" } },
			{ "n", "<c-f>",          Actions.scroll_view(0.25),              { desc = "Scroll the view down" } },
			{ "n", "<tab>",          Actions.select_next_entry,              { desc = "Open the diff for the next file" } },
			{ "n", "<s-tab>",        Actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
			{ "n", "gf",             Actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
			{ "n", "<C-w><C-f>",     Actions.goto_file_split,                { desc = "Open the file in a new split" } },
			{ "n", "<C-w>gf",        Actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
			{ "n", "i",              Actions.listing_style,                  { desc = "Toggle between 'list' and 'tree' views" } },
			{ "n", "f",              Actions.toggle_flatten_dirs,            { desc = "Flatten empty subdirectories in tree listing style" } },
			{ "n", "R",              Actions.refresh_files,                  { desc = "Update stats and entries in the file list" } },
			{ "n", "<leader>e",      Actions.focus_files,                    { desc = "Bring focus to the file panel" } },
			{ "n", "<leader>b",      Actions.toggle_files,                   { desc = "Toggle the file panel" } },
			{ "n", "g<C-x>",         Actions.cycle_layout,                   { desc = "Cycle available layouts" } },
			{ "n", "[x",             Actions.prev_conflict,                  { desc = "Go to the previous conflict" } },
			{ "n", "]x",             Actions.next_conflict,                  { desc = "Go to the next conflict" } },
			{ "n", "g?",             Actions.help("file_panel"),             { desc = "Open the help panel" } },
			{ "n", "<leader>cO",     Actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
			{ "n", "<leader>cT",     Actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
			{ "n", "<leader>cB",     Actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
			{ "n", "<leader>cA",     Actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
			{ "n", "dX",             Actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
		},
		file_history_panel = {
			{ "n", "g!",            Actions.options,                     { desc = "Open the option panel" } },
			{ "n", "<C-A-d>",       Actions.open_in_diffview,            { desc = "Open the entry under the cursor in a diffview" } },
			{ "n", "y",             Actions.copy_hash,                   { desc = "Copy the commit hash of the entry under the cursor" } },
			{ "n", "L",             Actions.open_commit_log,             { desc = "Show commit details" } },
			{ "n", "zR",            Actions.open_all_folds,              { desc = "Expand all folds" } },
			{ "n", "zM",            Actions.close_all_folds,             { desc = "Collapse all folds" } },
			{ "n", "j",             Actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
			{ "n", "<down>",        Actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
			{ "n", "k",             Actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
			{ "n", "<up>",          Actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
			{ "n", "<cr>",          Actions.select_entry,                { desc = "Open the diff for the selected entry." } },
			{ "n", "o",             Actions.select_entry,                { desc = "Open the diff for the selected entry." } },
			{ "n", "<2-LeftMouse>", Actions.select_entry,                { desc = "Open the diff for the selected entry." } },
			{ "n", "<c-b>",         Actions.scroll_view(-0.25),          { desc = "Scroll the view up" } },
			{ "n", "<c-f>",         Actions.scroll_view(0.25),           { desc = "Scroll the view down" } },
			{ "n", "<tab>",         Actions.select_next_entry,           { desc = "Open the diff for the next file" } },
			{ "n", "<s-tab>",       Actions.select_prev_entry,           { desc = "Open the diff for the previous file" } },
			{ "n", "gf",            Actions.goto_file_edit,              { desc = "Open the file in the previous tabpage" } },
			{ "n", "<C-w><C-f>",    Actions.goto_file_split,             { desc = "Open the file in a new split" } },
			{ "n", "<C-w>gf",       Actions.goto_file_tab,               { desc = "Open the file in a new tabpage" } },
			{ "n", "<leader>e",     Actions.focus_files,                 { desc = "Bring focus to the file panel" } },
			{ "n", "<leader>b",     Actions.toggle_files,                { desc = "Toggle the file panel" } },
			{ "n", "g<C-x>",        Actions.cycle_layout,                { desc = "Cycle available layouts" } },
			{ "n", "g?",            Actions.help("file_history_panel"),  { desc = "Open the help panel" } },
		},
		option_panel = {
			{ "n", "<tab>", Actions.select_entry,          { desc = "Change the current option" } },
			{ "n", "q",     Actions.close,                 { desc = "Close the panel" } },
			{ "n", "g?",    Actions.help("option_panel"),  { desc = "Open the help panel" } },
		},
		help_panel = {
			{ "n", "q",     Actions.close,  { desc = "Close help menu" } },
			{ "n", "<esc>", Actions.close,  { desc = "Close help menu" } },
		},
	},
})
