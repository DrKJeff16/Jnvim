---@diagnostic disable:missing-fields

---@module 'user_api.types.commands'

local Value = require('user_api.check.value')

local desc = require('user_api.maps.kmap').desc
local is_nil = Value.is_nil
local is_str = Value.is_str
local empty = Value.empty

local new_cmd = vim.api.nvim_create_user_command
local exec2 = vim.api.nvim_exec2
local set_lines = vim.api.nvim_buf_set_lines

---@type User.Commands
local Commands = {}

---@type User.Commands.Spec
Commands.commands = {}

Commands.commands.Redir = {
    function(ctx)
        local lines = vim.split(
            exec2(ctx.args, { output = true })['output'],
            newline or string.char(10), -- `'\n'`
            { plain = true }
        )

        local buf = vim.api.nvim_create_buf(true, true)
        local win = vim.api.nvim_open_win(buf, true, { vertical = false })

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
---@param name string
---@param C User.Commands.CtxSpec|table
function Commands:new_command(name, C)
    if is_nil({ name, C }, true) or empty({ name, C }, true) then
        error('(user_api.commands:new_command): nil/empty argument(s)')
    end

    if not is_str(name) then
        error('(user_api.commands:new_command): Invalid command name')
    end

    self.commands[name] = C

    self:setup()
end

---@param self User.Commands
function Commands:setup()
    for cmd, T in next, self.commands do
        local ok, _ = pcall(new_cmd, cmd, T[1], T[2] or {})

        if not ok then
            vim.notify('Bad command: `' .. cmd .. '`', vim.log.levels.WARN)
        end
    end

    vim.g.user_api_commans_setup = 1
end

---@param self User.Commands
function Commands:setup_keys()
    local is_int = Value.is_int
    local is_tbl = Value.is_tbl

    local abort = not (is_int(vim.g.user_api_commans_setup) and vim.g.user_api_commans_setup == 1)

    if abort then
        return
    end

    local Keymaps = require('user_api.config.keymaps')

    for _, cmd in next, self.commands do
        if is_nil(cmd.mappings) or not is_tbl(cmd.mappings) or empty(cmd.mappings) then
            goto continue
        end

        Keymaps(cmd.mappings)

        ::continue::
    end
end

return Commands

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
