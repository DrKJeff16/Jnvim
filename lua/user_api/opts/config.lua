---@diagnostic disable:missing-fields

---@module 'user_api.types.opts'

local Exists = require('user_api.check.exists')

local executable = Exists.executable
local vim_exists = Exists.vim_exists
local in_console = require('user_api.check').in_console

---@type User.Opts.Spec
local Defaults = {
    ai = true, -- `autoindent`
    ar = true, -- `autoread`
    backspace = { 'indent', 'eol', 'start' },
    backup = false,
    belloff = { 'all' },
    ci = false, -- `copyindent`
    encoding = 'utf-8',
    errorbells = false,
    et = true, -- `expandtab`
    fileignorecase = is_windows,
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
    }, -- `formatoptions`
    foldmethod = 'manual',
    hlg = { 'en' }, -- `helplang`
    hlsearch = true,
    hid = true, -- `hidden`
    incsearch = true,
    ls = 2, -- `laststatus`
    makeprg = 'make',
    matchpairs = {
        '(:)',
        '[:]',
        '{:}',
        '<:>',
    },
    matchtime = 30,
    menuitems = 40,
    mouse = { a = false }, -- NOTE: Get that mouse out of my sight!
    nu = true, -- `number`
    nuw = 4, -- `numberwidth`
    pi = false, -- `preserveindent`
    rnu = true, -- `relativenumber`
    ru = true, -- `ruler`
    sw = 4, -- `shiftwidth`
    showcmd = true,
    showmatch = true,
    showmode = false,
    signcolumn = 'yes',
    smartcase = true,
    smartindent = true,
    smarttab = true,
    softtabstop = 4,
    spell = false,
    splitbelow = true,
    splitright = true,
    ts = 4, -- `tabstop`
    tgc = vim_exists('+termguicolors') and not require('user_api.check').in_console() or false, -- `termguicolors`
    updatecount = 100,
    updatetime = 1000,
    visualbell = false,
    wildmenu = true,
}

if is_windows then
    if executable('mingw32-make') then
        Defaults.makeprg = 'mingw32-make'
    end

    if executable('bash') then
        Defaults.shell = 'bash'
        Defaults.shellcmdflag = '-c'
    elseif executable('sh') then
        Defaults.shell = 'sh'
        Defaults.shellcmdflag = '-c'
    elseif executable('pwsh') then
        Defaults.shell = 'pwsh'
    else
        Defaults.shell = 'cmd'
    end

    Defaults.fileignorecase = true
    Defaults.shellslash = true
end

return Defaults
