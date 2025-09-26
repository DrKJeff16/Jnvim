---@alias User.Commands.Spec table<string, User.Commands.CmdSpec>
---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command
---@field mappings? AllModeMaps

local desc = require('user_api.maps').desc
local type_not_empty = require('user_api.check.value').type_not_empty

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
Commands.commands = {
    Redir = {
        function(ctx)
            local lines = vim.split(
                exec2(ctx.args, { output = true })['output'],
                string.char(10), -- `'\n'`
                { plain = true }
            )
            local bufnr = vim.api.nvim_create_buf(true, true)
            open_win(bufnr, true, { vertical = false })
            set_lines(bufnr, 0, -1, false, lines)
            optset('modified', false, { buf = bufnr })
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
    },
}

---@param name string
---@param cmd fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command
---@param mappings? AllModeMaps
function Commands.add_command(name, cmd, opts, mappings)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('name', name, 'string', false)
        vim.validate('cmd', cmd, 'function', false)
        vim.validate('opts', opts, 'table', true, 'vim.api.keyset.user_command')
        vim.validate('mappings', mappings, 'table', true, 'AllModeMaps')
    else
        vim.validate({
            name = { name, 'string' },
            cmd = { cmd, 'function' },
            opts = { opts, { 'table', 'nil' } },
            mappings = { mappings, { 'table', 'nil' } },
        })
    end
    opts = opts or {}

    local cmnd = { cmd, opts } ---@type User.Commands.CmdSpec
    if mappings then
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
        if cmd.mappings and not vim.tbl_isempty(cmd.mappings) then
            Keymaps(cmd.mappings)
        end
    end
end

---@param cmds? User.Commands.Spec
function Commands.setup(cmds)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('cmds', cmds, 'table', true, 'User.Commands.Spec')
    else
        vim.validate({ cmds = { cmds, { 'table', 'nil' } } })
    end
    cmds = cmds or {}

    Commands.commands = d_extend('keep', cmds, copy(Commands.commands))
    for cmd, T in pairs(Commands.commands) do
        local exec = T[1]
        local opts = T[2] or {}
        new_cmd(cmd, exec, opts)
    end
    Commands.setup_keys()
end

---@type User.Commands
local M = setmetatable({}, {
    __index = Commands,
    __newindex = function(_, _, _)
        error('User.Commands table is Read-Only!')
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
