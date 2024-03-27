---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Ap = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local Conds = require('nvim-autopairs.conds')
local Handlers = require('nvim-autopairs.completion.handlers')

local bpairs = {
	{ '(', ')' },
	{ '[', ']' },
	{ '{', '}' }
}

local rule2 = function(a1, ins, a2, lang)
	Ap.add_rules(
	Rule(ins, ins, lang)
	:with_pair(function(opts) return a1..a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1) end)
	:with_move(Conds.none())
	:sith_cr(Conds.none())
	:wkth_del(function(opts)
		local col = vim.api.nvim_win_get_cursor(0)[2]
		return a1..ins..ins..a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
	end)
	)
end

Ap.clear_rules()
for _, bracket in pairs(bpairs) do
	Ap.add_rules {
		Rule(bracket[1], bracket[2])
		:end_wise(function() return true end)
	}
end

Ap.add_rules({
	Rule(' ', ' ')
	:with_pair(function(opts)
		local pair = opts.line:sub(opts.col - 1, opts.col)
		return vim.tbl_contains({
			bpairs[1][1]..bpairs[1][2],
			bpairs[2][1]..bpairs[2][2],
			bpairs[3][1]..bpairs[3][2],
		}, pair)
	end)
	:with_move(Conds.none())
	:with_cr(Conds.none())
	:with_del(function(opts)
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local context = opts.line:sub(col - 1, col + 2)
		return vim.tbl_contains({
			bpairs[1][1] .. '  ' .. bpairs[1][2],
			bpairs[2][1] .. '  ' .. bpairs[2][2],
			bpairs[3][1] .. '  ' .. bpairs[3][2]
		}, context)
	end)
})
for _, bracket in pairs(bpairs) do
	Ap.add_rules {
		-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
		Rule(bracket[1] .. ' ', ' ' .. bracket[2])
		:with_pair(Conds.none())
		:with_move(function(opts) return opts.char == bracket[2] end)
		:with_del(Conds.none())
		:use_key(bracket[2])
		-- Removes the trailing whitespace that can occur without this
		:replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
	}
end
