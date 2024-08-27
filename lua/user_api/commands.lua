require('user_api.types.user.commands')
local Check = require('user_api.check')
local Util = require('user_api.util')

local new_cmd = vim.api.nvim_create_user_command
local set_lines = vim.api.nvim_buf_set_lines
local exec = vim.api.nvim_exec
local exec2 = vim.api.nvim_exec2

---@type User.Commands
---@diagnostic disable-next-line:missing-fields
local M = {}

function M.redir()
    local lopt = vim.opt_local

    new_cmd('Redir', function(ctx)
        local lines = vim.split(exec(ctx.args, true), '\n', { plain = true })

        vim.cmd.new()

        set_lines(0, 0, -1, false, lines)
        vim.opt_local.modified = false
    end, { nargs = '+', complete = 'command' })
end

function M:setup_commands() self.redir() end

function M.new()
    local self = setmetatable({}, { __index = M })

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
