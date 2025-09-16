---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command
---@field mappings? AllModeMaps

---@alias User.Commands.Spec table<string, User.Commands.CmdSpec>

local Value = require('user_api.check.value')

local desc = require('user_api.maps').desc
local type_not_empty = Value.type_not_empty

local validate = vim.validate
local copy = vim.deepcopy
local d_extend = vim.tbl_deep_extend
local new_cmd = vim.api.nvim_create_user_command
local exec2 = vim.api.nvim_exec2
local set_lines = vim.api.nvim_buf_set_lines
local open_win = vim.api.nvim_open_win
local optset = vim.api.nvim_set_option_value

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

        open_win(buf, true, { vertical = false })
        set_lines(buf, 0, -1, false, lines)

        optset('modified', false, { buf = buf })
    end,
    {
        nargs = '+',
        complete = 'command',
    },

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
---@param opts? vim.api.keyset.user_command
---@param mappings? AllModeMaps
function Commands.add_command(name, cmd, opts, mappings)
    validate('name', name, 'string', false)
    validate(
        'cmd',
        cmd,
        'function',
        false,
        'fun(ctx?: vim.api.keyset.create_user_command.command_args)'
    )
    validate('opts', opts, 'table', true, 'vim.api.keyset.user_command')
    validate('mappings', mappings, 'table', true, 'AllModeMaps')
    opts = opts or {}

    local cmnd = { cmd, opts }

    if mappings ~= nil then
        cmnd.mappings = mappings
    end

    Commands.setup({ [name] = cmnd })
end

function Commands.setup_keys()
    if not type_not_empty('table', Commands.commands) then
        return
    end

    local Keymaps = require('user_api.config.keymaps')

    for _, cmd in pairs(Commands.commands) do
        if type_not_empty('table', cmd.mappings) then
            Keymaps(cmd.mappings)
        end
    end
end

---@param cmds? User.Commands.Spec
function Commands.setup(cmds)
    validate('cmds', cmds, 'table', true, 'User.Commands.Spec')
    cmds = cmds or {}

    Commands.commands = d_extend('keep', cmds, copy(Commands.commands))

    for cmd, T in pairs(Commands.commands) do
        local exec, opts = T[1], T[2] or {}
        new_cmd(cmd, exec, opts)
    end

    Commands.setup_keys()
end

return setmetatable({}, {
    __index = Commands,

    __newindex = function(_, _, _)
        error('User.Commands table is Read-Only!')
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
