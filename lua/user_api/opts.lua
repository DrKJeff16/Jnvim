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
    autoindent = true,
    autoread = true,
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
    hid = true,
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
    mouse = {
        a = false,
    }, -- Get that mouse out of my sight!
    number = true,
    preserveindent = false,
    rnu = true,
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

--- Option setter for the aforementioned options dictionary
--- ---
--- ## Parameters
--- * `opts`: A dictionary with keys as `vim.opt` or `vim.o` fields, and values for each option
--- respectively
--- ---
---@param opts User.Opts.Spec
function M.optset(opts)
    opts = require('user_api.check.value').is_tbl(opts) and opts or {}

    for k, v in next, opts do
        if type(vim.opt[k]:get()) == type(v) then
            vim.opt[k] = v
        else
            vim.notify('Option `' .. k .. '` could not be parsed', vim.log.levels.WARN)
        end
    end
end

---@param self User.Opts
---@param override User.Opts.Spec
function M:setup(override)
    local inspect = inspect or vim.inspect
    local nwl = newline or string.char(10)
    override = is_tbl(override) and override or {}

    ---@type table|vim.wo|vim.bo
    local opts = vim.tbl_extend('keep', override, self.DEFAULT_OPTIONS)

    ---@type User.Opts.Spec
    local parsed_opts = {}

    local msg = ''

    for opt, val in next, opts do
        local keys = vim.tbl_keys(self.ALL_OPTIONS)
        -- If neither long nor short (known) option, append to warning
        if not vim.tbl_contains(keys, opt) and not Value.tbl_values({ opt }, self.ALL_OPTIONS) then
            msg = msg .. 'Option ' .. inspect(opt) .. 'not valid. Ignoring' .. nwl
        else
            parsed_opts[opt] = val
        end
    end

    if msg ~= '' then
        vim.notify(msg)
    end

    self.optset(parsed_opts)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
