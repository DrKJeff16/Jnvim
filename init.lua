_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.inspect = vim.inspect

local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

local User = require('user_api')

local Check = require('user_api.check')
local Keymaps = require('user_api.config.keymaps')
local Neovide = require('user_api.config.neovide')
local Util = require('user_api.util')
local Opts = require('user_api.opts')
local Commands = require('user_api.commands')
local Distro = require('user_api.distro')

local desc = require('user_api.maps.kmap').desc

_G.is_windows = (vim.uv or vim.loop).os_uname().version:match('Windows') ~= nil
_G.in_console = Check.in_console

local curr_buf = vim.api.nvim_get_current_buf

-- [SOURCE](stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil)
---@type fun(...: any)
function _G.print_inspect(...)
    vim.print(inspect(...))
end

-- [SOURCE](stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil)
---@type fun(...: any)
function _G.notify_inspect(...)
    vim.notify(inspect(...), INFO)
end

Opts({
    autoread = true,
    backup = false,
    bg = 'dark', -- `background`
    bs = { 'indent', 'eol', 'start' }, -- `backspace`
    cmdwinheight = Distro.termux.validate() and 15 or 25,
    ci = false, -- `copyindent`
    completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' },
    confirm = true,
    equalalways = true,
    et = true, -- `expandtab`
    ff = 'unix', -- `fileformat`
    fo = { -- `formatoptions`
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
    foldmethod = 'manual',
    hidden = true,
    hlg = { 'en' }, -- `helplang`
    hls = true, -- `hlsearch`
    ignorecase = false,
    incsearch = true,
    matchtime = 30,
    menuitems = 50,
    mouse = { a = false },
    nu = true, -- `number`
    pi = false, -- `preserveindent`
    relativenumber = false,
    rl = false, -- `rightleft`
    ruler = true,
    scrolloff = 2,
    sessionoptions = { 'buffers', 'tabpages', 'globals' },
    showmatch = true,
    showmode = false,
    spell = false,
    splitbelow = true,
    splitright = true,
    stal = 2, -- `showtabline`
    signcolumn = 'yes',
    sts = 4, -- `softtabstop`
    sw = 4, -- `shiftwidth`
    swb = { 'usetab' }, -- `switchbuf`
    ts = 4, -- `tabstop`
    title = true,
    wrap = Distro.termux.validate(),
})

-- HACK: Set up `guicursor` so that cursor blinks
if not in_console() then
    Opts.set_cursor_blink()
end

-- Call runtimepath optimizations for specific platforms
Distro()

-- Set `<Leader>` key
Keymaps.set_leader('<Space>')

vim.g.markdown_minlines = 500

--- Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

local L = require('config.lazy')

Keymaps({
    n = {
        ['<leader>fii'] = {
            function()
                local opt_get = vim.api.nvim_get_option_value
                local cursor_set = vim.api.nvim_win_set_cursor
                local cursor_get = vim.api.nvim_win_get_cursor

                local buf = curr_buf()

                if not opt_get('modifiable', { buf = buf }) then
                    vim.notify('Unable to indent. File is not modifiable!', ERROR)
                end

                local win = vim.api.nvim_get_current_win()
                local saved_pos = cursor_get(win)

                vim.api.nvim_feedkeys('gg=G', 'n', false)

                -- HACK: Wait for `feedkeys` to end, then reset to position
                vim.schedule(function()
                    cursor_set(win, saved_pos)
                end)
            end,
            desc('Indent Whole File'),
        },
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

---@type table|CscMod|fun(color?: string, ...)
local Color = L.colorschemes()
Color('tokyonight', 'moon')

local Alpha = L.alpha()

if Alpha ~= nil then
    Alpha('startify')
end

-- Call the User API file associations and other autocmds
Util.setup_autocmd()

-- NOTE: See `:h g:markdown_minlines`
vim.g.markdown_minlines = 500

vim.cmd.packadd('nohlsearch')

-- Define any custom commands
Commands.setup()

-- Mappings related specifically to `user_api`
User.setup() -- NOTE: This MUST be called after `Commands:setup()` or it won't work

Neovide:setup()

local Lsp = L.lsp()
Lsp()

vim.schedule(function()
    local in_tbl = vim.tbl_contains
    local opt_set = vim.api.nvim_set_option_value
    local ft_get = Util.ft_get
    local bt_get = Util.bt_get

    local buf = curr_buf()

    vim.cmd.noh() -- HACK: Disable highlights when reloading

    local DISABLE_ON = {
        ft = {
            'help',
            'lazy',
            'notify',
            'qf',
            'TelescopePrompt',
            'TelescopeResults',
        },

        bt = {
            'help',
            'prompt',
            'quickfix',
            'terminal',
        },
    }

    local curr_ft = ft_get(buf)
    local curr_bt = bt_get(buf)

    -- HACK: In case we're on specific buffer (file|buf)types
    if not (in_tbl(DISABLE_ON.ft, curr_ft) or in_tbl(DISABLE_ON.bt, curr_bt)) then
        return
    end

    opt_set('number', false, { scope = 'local' })
    opt_set('signcolumn', 'no', { scope = 'local' })
end)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
