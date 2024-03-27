---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
local User = require('user')
local exists = User.exists

if not exists('todo-comments') then
	return
end

local keymap = vim.keymap

local kmap = keymap.set

---@param lhs string
---@param rhs string|fun(...)
---@param opts? vim.keymap.set.Opts
local nmap = function(lhs, rhs, opts)
	opts = opts or { noremap = true, silent = true, nowait = true }

	if not opts.noremap then
		opts.noremap = true
	end
	if not opts.silent then
		opts.silent = true
	end
	if not opts.nowait then
		opts.nowait = true
	end
	kmap('n', lhs, rhs, opts)
end

local pfx = 'lazy_cfg.todo_comments.'

local Todo = require('todo-comments')

Todo.setup({
	signs = true, -- show icons in the signs column
	sign_priority = 5, -- sign priority
	-- keywords recognized as todo comments
	keywords = {
		FIX = {
			icon = " ", -- icon used for the sign, and in search results
			color = "error", -- can be a hex color, or a named color (see below)
			alt = {
				"FIXME",
				"BUG",
				"FIXIT",
				"ISSUE",
				"TOFIX",
				"SOLVE",
				"TOSOLVE",
				"SOLVEIT",
			}, -- a set of other keywords that all map to this FIX keywords
			-- signs = false, -- configure signs for some keywords individually
		},
		TODO = {
			icon = " ",
			color = "info",
			alt = { "PENDING", "MISSING" },
		},
		HACK = {
			icon = " ",
			color = "warning",
			alt = { "TRICK", "SOLUTION", "ADHOC", "SOLVED" },
		},
		WARN = {
			icon = " ",
			color = "warning",
			alt = {
				"WARNING",
				"XXX",
				"PROBLEM",
				"ISSUE",
			},
		},
		PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
		NOTE = {
			icon = " ",
			color = "hint",
			alt = {
				"INFO",
				"MINDTHIS",
				"WATCH",
				"ATTENTION",
				"TONOTE",
			},
		},
		TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
	gui_style = {
		fg = "NONE", -- The gui style to use for the fg highlight group.
		bg = "BOLD", -- The gui style to use for the bg highlight group.
	},
	merge_keywords = true, -- when true, custom keywords will be merged with the defaults
	-- highlighting of the line containing the todo comment
	-- * before: highlights before the keyword (typically comment characters)
	-- * keyword: highlights of the keyword
	-- * after: highlights after the keyword (todo text)
	highlight = {
		multiline = true, -- enable multine todo comments
		multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
		multiline_context = 3, -- extra lines that will be re-evaluated when changing a line
		before = "", -- "fg" or "bg" or empty
		keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
		after = "fg", -- "fg" or "bg" or empty
		pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
		comments_only = true, -- uses treesitter to match keywords in comments only
		max_line_len = 400, -- ignore lines longer than this
		exclude = {}, -- list of file types to exclude highlighting
	},
	-- list of named colors where we try to extract the guifg from the
	-- list of highlight groups or use the hex color if hl not found as a fallback
	colors = {
		error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
		warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
		info = { "DiagnosticInfo", "#2563EB" },
		hint = { "DiagnosticHint", "#10B981" },
		default = { "Identifier", "#7C3AED" },
		test = { "Identifier", "#FF00FF" }
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		-- regex that will be used to match keywords.
		-- don't replace the (KEYWORDS) placeholder
		pattern = [[\b(KEYWORDS):]], -- ripgrep regex
		-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
	},
})

nmap("]t", function()
  	Todo.jump_next()
end, { desc = "Next todo comment" })

nmap("[t", function()
  	Todo.jump_prev()
end, { desc = "Previous todo comment" })

-- You can also specify a list of valid jump keywords

nmap("]t", function()
  	Todo.jump_next({keywords = { "ERROR", "WARNING" }})
end, { desc = "Next error/warning todo comment" })
