_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.inspect = vim.inspect

local User = require('user_api')
local Check = require('user_api.check')
local Util = require('user_api.util')
local Termux = require('user_api.distro.termux')

local ft_get = Util.ft_get
local bt_get = Util.bt_get
local Keymaps = require('user_api.config.keymaps')
local Opts = require('user_api.opts')
local desc = require('user_api.maps').desc

local in_tbl = vim.tbl_contains
local optset = vim.api.nvim_set_option_value

local INFO = vim.log.levels.INFO
local uv = vim.uv or vim.loop

_G.is_windows = uv.os_uname().version:match('Windows') ~= nil
_G.in_console = Check.in_console

local curr_buf = vim.api.nvim_get_current_buf

-- [SOURCE](stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil)
---@type fun(...: any)
function _G.notify_inspect(...)
    vim.notify(vim.inspect(...), INFO)
end

Opts({
    autoread = true,
    backup = false,
    bg = 'dark', -- `background`
    bs = 'indent,eol,start', -- `backspace`
    cc = '101', -- `colorcolumn`
    cmdwinheight = Termux.validate() and 15 or 25,
    ci = false, -- `copyindent`
    confirm = true,
    equalalways = true,
    et = true, -- `expandtab`
    ff = 'unix', -- `fileformat`
    fo = 'bjlnopqw', -- `formatoptions`
    foldmethod = 'manual',
    hidden = true,
    hlg = 'en', -- `helplang`
    hls = true, -- `hlsearch`
    ignorecase = false,
    incsearch = true,
    matchpairs = '(:),[:],{:},<:>',
    matchtime = 30,
    menuitems = 50,
    mouse = '',
    nu = true, -- `number`
    pi = false, -- `preserveindent`
    relativenumber = false,
    rl = false, -- `rightleft`
    ruler = true,
    scrolloff = 2,
    sessionoptions = 'buffers,tabpages,globals',
    showmatch = true,
    showmode = false,
    spell = false,
    splitbelow = true,
    splitright = true,
    stal = 2, -- `showtabline`
    signcolumn = 'yes',
    splitkeep = 'screen',
    sts = 4, -- `softtabstop`
    sw = 4, -- `shiftwidth`
    swb = 'usetab', -- `switchbuf`
    title = true,
    ts = 4, -- `tabstop`
    tw = 100,
    wrap = Termux.validate(),
})

Opts.set_cursor_blink()

---Set `<Leader>` key.
Keymaps.set_leader('<Space>')

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

local L = require('config.lazy')

Keymaps({
    n = {
        ['<leader>vM'] = {
            vim.cmd.messages,
            desc('Run `:messages`'),
        },
        ['<leader>vN'] = {
            vim.cmd.Notifications,
            desc('Run `:Notifications`'),
        },
    },
}, nil, true)

local Alpha = L.alpha()

if Alpha ~= nil then
    Alpha('theta')
end

-- Initialize the User API
User.setup()

local Color = L.colorschemes()

-- Color('nightfox', 'nightfox')
-- Color('nightfox', 'carbonfox')
-- Color('tokyonight', 'moon')
Color('tokyonight', 'storm')
-- Color('catppuccin', 'mocha')

vim.cmd.packadd('nohlsearch')

-- NOTE: See `:h g:markdown_minlines`
vim.g.markdown_minlines = 500

local Lsp = L.lsp()
Lsp.setup()

local buf = curr_buf()

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

local ft, bt = ft_get(buf), bt_get(buf)

-- HACK: In case we're on specific buffer (file|buf)types
if not (in_tbl(DISABLE_FT, ft) or in_tbl(DISABLE_BT, bt)) then
    return
end

---@type vim.api.keyset.option
local opts = { scope = 'local' }

optset('number', false, opts)
optset('signcolumn', 'no', opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
