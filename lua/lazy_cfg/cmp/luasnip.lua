---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('luasnip') then
	return
end

local api = vim.api

local types = require('luasnip.util.types')
local ls = require('luasnip')
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local node_util = require('luasnip.nodes.util')
local util = require('luasnip.util.util')
local Fmt = require('luasnip.extras.fmt')
local conds = require('luasnip.extras.expand_conditions')
local PFix = require('luasnip.extras.postfix')
local parser = require('luasnip.util.parser')
local key_indexer = require('luasnip.nodes.key_indexer')

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local ms = ls.multi_snippet
local Config = ls.config
local l = extras.lambda

local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = Fmt.fmt
local fmta = Fmt.fmta
local postfix = PFix.postfix
local parse = parser.parse_snippet
local k = key_indexer.new_key

if exists('luasnip.loaders.from_vscode') then
	require('luasnip.loaders.from_vscode').lazy_load()
end

local function char_count_same(c1, c2)
	local line = api.nvim_get_current_line()
	-- '%'-escape chars to force explicit match (gsub accepts patterns).
	-- second return value is number of substitutions.
	local _, ct1 = string.gsub(line, '%' .. c1, '')
	local _, ct2 = string.gsub(line, '%' .. c2, '')
	return ct1 == ct2
end

local function even_count(count)
	local line = api.nvim_get_current_line()
	local _, ct = string.gsub(line, count, '')
	return ct % 2 == 0
end

---@type fun(fn: fun(...), ...): boolean
local function neg(fn, ...)
	return not fn(...)
end

---@type fun(fn: fun(...), ...): fun(): any
local function part(fn, ...)
	local args = { ... }
	return function()
		return fn(unpack(args))
	end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
	-- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
	-- ... is used to pass any args following the expand_func to it.
	return s({
		trig = pair_begin,
		wordTrig = false,
	}, {
		t({ pair_begin }),
		i(1),
		t({ pair_end }),
	}, {
		condition = part(expand_func, part(..., pair_begin, pair_end)),
	})
end

-- these should be inside your snippet-table.
pair('(', ')', neg, char_count_same)
pair('{', '}', neg, char_count_same)
pair('[', ']', neg, char_count_same)
pair('<', '>', neg, char_count_same)
pair("'", "'", neg, even_count)
pair('"', '"', neg, even_count)
pair('`', '`', neg, even_count)

Config.setup({
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { '●' } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { '●' } },
			},
		},
	},
	parser_nested_assembler = function(_, snippetNode)
		local select = function(snip, no_move, dry_run)
			if dry_run then
				return
			end
			snip:focus()
			-- make sure the inner nodes will all shift to one side when the
			-- entire text is replaced.
			snip:subtree_set_rgrav(true)
			-- fix own extmark-gravities, subtree_set_rgrav affects them as well.
			snip.mark:set_rgravs(false, true)

			-- SELECT all text inside the snippet.
			if not no_move then
				api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
				node_util.select_node(snip)
			end
		end

		local original_extmarks_valid = snippetNode.extmarks_valid
		function snippetNode:extmarks_valid()
			-- the contents of this snippetNode are supposed to be deleted, and
			-- we don't want the snippet to be considered invalid because of
			-- that -> always return true.
			return true
		end

		function snippetNode:init_dry_run_active(dry_run)
			if dry_run and dry_run.active[self] == nil then
				dry_run.active[self] = self.active
			end
		end

		function snippetNode:is_active(dry_run)
			return (not dry_run and self.active) or (dry_run and dry_run.active[self])
		end

		function snippetNode:jump_into(dir, no_move, dry_run)
			self:init_dry_run_active(dry_run)
			if self:is_active(dry_run) then
				-- inside snippet, but not selected.
				if dir == 1 then
					self:input_leave(no_move, dry_run)
					return self.next:jump_into(dir, no_move, dry_run)
				else
					select(self, no_move, dry_run)
					return self
				end
			else
				-- jumping in from outside snippet.
				self:input_enter(no_move, dry_run)
				if dir == 1 then
					select(self, no_move, dry_run)
					return self
				else
					return self.inner_last:jump_into(dir, no_move, dry_run)
				end
			end
		end

		-- this is called only if the snippet is currently selected.
		function snippetNode:jump_from(dir, no_move, dry_run)
			if dir == 1 then
				if original_extmarks_valid(snippetNode) then
					return self.inner_first:jump_into(dir, no_move, dry_run)
				else
					return self.next:jump_into(dir, no_move, dry_run)
				end
			else
				self:input_leave(no_move, dry_run)
				return self.prev:jump_into(dir, no_move, dry_run)
			end
		end

		return snippetNode
	end,
})

local current_nsid = api.nvim_create_namespace('LuaSnipChoiceListSelections')
local current_win = nil

local function window_for_choiceNode(choiceNode)
	local buf = api.nvim_create_buf(false, true)
	local buf_text = {}
	local row_selection = 0
	local row_offset = 0
	local text
	for _, node in ipairs(choiceNode.choices) do
		text = node:get_docstring()
		-- find one that is currently showing
		if node == choiceNode.active_choice then
			-- current line is starter from buffer list which is length usually
			row_selection = #buf_text
			-- finding how many lines total within a choice selection
			row_offset = #text
		end
		vim.list_extend(buf_text, text)
	end

	api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
	local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

	-- adding highlight so we can see which one is been selected.
	local extmark = api.nvim_buf_set_extmark(
		buf,
		current_nsid,
		row_selection,
		0,
		{ hl_group = 'incsearch', end_line = row_selection + row_offset }
	)

	-- shows window at a beginning of choiceNode.
	local win = api.nvim_open_win(buf, false, {
		relative = 'win',
		width = w,
		height = h,
		bufpos = choiceNode.mark:pos_begin_end(),
		style = 'minimal',
		border = 'rounded',
	})

	-- return with 3 main important so we can use them again
	return { win_id = win, extmark = extmark, buf = buf }
end

function choice_popup(choiceNode)
	-- build stack for nested choiceNodes.
	if current_win then
		api.nvim_win_close(current_win.win_id, true)
		api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	end
	local create_win = window_for_choiceNode(choiceNode)
	current_win = {
		win_id = create_win.win_id,
		prev = current_win,
		node = choiceNode,
		extmark = create_win.extmark,
		buf = create_win.buf,
	}
end

local function update_choice_popup(choiceNode)
	api.nvim_win_close(current_win.win_id, true)
	api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	local create_win = window_for_choiceNode(choiceNode)
	current_win.win_id = create_win.win_id
	current_win.extmark = create_win.extmark
	current_win.buf = create_win.buf
end

local function choice_popup_close()
	api.nvim_win_close(current_win.win_id, true)
	api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	-- now we are checking if we still have previous choice we were in after exit nested choice
	current_win = current_win.prev
	if current_win then
		-- reopen window further down in the stack.
		local create_win = window_for_choiceNode(current_win.node)
		current_win.win_id = create_win.win_id
		current_win.extmark = create_win.extmark
		current_win.buf = create_win.buf
	end
end

vim.cmd([[
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua choice_popup_close()
au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
augroup END
]])

return ls
