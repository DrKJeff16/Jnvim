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

M.ALL_OPTIONS = {
    ['allowrevins'] = 'ari',
    ['ambiwidth'] = 'ambw',
    ['arabic'] = 'arab',
    ['arabicshape'] = 'arshape',
    ['autochdir'] = 'acd',
    ['autoindent'] = 'ai',
    ['autoread'] = 'ar',
    ['autowrite'] = 'aw',
    ['autowriteall'] = 'awa',
    ['background'] = 'bg',
    ['backspace'] = 'bs',
    ['backup'] = 'bk',
    ['backupcopy'] = 'bkc',
    ['backupdir'] = 'bdir',
    ['backupext'] = 'bex',
    ['backupskip'] = 'bsk',
    ['belloff'] = 'bo',
    ['binary'] = 'bin',
    ['bomb'] = '',
    ['breakat'] = 'brk',
    ['breakindent'] = 'bri',
    ['breakindentopt'] = 'briopt',
    ['browsedir'] = 'bsdir',
    ['bufhidden'] = 'bh',
    ['buflisted'] = 'bl',
    ['buftype'] = 'bt',
    ['casemap'] = 'cmp',
    ['cdhome'] = 'cdh',
    ['cdpath'] = 'cd',
    ['cedit'] = '',
    ['charconvert'] = 'ccv',
    ['cindent'] = 'cin',
    ['cinkeys'] = 'cink',
    ['cinoptions'] = 'cino',
    ['cinscopedecls'] = 'cinsd',
    ['cinwords'] = 'cinw',
    ['clipboard'] = 'cb',
    ['cmdheight'] = 'ch',
    ['cmdwinheight'] = 'cwh',
    ['colorcolumn'] = 'cc',
    ['columns'] = 'co',
    ['comments'] = 'com',
    ['commentstring'] = 'cms',
    ['complete'] = 'cpt',
    ['completefunc'] = 'cfu',
    ['completeopt'] = 'cot',
    ['completeslash'] = 'csl',
    ['concealcursor'] = 'cocu',
    ['conceallevel'] = 'cole',
    ['confirm'] = 'cf',
    ['copyindent'] = 'ci',
    ['cpoptions'] = 'cpo',
    ['cursorbind'] = 'crb',
    ['cursorcolumn'] = 'cuc',
    ['cursorline'] = 'cul',
    ['cursorlineopt'] = 'culopt',
    ['debug'] = '',
    ['define'] = 'def',
    ['delcombine'] = 'deco',
    ['dictionary'] = 'dict',
    ['diff'] = '',
    ['diffexpr'] = 'dex',
    ['diffopt'] = 'dip',
    ['digraph'] = 'dg',
    ['directory'] = 'dir',
    ['display'] = 'dy',
    ['eadirection'] = 'ead',
    ['encoding'] = 'enc',
    ['endoffile'] = 'eof',
    ['endofline'] = 'eol',
    ['equalalways'] = 'ea',
    ['equalprg'] = 'ep',
    ['errorbells'] = 'eb',
    ['errorfile'] = 'ef',
    ['errorformat'] = 'efm',
    ['eventignore'] = 'ei',
    ['expandtab'] = 'et',
    ['exrc'] = 'ex',
    ['fileencoding'] = 'fenc',
    ['fileencodings'] = 'fencs',
    ['fileformat'] = 'ff',
    ['fileformats'] = 'ffs',
    ['fileignorecase'] = 'fic',
    ['filetype'] = 'ft',
    ['fillchars'] = 'fcs',
    ['fixendofline'] = 'fixeol',
    ['foldclose'] = 'fcl',
    ['foldcolumn'] = 'fdc',
    ['foldenable'] = 'fen',
    ['foldexpr'] = 'fde',
    ['foldignore'] = 'fdi',
    ['foldlevel'] = 'fdl',
    ['foldlevelstart'] = 'fdls',
    ['foldmarker'] = 'fmr',
    ['foldmethod'] = 'fdm',
    ['foldminlines'] = 'fml',
    ['foldnestmax'] = 'fdn',
    ['foldopen'] = 'fdo',
    ['foldtext'] = 'fdt',
    ['formatexpr'] = 'fex',
    ['formatlistpat'] = 'flp',
    ['formatoptions'] = 'fo',
    ['formatprg'] = 'fp',
    ['fsync'] = 'fs',
    ['gdefault'] = 'gd',
    ['grepformat'] = 'gfm',
    ['grepprg'] = 'gp',
    ['guicursor'] = 'gcr',
    ['guifont'] = 'gfn',
    ['guifontwide'] = 'gfw',
    ['guioptions'] = 'go',
    ['guitablabel'] = 'gtl',
    ['guitabtooltip'] = 'gtt',
    ['helpfile'] = 'hf',
    ['helpheight'] = 'hh',
    ['helplang'] = 'hlg',
    ['hidden'] = 'hid',
    ['history'] = 'hi',
    ['hlsearch'] = 'hls',
    ['icon'] = '',
    ['iconstring'] = '',
    ['ignorecase'] = 'ic',
    ['imcmdline'] = 'imc',
    ['imdisable'] = 'imd',
    ['iminsert'] = 'imi',
    ['imsearch'] = 'ims',
    ['include'] = 'inc',
    ['includeexpr'] = 'inex',
    ['incsearch'] = 'is',
    ['indentexpr'] = 'inde',
    ['indentkeys'] = 'indk',
    ['infercase'] = 'inf',
    ['isfname'] = 'isf',
    ['isident'] = 'isi',
    ['iskeyword'] = 'isk',
    ['isprint'] = 'isp',
    ['joinspaces'] = 'js',
    ['jumpoptions'] = 'jop',
    ['keymap'] = 'kmp',
    ['keymodel'] = 'km',
    ['keywordprg'] = 'kp',
    ['langmap'] = 'lmap',
    ['langmenu'] = 'lm',
    ['langremap'] = 'lrm',
    ['laststatus'] = 'ls',
    ['lazyredraw'] = 'lz',
    ['linebreak'] = 'lbr',
    ['lines'] = '',
    ['linespace'] = 'lsp',
    ['lisp'] = '',
    ['lispoptions'] = 'lop',
    ['lispwords'] = 'lw',
    ['list'] = '',
    ['listchars'] = 'lcs',
    ['loadplugins'] = 'lpl',
    ['magic'] = '',
    ['makeef'] = 'mef',
    ['makeencoding'] = 'menc',
    ['makeprg'] = 'mp',
    ['matchpairs'] = 'mps',
    ['matchtime'] = 'mat',
    ['maxcombine'] = 'mco',
    ['maxfuncdepth'] = 'mfd',
    ['maxmapdepth'] = 'mmd',
    ['maxmempattern'] = 'mmp',
    ['menuitems'] = 'mis',
    ['mkspellmem'] = 'msm',
    ['modeline'] = 'ml',
    ['modelineexpr'] = 'mle',
    ['modelines'] = 'mls',
    ['modifiable'] = 'ma',
    ['modified'] = 'mod',
    ['more'] = '',
    ['mouse'] = '',
    ['mousefocus'] = 'mousef',
    ['mousehide'] = 'mh',
    ['mousemodel'] = 'mousem',
    ['mousemoveevent'] = 'mousemev',
    ['mousescroll'] = '',
    ['mouseshape'] = 'mouses',
    ['mousetime'] = 'mouset',
    ['nrformats'] = 'nf',
    ['number'] = 'nu',
    ['numberwidth'] = 'nuw',
    ['omnifunc'] = 'ofu',
    ['opendevice'] = 'odev',
    ['operatorfunc'] = 'opfunc',
    ['packpath'] = 'pp',
    ['paragraphs'] = 'para',
    ['patchexpr'] = 'pex',
    ['patchmode'] = 'pm',
    ['path'] = 'pa',
    ['preserveindent'] = 'pi',
    ['previewheight'] = 'pvh',
    ['previewwindow'] = 'pvw',
    ['pumheight'] = 'ph',
    ['pumwidth'] = 'pw',
    ['pyxversion'] = 'pyx',
    ['quoteescape'] = 'qe',
    ['readonly'] = 'ro',
    ['redrawtime'] = 'rdt',
    ['regexpengine'] = 're',
    ['relativenumber'] = 'rnu',
    ['report'] = '',
    ['revins'] = 'ri',
    ['rightleft'] = 'rl',
    ['rightleftcmd'] = 'rlc',
    ['ruler'] = 'ru',
    ['rulerformat'] = 'ruf',
    ['runtimepath'] = 'rtp',
    ['scroll'] = 'scr',
    ['scrollbind'] = 'scb',
    ['scrolljump'] = 'sj',
    ['scrolloff'] = 'so',
    ['scrollopt'] = 'sbo',
    ['sections'] = 'sect',
    ['secure'] = '',
    ['selection'] = 'sel',
    ['selectmode'] = 'slm',
    ['sessionoptions'] = 'ssop',
    ['shada'] = 'sd',
    ['shell'] = 'sh',
    ['shellcmdflag'] = 'shcf',
    ['shellpipe'] = 'sp',
    ['shellquote'] = 'shq',
    ['shellredir'] = 'srr',
    ['shellslash'] = 'ssl',
    ['shelltemp'] = 'stmp',
    ['shellxescape'] = 'sxe',
    ['shellxquote'] = 'sxq',
    ['shiftround'] = 'sr',
    ['shiftwidth'] = 'sw',
    ['shortmess'] = 'shm',
    ['showbreak'] = 'sbr',
    ['showcmd'] = 'sc',
    ['showcmdloc'] = 'sloc',
    ['showfulltag'] = 'sft',
    ['showmatch'] = 'sm',
    ['showmode'] = 'smd',
    ['showtabline'] = 'stal',
    ['sidescroll'] = 'ss',
    ['sidescrolloff'] = 'siso',
    ['signcolumn'] = 'scl',
    ['smartcase'] = 'scs',
    ['smartindent'] = 'si',
    ['smarttab'] = 'sta',
    ['smoothscroll'] = 'sms',
    ['softtabstop'] = 'sts',
    ['spell'] = '',
    ['spellcapcheck'] = 'spc',
    ['spellfile'] = 'spf',
    ['spelllang'] = 'spl',
    ['spelloptions'] = 'spo',
    ['spellsuggest'] = 'sps',
    ['splitbelow'] = 'sb',
    ['splitkeep'] = 'spk',
    ['splitright'] = 'spr',
    ['startofline'] = 'sol',
    ['statuscolumn'] = 'stc',
    ['statusline'] = 'stl',
    ['suffixes'] = 'su',
    ['suffixesadd'] = 'sua',
    ['swapfile'] = 'swf',
    ['switchbuf'] = 'swb',
    ['synmaxcol'] = 'smc',
    ['syntax'] = 'syn',
    ['tabclose'] = 'tcl',
    ['tabline'] = 'tal',
    ['tabpagemax'] = 'tpm',
    ['tabstop'] = 'ts',
    ['tagbsearch'] = 'tbs',
    ['tagcase'] = 'tc',
    ['tagfunc'] = 'tfu',
    ['taglength'] = 'tl',
    ['tagrelative'] = 'tr',
    ['tags'] = 'tag',
    ['tagstack'] = 'tgst',
    ['term'] = '',
    ['termbidi'] = 'tbidi',
    ['termguicolors'] = 'tgc',
    ['textwidth'] = 'tw',
    ['thesaurus'] = 'tsr',
    ['thesaurusfunc'] = 'tsrfu',
    ['tildeop'] = 'top',
    ['timeout'] = 'to',
    ['timeoutlen'] = 'tm',
    ['title'] = '',
    ['titlelen'] = '',
    ['titleold'] = '',
    ['titlestring'] = '',
    ['ttimeout'] = '',
    ['ttimeoutlen'] = 'ttm',
    ['ttytype'] = 'tty',
    ['undodir'] = 'udir',
    ['undofile'] = 'udf',
    ['undolevels'] = 'ul',
    ['undoreload'] = 'ur',
    ['updatecount'] = 'uc',
    ['updatetime'] = 'ut',
    ['varsofttabstop'] = 'vsts',
    ['vartabstop'] = 'vts',
    ['verbose'] = 'vbs',
    ['verbosefile'] = 'vfile',
    ['viewdir'] = 'vdir',
    ['viewoptions'] = 'vop',
    ['virtualedit'] = 've',
    ['visualbell'] = 'vb',
    ['warn'] = '',
    ['whichwrap'] = 'ww',
    ['wildchar'] = 'wc',
    ['wildcharm'] = 'wcm',
    ['wildignore'] = 'wig',
    ['wildignorecase'] = 'wic',
    ['wildmenu'] = 'wmnu',
    ['wildmode'] = 'wim',
    ['wildoptions'] = 'wop',
    ['winaltkeys'] = 'wak',
    ['window'] = 'wi',
    ['winfixbuf'] = 'wfb',
    ['winfixheight'] = 'wfh',
    ['winfixwidth'] = 'wfw',
    ['winheight'] = 'wh',
    ['winhighlight'] = 'winhl',
    ['winminheight'] = 'wmh',
    ['winminwidth'] = 'wmw',
    ['winwidth'] = 'wiw',
    ['wrap'] = '',
    ['wrapmargin'] = 'wm',
    ['wrapscan'] = 'ws',
    ['write'] = '',
    ['writeany'] = 'wa',
    ['writebackup'] = 'wb',
    ['writedelay'] = 'wd',
}

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
