local executable = require('user_api.check.exists').executable

---@class User.Opts.Spec: vim.wo,vim.bo
local Defaults = {
    autoindent = true,
    autoread = true,
    backspace = 'indent,eol,start',
    backup = false,
    belloff = 'all',
    copyindent = false,
    encoding = 'utf-8',
    errorbells = false,
    expandtab = true,
    foldmethod = 'manual',
    formatoptions = 'bjlnopqw',
    helplang = 'en',
    hidden = true,
    hlsearch = true,
    incsearch = true,
    laststatus = 2,
    makeprg = 'make',
    matchpairs = '(:),[:],{:},<:>',
    mouse = '',
    number = true,
    numberwidth = 4,
    preserveindent = false,
    relativenumber = false,
    ruler = true,
    shiftwidth = 4,
    showcmd = true,
    showmatch = true,
    showmode = false,
    showtabline = 2,
    signcolumn = 'yes',
    smartcase = true,
    smartindent = true,
    smarttab = true,
    softtabstop = 4,
    spell = false,
    splitbelow = true,
    splitright = true,
    tabstop = 4,
    termguicolors = true,
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
