---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local api = vim.api

local Ap = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local Conds = require('nvim-autopairs.conds')
local Handlers = require('nvim-autopairs.completion.handlers')
local ts_conds = require('nvim-autopairs.ts-conds')

-- Ap.clear_rules()

local bpairs = {
	{ '(', ')' },
	{ '[', ']' },
	{ '{', '}' },
}

local rule2 = function(a1, ins, a2, lang)
	Ap.add_rules({
		Rule(ins, ins, lang)
			:with_pair(function(opts) return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1) end)
			:with_move(Conds.none())
			:with_cr(Conds.none())
			:with_del(function(opts)
				local col = api.nvim_win_get_cursor(0)[2]

				-- insert only works for #ins == 1 anyway
				return a1 .. ins .. ins .. a2 ==
					opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
			end),
	})
end

local Rules = {
	Rule(' ', ' ')
		:with_pair(function(opts)
			local pair = opts.line:sub(opts.col - 1, opts.col)
			return vim.tbl_contains({
				bpairs[1][1] .. bpairs[1][2],
				bpairs[2][1] .. bpairs[2][2],
				bpairs[3][1] .. bpairs[3][2],
			}, pair)
		end)
		:with_move(Conds.none())
		:with_cr(Conds.none())
		:with_del(function(opts)
			local col = api.nvim_win_get_cursor(0)[2]
			local context = opts.line:sub(col - 1, col + 2)
			return vim.tbl_contains({
				bpairs[1][1] .. '  ' .. bpairs[1][2],
				bpairs[2][1] .. '  ' .. bpairs[2][2],
				bpairs[3][1] .. '  ' .. bpairs[3][2]
			}, context)
		end),

	Rule('=', '')
		:with_pair(Conds.not_inside_quote())
		:with_pair(function(opts)
			local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
			if last_char:match('[%w%=%s]') then
				return true
			end
			return false
		end)
		:replace_endpair(function(opts)
			local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
			local next_char = opts.line:sub(opts.col, opts.col)
			next_char = next_char == ' ' and '' or ' '
			if prev_2char:match('%w$') then
				return '<bs> =' .. next_char
			end
			if prev_2char:match('%=$') then
				return next_char
			end
			if prev_2char:match('=') then
				return '<bs><bs>=' .. next_char
			end
			return ''
		end)
		:set_end_pair_length(0)
		:with_move(Conds.none())
		:with_del(Conds.none()),

	Rule('=', '')
		:with_pair(Conds.not_inside_quote())
		:with_pair(function(opts)
			local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
			if last_char:match('[%w%=%s]') then
				return true
			end
			return false
		end)
		:replace_endpair(function(opts)
			local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
			local next_char = opts.line:sub(opts.col, opts.col)
			next_char = next_char == ' ' and '' or ' '
			if prev_2char:match('%w$') then
				return '<bs> =' .. next_char
			end
			if prev_2char:match('%=$') then
				return next_char
			end
			if prev_2char:match('=') then
				return '<bs><bs>=' .. next_char
			end
			return ''
		end)
		:set_end_pair_length(0)
		:with_move(Conds.none())
		:with_del(Conds.none()),
}


for _, bracket in next, bpairs do
	table.insert(Rules,
		-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
		Rule(bracket[1] .. ' ', ' ' .. bracket[2])
			:with_pair(Conds.none())
			:with_move(function(opts) return opts.char == bracket[2] end)
			:with_del(Conds.none())
			:use_key(bracket[2])
		-- Removes the trailing whitespace that can occur without this
		-- :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
	)
end

for _, punct in next, { ",", ";" } do
	table.insert(Rules,
		Rule('', punct)
			:with_move(function(opts) return opts.char == punct end)
			:with_pair(function() return false end)
			:with_del(function() return false end)
			:with_cr(function() return false end)
			:use_key(punct)
	)
end

rule2('(', ' ', ')')

Ap.add_rules(Rules)
