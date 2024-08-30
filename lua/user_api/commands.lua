require('user_api.types.user.commands')
local Check = require('user_api.check')

local new_cmd = vim.api.nvim_create_user_command
local set_lines = vim.api.nvim_buf_set_lines
local exec2 = vim.api.nvim_exec2

---@type User.Commands
---@diagnostic disable-next-line:missing-fields
local M = {}

function M.redir()
    new_cmd('Redir', function(ctx)
        local lines = vim.split(
            exec2(ctx.args, {
                output = true,
            })['output'],
            '\n',
            { plain = true }
        )

        local buf = vim.api.nvim_create_buf(true, true)
        local win = vim.api.nvim_open_win(buf, true, {
            vertical = false,
        })

        set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value('modified', false, { buf = buf })
    end, { nargs = '+', complete = 'command' })
end

function M:setup_commands() self.redir() end

function M.new()
    local self = setmetatable({}, { __index = M })

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
