---@diagnostic disable:missing-fields

---@module 'user_api.opts.config'
---@module 'user_api.opts.all_opts'

-- Set the following options (keys are `vim.opt[k]`-like)
---@alias User.Opts.CallerFun fun(override: table|User.Opts.Spec?, verbose: boolean?)

local Value = require('user_api.check.value')

local is_str = Value.is_str
local is_tbl = Value.is_tbl
local is_bool = Value.is_bool
local type_not_empty = Value.type_not_empty

local deep_extend = vim.tbl_deep_extend
local in_tbl = vim.tbl_contains
local copy = vim.deepcopy

local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO

---@class User.Opts
---@field optset fun(opts: User.Opts.Spec, verbose: boolean?)
---@field toggleable string[]
---@field long_opts_convert fun(T: User.Opts.Spec, verbose: boolean?): parsed_opts: User.Opts.Spec
---@field get_all_opts fun(): User.Opts.AllOpts
---@field get_defaults fun(): User.Opts.Spec
---@field options User.Opts.Spec
---@field print_set_opts fun()
---@field setup_keys fun()
---@field toggle fun(O: string[]|string)
---@field new fun(O: table?):table|User.Opts|User.Opts.CallerFun
local Opts = {}

---@return User.Opts.AllOpts
function Opts.get_all_opts()
    return require('user_api.opts.all_opts')
end

---@param T User.Opts.AllOpts
---@return string[]
local function gen_toggleable(T)
    T = type_not_empty('table', T) and T or Opts.get_all_opts()

    local long = vim.tbl_keys(T)
    local short = vim.tbl_values(T)

    ---@type string[]|table
    local valid = {}

    for _, opt in next, long do
        local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })

        if type(value) == 'boolean' or in_tbl({ 'no', 'yes' }, value) then
            table.insert(valid, opt)
        end
    end
    for _, opt in next, short do
        if opt == '' then
            goto continue
        end

        local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })

        if type(value) == 'boolean' or in_tbl({ 'no', 'yes' }, value) then
            table.insert(valid, opt)
        end

        ::continue::
    end

    table.sort(valid)

    return valid
end

Opts.toggleable = gen_toggleable(Opts.get_all_opts())

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
    ---@type User.Opts.Spec
    local parsed_opts = {}

    ---@type string
    local msg = ''

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

    for opt, val in next, T do
        local new_opt = ''

        -- If neither long nor short (known) option, append to warning message
        if not (in_tbl(keys, opt) or Value.tbl_values({ opt }, ALL_OPTIONS)) then
            msg = string.format('%s- Option `%s` not valid!\n', msg, opt)
        elseif in_tbl(keys, opt) then
            parsed_opts[opt] = val
        else
            new_opt = Value.tbl_values({ opt }, ALL_OPTIONS, true)
            if is_str(new_opt) and new_opt ~= '' then
                parsed_opts[new_opt] = val
                verb_str = string.format('%s%s ==> %s\n', verb_str, opt, new_opt)
            else
                msg = string.format('%s- Option `%s` non valid!\n', msg, new_opt)
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

--- Option setter for the aforementioned options dictionary
--- @param O User.Opts.Spec A dictionary with keys acting as `vim.opt` fields, and values
--- @param verbose? boolean
--- for each option respectively
function Opts.optset(O, verbose)
    local insp = inspect or vim.inspect
    local curr_buf = vim.api.nvim_get_current_buf

    O = is_tbl(O) and O or {}
    verbose = is_bool(verbose) and verbose or false

    if not vim.api.nvim_get_option_value('modifiable', { buf = curr_buf() }) then
        return
    end

    local opts = Opts.long_opts_convert(O, verbose)

    local msg = ''
    local verb_msg = ''

    for k, v in next, opts do
        if type(vim.opt[k]:get()) == type(v) then
            Opts.options[k] = v
            vim.opt[k] = Opts.options[k]
            verb_msg = string.format('%s- %s: %s\n', verb_msg, k, insp(v))
        else
            msg = string.format('%sOption `%s` is not a valid field for `vim.opt`\n', msg, k)
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

function Opts.print_set_opts()
    local T = copy(Opts.options)
    table.sort(T)
    vim.notify((inspect or vim.inspect)(T), INFO)
end

---@param O string[]|string
function Opts.toggle(O)
    if is_str(O) then
        O = { O }
    end

    if not type_not_empty('table', O) then
        return
    end

    local toggleables = Opts.toggleable

    for _, opt in next, O do
        if not in_tbl(toggleables, opt) then
            goto continue
        end

        local _option = vim.opt[opt]
        local value = _option:get()

        if is_bool(value) then
            value = not value
        else
            value = value == 'yes' and 'no' or 'yes'
        end

        Opts.optset({ [opt] = value })

        ::continue::
    end
end

function Opts.setup_keys()
    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps.kmap').desc

    Keymaps({
        n = {
            ['<leader>UO'] = { group = '+Options' },

            ['<leader>UOl'] = {
                Opts.print_set_opts,
                desc('Print options set by `user.opts`'),
            },
        },
    })
end

---@param O? table
---@return table|User.Opts|fun(override: table|vim.bo|vim.wo?, verbose: boolean?)
function Opts.new(O)
    O = is_tbl(O) and O or {}

    return setmetatable(O, {
        __index = Opts,

        ---@param self User.Opts
        ---@param override? User.Opts.Spec A table with custom options
        ---@param verbose? boolean Flag to make the function return a string with invalid values, if any
        __call = function(self, override, verbose)
            override = is_tbl(override) and override or {}
            verbose = is_bool(verbose) and verbose or false

            local defaults = self.get_defaults()

            if not type_not_empty('table', self.options) then
                self.options = self.long_opts_convert(defaults, verbose)
            end

            local parsed_opts = self.long_opts_convert(override, verbose)

            ---@type table|vim.bo|vim.wo
            self.options = deep_extend('keep', parsed_opts, copy(self.options))

            self.optset(self.options, verbose)

            -- NOTE: Set to global `Opts` table aswell
            Opts.options = self.options
        end,
    })
end

return Opts.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
