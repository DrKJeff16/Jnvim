---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local exists = User.exists

if not exists('scope') then
	return
end

local api = vim.api

local au_exec = api.nvim_exec_autocmds

local Scope = require('scope')

local opts = {}

if exists('barbar') then
	function opts.pre_tab_leave()
		au_exec('User', { pattern = 'ScopeTabLeavePre' })
      	-- [other statements]
	end

	function opts.post_tab_enter()
		au_exec('User', { pattern = 'ScopeTabEnterPost' })
      	-- [other statements]
	end
end

Scope.setup(opts)
