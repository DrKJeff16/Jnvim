local MODSTR = 'user_api.opts'

local validate = vim.validate

local Value = require('user_api.check.value')

local is_str = Value.is_str
local is_bool = Value.is_bool
local type_not_empty = Value.type_not_empty

local deep_extend = vim.tbl_deep_extend
local in_list = vim.list_contains
local copy = vim.deepcopy

local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO

---@class User.Opts
local Opts = {}

---@return User.Opts.AllOpts
function Opts.get_all_opts()
    return require('user_api.opts.all_opts')
end

---@param ArgLead string
---@param CursorPos integer
local function complete_fun(ArgLead, _, CursorPos)
    local len = ArgLead:len()
    local CMD_LEN = ('OptsToggle '):len() + 1

    if len == 0 or CursorPos < CMD_LEN then
        return Opts.toggleable
    end

    ---@type string[]
    local valid = {}
    for _, o in ipairs(Opts.toggleable) do
        if o:match(ArgLead) ~= nil and o:find('^' .. ArgLead) then
            table.insert(valid, o)
        end
    end

    return valid
end

---@return string[] valid
function Opts.gen_toggleable()
    ---@type string[]
    local valid = {}

    local T = Opts.get_all_opts()

    ---@type string[], string[]
    local long, short = vim.tbl_keys(T), vim.tbl_values(T)

    for _, opt in ipairs(long) do
        local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })

        if type(value) == 'boolean' or in_list({ 'no', 'yes' }, value) then
            table.insert(valid, opt)
        end
    end
    for _, opt in ipairs(short) do
        if opt ~= '' then
            local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })

            if type(value) == 'boolean' or in_list({ 'no', 'yes' }, value) then
                table.insert(valid, opt)
            end
        end
    end

    table.sort(valid)

    return valid
end

Opts.toggleable = Opts.gen_toggleable()

---@return User.Opts.Spec
function Opts.get_defaults()
    return require('user_api.opts.config')
end

---@type User.Opts.Spec
Opts.options = {}

---@param T User.Opts.Spec
---@param verbose? boolean
---@return User.Opts.Spec parsed_opts
function Opts.long_opts_convert(T, verbose)
    ---@type User.Opts.Spec, string
    local parsed_opts, msg = {}, ''

    verbose = is_bool(verbose) and verbose or false

    ---@type string
    local verb_str = ''

    if not type_not_empty('table', T) then
        if verbose then
            vim.notify('(user.opts.long_opts_convert): All seems good', INFO)
        end
        return parsed_opts
    end

    local ALL_OPTIONS = Opts.get_all_opts()

    ---@type string[]
    local keys = vim.tbl_keys(ALL_OPTIONS)
    table.sort(keys)

    for opt, val in pairs(T) do
        -- If neither long nor short (known) option, append to warning message
        if not (in_list(keys, opt) or Value.tbl_values({ opt }, ALL_OPTIONS)) then
            msg = ('%s- Option `%s` not valid!\n'):format(msg, opt)
        elseif in_list(keys, opt) then
            parsed_opts[opt] = val
        else
            local new_opt = Value.tbl_values({ opt }, ALL_OPTIONS, true)
            if is_str(new_opt) and new_opt ~= '' then
                parsed_opts[new_opt] = val
                verb_str = ('%s%s ==> %s\n'):format(verb_str, opt, new_opt)
            else
                msg = ('%s- Option `%s` non valid!\n'):format(msg, new_opt)
            end
        end
    end

    if msg ~= nil and msg ~= '' then
        vim.notify(msg, ERROR)
    end

    if verbose and verb_str ~= nil and verb_str ~= '' then
        vim.notify(verb_str, INFO)
    end

    return parsed_opts
end

--- Option setter for the aforementioned options dictionary.
--- ---
--- @param O User.Opts.Spec A dictionary with keys acting as `vim.o` fields, and values
--- @param verbose? boolean Enable verbose printing if `true`
function Opts.optset(O, verbose)
    validate('O', O, 'table', false, 'User.Opts.Spec')
    validate('verbose', verbose, 'boolean', true)
    verbose = verbose ~= nil and verbose or false

    local insp = vim.inspect
    local curr_buf = vim.api.nvim_get_current_buf

    if not vim.api.nvim_get_option_value('modifiable', { buf = curr_buf() }) then
        return
    end

    local msg, verb_msg = '', ''
    local opts = Opts.long_opts_convert(O, verbose)

    for k, v in pairs(opts) do
        if type(vim.o[k]) == type(v) then
            Opts.options[k] = v
            vim.o[k] = Opts.options[k]
            verb_msg = ('%s- %s: %s\n'):format(verb_msg, k, insp(v))
        end
    end

    if msg ~= '' then
        vim.notify(msg, ERROR)
        return
    end

    if verbose then
        vim.notify(verb_msg, INFO)
    end
end

---Set up `guicursor` so that cursor blinks.
--- ---
function Opts.set_cursor_blink()
    if require('user_api.check').in_console() then
        return
    end

    Opts.optset({
        guicursor = 'n-v-c:block'
            .. ',i-ci-ve:ver25'
            .. ',r-cr:hor20'
            .. ',o:hor50'
            .. ',a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
            .. ',sm:block-blinkwait175-blinkoff150-blinkon175',
    })
end

function Opts.print_set_opts()
    local T = copy(Opts.options)
    table.sort(T)
    vim.notify(vim.inspect(T), INFO)
end

---@param O string[]|string
---@param verbose? boolean
function Opts.toggle(O, verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        validate('O', O, { 'string', 'table' }, false, 'string[]|string')
        validate('verbose', verbose, 'boolean', true)
    else
        validate({
            O = { O, { 'string', 'table' } },
            verbose = { verbose, { 'boolean', 'nil' } },
        })
    end
    verbose = verbose ~= nil and verbose or false

    ---@cast O string
    if is_str(O) then
        O = { O }
    end

    ---@cast O string[]
    if vim.tbl_isempty(O) then
        return
    end

    for _, opt in ipairs(O) do
        if in_list(Opts.toggleable, opt) then
            local value = vim.o[opt]

            if is_bool(value) then
                value = not value
            else
                value = value == 'yes' and 'no' or 'yes'
            end

            Opts.optset({ [opt] = value }, verbose)
        end
    end
end

function Opts.setup_cmds()
    local Commands = require('user_api.commands')

    Commands.add_command('OptsToggle', function(ctx)
        local cmds = {}
        for _, v in ipairs(ctx.fargs) do
            if not (in_list(Opts.toggleable, v) or ctx.bang) then
                error(('(OptsToggle): Cannot toggle option `%s`, aborting'):format(v), ERROR)
            end

            if in_list(Opts.toggleable, v) and not in_list(cmds, v) then
                table.insert(cmds, v)
            end
        end

        Opts.toggle(cmds, ctx.bang)
    end, {
        nargs = '+',
        complete = complete_fun,
        bang = true,
        desc = 'Toggle toggleable Vim Options',
    })
end

function Opts.setup_maps()
    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps').desc

    Keymaps({
        n = {
            ['<leader>UO'] = { group = '+Options' },

            ['<leader>UOl'] = {
                Opts.print_set_opts,
                desc('Print options set by `user.opts`'),
            },

            ['<leader>UOT'] = {
                ':OptsToggle ',
                desc('Prompt To Toggle Opts', false),
            },
        },
    })
end

---@return User.Opts|fun(override?: User.Opts.Spec, verbose?: boolean)
function Opts.new()
    return setmetatable(Opts, {
        __index = Opts,

        __newindex = function(_, _, _)
            error(('(%s): This module is read only!'):format(MODSTR), ERROR)
        end,

        ---@param self User.Opts
        ---@param override? User.Opts.Spec A table with custom options
        ---@param verbose? boolean Flag to make the function return a string with invalid values, if any
        __call = function(self, override, verbose)
            if vim.fn.has('nvim-0.11') == 1 then
                validate('override', override, 'table', true, 'User.Opts.Spec')
                validate('verbose', verbose, 'boolean', true)
            else
                validate({
                    override = { override, { 'table', 'nil' } },
                    verbose = { verbose, { 'boolean', 'nil' } },
                })
            end
            override = override or {}
            verbose = verbose ~= nil and verbose or false

            local defaults = Opts.get_defaults()

            if not type_not_empty('table', self.options) then
                self.options = Opts.long_opts_convert(defaults, verbose)
            end

            local parsed_opts = Opts.long_opts_convert(override, verbose)

            ---@type vim.bo|vim.wo
            Opts.options = deep_extend('keep', parsed_opts, self.options)

            Opts.optset(Opts.options, verbose)
        end,
    })
end

return Opts.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
