---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('scope') then
	return
end

local au_exec = vim.api.nvim_exec_autocmds

local Scope = require('scope')

local opts = { hooks = {} }

if exists('barbar') then
	function opts.hooks.pre_tab_leave()
		au_exec('User', { pattern = 'ScopeTabLeavePre' })
      	-- [other statements]
	end

	function opts.hooks.post_tab_enter()
		au_exec('User', { pattern = 'ScopeTabEnterPost' })
      	-- [other statements]
	end
end

Scope.setup(opts)
