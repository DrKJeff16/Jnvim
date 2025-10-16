_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.is_windows = (vim.uv or vim.loop).os_uname().version:match('Windows') ~= nil
_G.inspect = vim.inspect

local Keymaps = require('user_api.config').keymaps
local Opts = require('user_api').opts
local desc = require('user_api.maps').desc
local ft_get = require('user_api.util').ft_get
local bt_get = require('user_api.util').bt_get

local INFO = vim.log.levels.INFO
local in_list = vim.list_contains
local curr_buf = vim.api.nvim_get_current_buf

-- [SOURCE](https://stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil)
---@type fun(...: any)
function _G.notify_inspect(...)
    vim.notify(vim.inspect(...), INFO)
end

vim.g.loaded_perl_provider = 0

Opts({
    autoread = true,
    background = 'dark',
    backspace = 'indent,eol,start',
    backup = false,
    cmdwinheight = require('user_api.distro.termux').validate() and 15 or 25,
    colorcolumn = '101',
    confirm = true,
    copyindent = true,
    equalalways = true,
    errorbells = false,
    expandtab = true,
    fileformat = 'unix',
    fileignorecase = not _G.is_windows,
    foldmethod = 'manual',
    formatoptions = 'bjlnopqw',
    helplang = 'en',
    hidden = true,
    hlsearch = true,
    ignorecase = false,
    incsearch = true,
    list = true,
    matchpairs = '(:),[:],{:},<:>',
    matchtime = 30,
    menuitems = 50,
    mouse = '',
    number = true,
    preserveindent = true,
    relativenumber = false,
    rightleft = false,
    ruler = true,
    scrolloff = 2,
    secure = false,
    sessionoptions = 'buffers,tabpages,globals',
    shiftwidth = 4,
    showmatch = true,
    showmode = false,
    showtabline = 2,
    signcolumn = 'yes',
    softtabstop = 4,
    spell = false,
    splitbelow = true,
    splitkeep = 'screen',
    splitright = true,
    switchbuf = 'usetab',
    tabstop = 4,
    textwidth = 100,
    title = true,
    wrap = require('user_api.distro.termux').validate(),
})

Opts.set_cursor_blink()

---Set `<Leader>` key.
Keymaps.set_leader('<Space>')

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

---Call Lazy Plugins
local L = require('config.lazy')

Keymaps({
    n = {
        ['<leader>vM'] = { vim.cmd.messages, desc('Run `:messages`') },
        ['<leader>vN'] = { vim.cmd.Notifications, desc('Run `:Notifications`') },
        ['<C-/>'] = { ':normal gcc<CR>', desc('Toggle Comment') },
    },
    v = {
        ['<C-/>'] = { ":'<,'>normal gcc<CR>", desc('Toggle Comment') },
    },
    x = {
        ['<M-m>'] = {
            function()
                _G.cursor_line = vim.fn.line('.')
            end,
            desc('Visual Mode trick'),
        },
        ['<M-n>'] = {
            function()
                _G.other_line = vim.fn.line('v')
            end,
            desc('Visual Mode trick'),
        },
    },
}, nil, true)

-- Initialize the User API
require('user_api').setup()

local Color = L.colorschemes()

-- Color('Nightfox', 'nightfox')
-- Color('Nightfox', 'carbonfox')
-- Color('Nightfox', 'duskfox')
Color('Tokyonight', 'storm')
-- Color('Tokyonight', 'moon')
-- Color('Conifer', 'lunar')
-- Color('Tokyodark')
-- Color('Catppuccin', 'mocha')
-- Color('Catppuccin', 'macchiato')
-- Color('Catppuccin', 'frappe')
-- Color('Spaceduck')

vim.cmd.packadd('nohlsearch')

if vim.fn.has('nvim-0.12.0') == 1 then
    vim.cmd.packadd('nvim.undotree')
end

vim.g.markdown_minlines = 500

L.lsp().setup()

local DISABLE_FT = {
    'help',
    'lazy',
    'checkhealth',
    'notify',
    'qf',
    'TelescopePrompt',
    'TelescopeResults',
}

local DISABLE_BT = {
    'help',
    'prompt',
    'quickfix',
    'terminal',
}

local bufnr = curr_buf()
if not (in_list(DISABLE_FT, ft_get(bufnr)) or in_list(DISABLE_BT, bt_get(bufnr))) then
    return
end

vim.keymap.set('n', 'q', vim.cmd.bdelete, { noremap = true, silent = true, buffer = bufnr })
local win = vim.api.nvim_get_current_win()
vim.wo[win].number = false
vim.wo[win].signcolumn = 'no'
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
