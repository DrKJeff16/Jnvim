---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

local api = vim.api
local keymap = vim.keymap

local kmap = keymap.set
local map = api.nvim_set_keymap
local bmap = api.nvim_buf_set_keymap

---@type UserMaps
local M = {
	kmap = {
		n = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			kmap('n', lhs, rhs, opts)
		end,
		i = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			kmap('i', lhs, rhs, opts)
		end,
		t = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			kmap('t', lhs, rhs, opts)
		end,
		v = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			kmap('v', lhs, rhs, opts)
		end,
	},
	map = {
		n = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('n', lhs, rhs, opts)
		end,
		i = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('i', lhs, rhs, opts)
		end,
		t = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('t', lhs, rhs, opts)
		end,
		v = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('v', lhs, rhs, opts)
		end,
		o = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('o', lhs, rhs, opts)
		end,
		x = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			map('x', lhs, rhs, opts)
		end,
	},
	buf_map = {
		n = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 'n', lhs, rhs, opts)
		end,
		i = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 'i', lhs, rhs, opts)
		end,
		t = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 't', lhs, rhs, opts)
		end,
		v = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 'v', lhs, rhs, opts)
		end,
		o = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 'o', lhs, rhs, opts)
		end,
		x = function(lhs, rhs, opts)
			opts = opts or {}

			if not opts.noremap then
				opts.noremap = true
			end
			if not opts.nowait then
				opts.nowait = true
			end
			if not opts.silent then
				opts.silent = true
			end

			bmap(0, 'x', lhs, rhs, opts)
		end,
	},
}

return M
