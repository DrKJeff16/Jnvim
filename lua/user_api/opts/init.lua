require('user_api.types.user.opts')

local Value = require('user_api.check.value')
local Exists = require('user_api.check.exists')

local exists = Exists.vim_exists
local executable = Exists.executable
local vim_has = Exists.vim_has
local vim_exists = Exists.vim_exists
local is_nil = Value.is_nil
local is_str = Value.is_str
local is_tbl = Value.is_tbl
local is_bool = Value.is_bool
local empty = Value.empty
local in_console = require('user_api.check').in_console

---@type User.Opts
---@diagnostic disable-next-line:missing-fields
local M = {}

M.ALL_OPTIONS = require('user_api.opts.all_opts')

---@type User.Opts.Spec
M.DEFAULT_OPTIONS = {
    ai = true,
    ar = true,
    backspace = { 'indent', 'eol', 'start' },
    backup = false,
    belloff = { 'all' },
    copyindent = false,
    encoding = 'utf-8',
    errorbells = false,
    fileignorecase = false,
    fo = {
        b = true,
        c = false,
        j = true,
        l = true,
        n = true,
        o = true,
        p = true,
        q = true,
        w = true,
    },
    helplang = { 'en' },
    hidden = true,
    ls = 2,
    makeprg = 'make',
    matchpairs = {
        '(:)',
        '[:]',
        '{:}',
        '<:>',
    },
    matchtime = 30,
    menuitems = 40,
    mouse = { a = false }, -- Get that mouse out of my sight!
    number = true,
    nuw = 4,
    preserveindent = false,
    relativenumber = true,
    ru = true,
    shiftwidth = 4,
    showcmd = true,
    showmatch = true,
    showmode = false,
    signcolumn = 'yes',
    smartcase = true,
    smartindent = true,
    smarttab = true,
    softtabstop = 4,
    splitbelow = true,
    splitright = true,
    tabstop = 4,
    termguicolors = vim_exists('+termguicolors') and not in_console(),
    updatecount = 100,
    updatetime = 1000,
    visualbell = false,
    wildmenu = true,
}

if is_windows then
    if executable('mingw32-make') then
        M.DEFAULT_OPTIONS.makeprg = 'mingw32-make'
    end

    M.DEFAULT_OPTIONS.shell = executable('pwsh') and 'pwsh' or 'cmd'
    if executable('bash') then
        M.DEFAULT_OPTIONS.shell = 'bash'
        M.DEFAULT_OPTIONS.shellcmdflag = '-c'
    elseif executable('sh') then
        M.DEFAULT_OPTIONS.shell = 'sh'
        M.DEFAULT_OPTIONS.shellcmdflag = '-c'
    else
        M.DEFAULT_OPTIONS.shell = 'cmd'
    end

    M.DEFAULT_OPTIONS.fileignorecase = true
    M.DEFAULT_OPTIONS.shellslash = true
end

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
    local keys = vim.tbl_keys(M.ALL_OPTIONS)
    table.sort(keys)

    for opt, val in next, T do
        local new_opt = ''

        -- If neither long nor short (known) option, append to warning message
        if not (vim.tbl_contains(keys, opt) or Value.tbl_values({ opt }, M.ALL_OPTIONS)) then
            msg = msg .. '- Option ' .. insp(opt) .. 'not valid' .. nwl
        elseif vim.tbl_contains(keys, opt) then
            parsed_opts[opt] = val
        else
            new_opt = Value.tbl_values({ opt }, M.ALL_OPTIONS, true)
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
function M.optset(T)
    local notify = require('user_api.util.notify').notify

    T = is_tbl(T) and T or {}

    local opts = long_opts_convert(T)
    local msg = ''

    for k, v in next, opts do
        if is_nil(vim.opt[k]) then
            msg = msg .. 'Option `' .. k .. '` is not a valid field for `vim.opt`'
        elseif type(vim.opt[k]:get()) == type(v) then
            vim.opt[k] = v
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
---@return table? msg
function M:setup(override, verbose)
    override = is_tbl(override) and override or {}
    verbose = is_bool(verbose) and verbose or false

    local parsed_opts, msg = long_opts_convert(override)

    ---@type table|vim.wo|vim.bo
    local opts = vim.tbl_deep_extend('keep', parsed_opts, self.DEFAULT_OPTIONS)

    self.optset(opts)

    if msg ~= '' then
        vim.schedule(
            function()
                require('user_api.util.notify').notify(msg, 'warn', {
                    animate = false,
                    hide_from_history = false,
                    timeout = 1750,
                    title = '(user_api.opts:setup)',
                })
            end
        )
    end

    if verbose then
        return opts
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
