require('user_api.types.user.opts')

local Exists = require('user_api.check.exists')

local executable = Exists.executable
local vim_exists = Exists.vim_exists
local in_console = require('user_api.check').in_console

---@type User.Opts.Spec
---@diagnostic disable-next-line:missing-fields
local M = {
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
    foldmethod = 'expr',
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
        M.makeprg = 'mingw32-make'
    end

    M.shell = executable('pwsh') and 'pwsh' or 'cmd'
    if executable('bash') then
        M.shell = 'bash'
        M.shellcmdflag = '-c'
    elseif executable('sh') then
        M.shell = 'sh'
        M.shellcmdflag = '-c'
    else
        M.shell = 'cmd'
    end

    M.fileignorecase = true
    M.shellslash = true
end

return M
