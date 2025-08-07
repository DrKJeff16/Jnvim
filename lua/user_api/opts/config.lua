local executable = require('user_api.check.exists').executable

---@class User.Opts.Spec: vim.wo,vim.bo,vim.Option
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
    foldmethod = 'manual',
    formatoptions = {
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
    hidden = true,
    hlg = { 'en' }, -- `helplang`
    hlsearch = true,
    incsearch = true,
    ls = 2, -- `laststatus`
    makeprg = 'make',
    matchpairs = {
        '(:)',
        '[:]',
        '{:}',
        '<:>',
    },
    mouse = { a = false }, -- Disable the mouse by default
    nu = true, -- `number`
    nuw = 4, -- `numberwidth`
    pi = false, -- `preserveindent`
    relativenumber = false,
    ruler = true,
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
    stal = 2, -- `showtabline`
    sw = 4, -- `shiftwidth`
    termguicolors = true,
    ts = 4, -- `tabstop`
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
