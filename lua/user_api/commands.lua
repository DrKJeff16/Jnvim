---@diagnostic disable:missing-fields

---@alias CtxFun fun(ctx: table)
---@alias User.Commands.Mappings AllModeMaps

---@class User.Commands.CtxSpec
---@field [1] CtxFun
---@field [2] vim.api.keyset.user_command
---@field mappings? User.Commands.Mappings

---@alias User.Commands.Spec table<string, User.Commands.CtxSpec>

---@class User.Commands
---@field commands User.Commands.Spec
---@field new_command fun(self: User.Commands, name: string, C: table|User.Commands.CtxSpec)
---@field setup fun(self: User.Commands)
---@field setup_keys fun()
---@field new fun(O: table?): table|User.Commands

local Value = require('user_api.check.value')

local desc = require('user_api.maps.kmap').desc
local type_not_empty = Value.type_not_empty

local WARN = vim.log.levels.WARN

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
            string.char(10), -- `'\n'`
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
    if not (type_not_empty('string', name) or type_not_empty('table', C)) then
        error('(user_api.commands:new_command): nil/empty argument(s)')
    end

    self.commands[name] = C

    self:setup()
end

---@param self User.Commands
function Commands:setup()
    for cmd, T in next, self.commands do
        local ok, _ = pcall(new_cmd, cmd, T[1], T[2] or {})

        if not ok then
            vim.notify(string.format('Bad command: `%s`', cmd), WARN)
        end
    end

    vim.g.user_api_commans_setup = 1
end

function Commands.setup_keys()
    local is_int = Value.is_int

    -- HACK: Had to force this to be casted as a boolean
    local abort = not (is_int(vim.g.user_api_commans_setup) and vim.g.user_api_commans_setup == 1)

    if abort then
        return
    end

    local Keymaps = require('user_api.config.keymaps')

    for _, cmd in next, Commands.commands do
        if not type_not_empty('table', cmd.mappings) then
            goto continue
        end

        Keymaps(cmd.mappings)

        ::continue::
    end
end

---@param O? table
---@return table|User.Commands
function Commands.new(O)
    local is_tbl = Value.is_tbl
    O = is_tbl(O) and O or {}

    return setmetatable(O, {
        __index = Commands,
    })
end

return Commands

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
