require('user_api.types.user.commands')

local new_cmd = vim.api.nvim_create_user_command
local set_lines = vim.api.nvim_buf_set_lines
local exec2 = vim.api.nvim_exec2

---@type User.Commands
---@diagnostic disable-next-line:missing-fields
local M = {}

---@type User.Commands.Spec
---@diagnostic disable-next-line:missing-fields
M.commands = {}

M.commands['Redir'] = {
    [1] = function(ctx)
        local lines = vim.split(
            exec2(ctx.args, {
                output = true,
            })['output'],
            newline or string.char(10), -- `'\n'`
            { plain = true }
        )

        local buf = vim.api.nvim_create_buf(true, true)
        local win = vim.api.nvim_open_win(buf, true, {
            vertical = false,
        })

        set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value('modified', false, { buf = buf })
    end,
    [2] = { nargs = '+', complete = 'command' },
}

function M:setup_commands()
    for cmd, T in next, self.commands do
        new_cmd(cmd, T[1], T[2] or {})
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
