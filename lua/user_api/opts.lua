---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user_api.types.user.opts')

local Value = require('user_api.check.value')
local Exists = require('user_api.check.exists')

local exists = Exists.vim_exists
local is_nil = Value.is_nil
local is_tbl = Value.is_tbl
local executable = Exists.executable
local vim_has = Exists.vim_has
local vim_exists = Exists.vim_exists
local in_console = require('user_api.check').in_console
local notify = require('user_api.util.notify').notify

---@type User.Opts.Spec
local DEFAULT_OPTIONS = {
    autoindent = true,
    autoread = true,
    backspace = { 'indent', 'eol', 'start' },
    backup = false,
    belloff = { 'all' },
    copyindent = true,
    encoding = 'utf-8',
    errorbells = false,
    fileignorecase = false,
    hidden = true,
    laststatus = 2,
    makeprg = 'make',
    matchpairs = {
        '(:)',
        '[:]',
        '{:}',
        '<:>',
    },
    matchtime = 30,
    menuitems = 40,
    mouse = '', -- Get that mouse out of my sight!
    number = true,
    preserveindent = true,
    ruler = true,
    showcmd = true,
    showmatch = true,
    showmode = false,
    smartindent = true,
    signcolumn = 'yes',
    smartcase = true,
    splitbelow = true,
    splitright = true,
    smarttab = true,
    softtabstop = 4,
    shiftwidth = 4,
    termguicolors = vim_exists('+termguicolors') and not in_console(),
    tabstop = 4,
    updatecount = 100,
    updatetime = 1000,
    visualbell = false,
    wildmenu = true,
}

if is_windows then
    DEFAULT_OPTIONS.fileignorecase = true
    DEFAULT_OPTIONS.makeprg = executable('mingw32-make.exe') and 'mingw32-make.exe' or DEFAULT_OPTIONS.makeprg

    DEFAULT_OPTIONS.shell = 'cmd.exe'
    if executable('bash.exe') then
        DEFAULT_OPTIONS.shell = 'bash.exe'
        DEFAULT_OPTIONS.shellcmdflag = '-c'
    elseif executable('sh.exe') then
        DEFAULT_OPTIONS.shell = 'sh.exe'
        DEFAULT_OPTIONS.shellcmdflag = '-c'
    else
        DEFAULT_OPTIONS.shell = 'cmd.exe'
    end

    DEFAULT_OPTIONS.shellslash = true
end

---@type User.Opts
---@diagnostic disable-next-line:missing-fields
local M = {
    --- Option setter for the aforementioned options dictionary
    --- ---
    --- ## Parameters
    --- * `opts`: A dictionary with keys as `vim.opt` or `vim.o` fields, and values for each option
    --- respectively
    --- ---
    ---@param opts User.Opts.Spec
    optset = function(opts)
        for k, v in next, opts do
            if is_nil(v) then
                goto continue
            end

            if not is_nil(vim.opt[k]) then
                vim.opt[k] = v
            elseif not is_nil(vim.o[k]) then
                vim.o[k] = v
            else
                notify(
                    '(user.opts.optset): Unable to set option `' .. k .. '`',
                    'error',
                    { title = 'user_api.opts', hide_from_history = false, timeout = 3000 }
                )
            end

            ::continue::
        end
    end,
}

---@param override User.Opts.Spec
function M.setup(override)
    override = is_tbl(override) and override or {}

    M.optset(vim.tbl_extend('keep', override, DEFAULT_OPTIONS))
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
