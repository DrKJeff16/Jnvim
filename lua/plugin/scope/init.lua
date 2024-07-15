---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local maps_t = User.types.user.maps

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local map_dict = User.maps.map_dict

if not exists('scope') then
    return
end

local au_exec = vim.api.nvim_exec_autocmds
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local Scope = require('scope')

local opts = { hooks = {} }

function opts.hooks.pre_tab_leave()
    au_exec('User', { pattern = 'ScopeTabLeavePre' })
    -- [other statements]
end

function opts.hooks.post_tab_enter()
    au_exec('User', { pattern = 'ScopeTabEnterPost' })
    -- [other statements]
end

Scope.setup(opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
