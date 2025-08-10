---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command
---@field mappings? AllModeMaps

---@alias User.Commands.Spec table<string, User.Commands.CmdSpec>

local Value = require('user_api.check.value')

local desc = require('user_api.maps.kmap').desc
local type_not_empty = Value.type_not_empty

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local copy = vim.deepcopy
local new_cmd = vim.api.nvim_create_user_command
local exec2 = vim.api.nvim_exec2
local set_lines = vim.api.nvim_buf_set_lines

---@class User.Commands
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

            ['<Leader>UCR'] = {
                ':Redir ',
                desc('Prompt to `Redir` command', false),
            },
        },
    },
}

---@param name string
---@param cmd fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command|table
---@param mappings? AllModeMaps
function Commands.add_command(name, cmd, opts, mappings)
    if not type_not_empty('string', name) or cmd == nil then
        error('(user_api.commands:new_command): bad argument(s)', ERROR)
    end

    opts = opts ~= nil and opts or {}

    local cmnd = { cmd, opts }

    if type_not_empty('table', mappings) then
        cmnd.mappings = mappings
    end

    Commands.setup({ [name] = cmnd })
end

function Commands.setup_keys()
    if not type_not_empty('table', Commands.commands) then
        return
    end

    local Keymaps = require('user_api.config.keymaps')

    for _, cmd in next, Commands.commands do
        if type_not_empty('table', cmd.mappings) then
            Keymaps(cmd.mappings)
        end
    end
end

---@param cmds? User.Commands.Spec
function Commands.setup(cmds)
    local is_tbl = Value.is_tbl

    cmds = is_tbl(cmds) and cmds or {}

    Commands.commands = vim.tbl_deep_extend('keep', cmds, copy(Commands.commands))

    for cmd, T in next, Commands.commands do
        local exec, opts = T[1], T[2] or {}
        new_cmd(cmd, exec, opts)
    end

    Commands.setup_keys()
end

---@return table|User.Commands
function Commands.new()
    return setmetatable({}, {
        __index = Commands,
    })
end

return Commands

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
