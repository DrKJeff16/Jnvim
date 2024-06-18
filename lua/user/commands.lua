---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.commands')
local Check = require('user.check')
local Util = require('user.util')

local new_cmd = vim.api.nvim_create_user_command
local set_lines = vim.api.nvim_buf_set_lines
local exec = vim.api.nvim_exec
local exec2 = vim.api.nvim_exec2

---@type User.UserCommands
local M = {}

function M.redir()
    local api = vim.api
    local lopt = vim.opt_local

    new_cmd('Redir', function(ctx)
        local lines = vim.split(exec(ctx.args, true), '\n', { plain = true })

        vim.cmd.new()

        set_lines(0, 0, -1, false, lines)
        vim.lopt.modified = false
    end, { nargs = '+', complete = 'command' })
end

function M.setup_commands(self)
    self.redir()
end

function M.new()
    local self = setmetatable({}, { __index = M })

    return self
end

return M
