---@diagnostic disable:missing-fields

require('user_api.types.user.commands')

---@type User.Commands
local Commands = {}

---@type User.Commands.Spec
Commands.commands = {}

Commands.commands.Redir = {
    function(ctx)
        local set_lines = vim.api.nvim_buf_set_lines
        local exec2 = vim.api.nvim_exec2

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
    { nargs = '+', complete = 'command' },
}

---@param self User.Commands
function Commands:setup()
    local new_cmd = vim.api.nvim_create_user_command

    for cmd, T in next, self.commands do
        new_cmd(cmd, T[1], T[2] or {})
    end
end

return Commands

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
