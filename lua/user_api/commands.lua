---@diagnostic disable:missing-fields

---@module 'user_api.types.user.commands')

local desc = require('user_api.maps.kmap').desc

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

    mappings = {
        n = {
            ['<Leader>UC'] = { group = '+Commands' },
            ['<Leader>UCR'] = { ':Redir ', desc('Prompt to `Redir` command', false, nil, true) },
        },
    },
}

---@param self User.Commands
function Commands:setup()
    local new_cmd = vim.api.nvim_create_user_command

    for cmd, T in next, self.commands do
        new_cmd(cmd, T[1], T[2] or {})
    end

    vim.g.user_api_commans_setup = 1
end

---@param self User.Commands
function Commands:setup_keys()
    local Value = require('user_api.check.value')
    local is_nil = Value.is_nil
    local is_int = Value.is_int
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    local abort = not (is_int(vim.g.user_api_commans_setup) and vim.g.user_api_commans_setup == 1)

    if abort then
        return
    end

    local Keymaps = require('config.keymaps')

    for _, cmd in next, self.commands do
        if is_nil(cmd.mappings) or not is_tbl(cmd.mappings) or empty(cmd.mappings) then
            goto continue
        end

        Keymaps:setup(cmd.mappings)

        ::continue::
    end
end

return Commands

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
