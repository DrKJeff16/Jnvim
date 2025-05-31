---@diagnostic disable:missing-fields

require('user_api.types.user.opts')

local Value = require('user_api.check.value')
local Exists = require('user_api.check.exists')

local is_nil = Value.is_nil
local is_str = Value.is_str
local is_tbl = Value.is_tbl
local is_bool = Value.is_bool
local empty = Value.empty
local in_console = require('user_api.check').in_console

---@type User.Opts
---@diagnostic disable-next-line:missing-fields
local Opts = {}

Opts.ALL_OPTIONS = require('user_api.opts.all_opts')

---@type User.Opts.Spec
Opts.DEFAULT_OPTIONS = require('user_api.opts.config')

---@type User.Opts.Spec
Opts.options = {}

---@param T User.Opts.Spec
---@return User.Opts.Spec parsed_opts, string msg
local function long_opts_convert(T)
    ---@type User.Opts.Spec
    local parsed_opts = {}
    local msg = ''

    if not is_tbl(T) or empty(T) then
        return parsed_opts, msg
    end

    local nwl = newline or string.char(10)

    local insp = inspect or vim.inspect

    ---@type string[]
    local keys = vim.tbl_keys(Opts.ALL_OPTIONS)
    table.sort(keys)

    for opt, val in next, T do
        local new_opt = ''

        -- If neither long nor short (known) option, append to warning message
        if not (vim.tbl_contains(keys, opt) or Value.tbl_values({ opt }, Opts.ALL_OPTIONS)) then
            msg = msg .. '- Option ' .. insp(opt) .. 'not valid' .. nwl
        elseif vim.tbl_contains(keys, opt) then
            parsed_opts[opt] = val
        else
            new_opt = Value.tbl_values({ opt }, Opts.ALL_OPTIONS, true)
            if is_str(new_opt) and new_opt ~= '' then
                parsed_opts[new_opt] = val
            else
                msg = nwl .. msg .. '- Option `' .. insp(opt) .. '` not valid'
            end
        end
    end

    return parsed_opts, msg
end

--- Option setter for the aforementioned options dictionary
--- @param T User.Opts.Spec A dictionary with keys acting as `vim.opt` fields, and values
--- for each option respectively
function Opts.optset(T)
    local notify = require('user_api.util.notify').notify

    T = is_tbl(T) and T or {}

    local opts = long_opts_convert(T)
    local msg = ''

    for k, v in next, opts do
        if is_nil(vim.opt[k]) then
            msg = msg .. 'Option `' .. k .. '` is not a valid field for `vim.opt`'
        elseif type(vim.opt[k]:get()) == type(v) then
            vim.opt[k] = v
            Opts.options[k] = v
        else
            msg = msg .. 'Option `' .. k .. '` could not be parsed'
        end
    end

    if msg ~= '' then
        vim.schedule(
            function()
                notify(msg, 'error', {
                    animate = false,
                    hide_from_history = false,
                    timeout = 1750,
                    title = 'user_api.opts.optset',
                })
            end
        )
    end
end

---@param self User.Opts
---@param override? User.Opts.Spec A table with custom options
---@param verbose? boolean Flag to make the function return a string with invalid values, if any
function Opts:setup(override, verbose)
    local notify = require('user_api.util.notify').notify
    local insp = inspect or vim.inspect

    override = is_tbl(override) and override or {}
    verbose = is_bool(verbose) and verbose or false

    local parsed_opts, msg = long_opts_convert(override)

    ---@type table|vim.wo|vim.bo
    local opts = vim.tbl_deep_extend('keep', parsed_opts, self.DEFAULT_OPTIONS)

    self.optset(opts)

    if msg ~= '' then
        vim.schedule(
            function()
                notify(msg, 'warn', {
                    animate = false,
                    hide_from_history = false,
                    timeout = 1750,
                    title = '(user_api.opts:setup)',
                })
            end
        )
    end

    if verbose then
        vim.schedule(
            function()
                notify(insp(opts), 'warn', {
                    animate = false,
                    hide_from_history = false,
                    timeout = 1750,
                    title = '(user_api.opts:setup)',
                })
            end
        )
    end
end

function Opts.print_set_opts()
    local notify = require('user_api.util.notify').notify

    local msg = (inspect or vim.inspect)(Opts.options)

    notify(msg, 'info', {
        animate = true,
        hide_from_history = true,
        timeout = 3500,
        title = '(user_api.opts.print_set_opts)',
    })
end

---@param self User.Opts
function Opts:setup_maps()
    local desc = require('user_api.maps.kmap').desc
    local wk_avail = require('user_api.maps.wk').available
    local map_dict = require('user_api.maps').map_dict

    if wk_avail() then
        map_dict({
            ['<leader>UO'] = { group = '+Options' },
        }, 'wk.register', false, 'n')
    end
    map_dict({
        ['<leader>UOl'] = { self.print_set_opts, desc('Print Set Vim Options') },
    }, 'wk.register', false, 'n')
end

return Opts

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
