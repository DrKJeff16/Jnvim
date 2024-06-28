---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lazy
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local env_vars = Check.exists.env_vars
local vim_exists = Check.exists.vim_exists
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local in_console = Check.in_console
local map_dict = User.maps.map_dict

--- Set installation dir for `Lazy`.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

--- Install `Lazy` automatically.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, lazypath })
end

--- Add `Lazy` to runtimepath
vim.opt.rtp:prepend(lazypath)

local Lazy = require('lazy')

Lazy.setup({
    root = vim.fn.stdpath('data') .. '/lazy',
    performance = {
        rtp = {
            reset = true,
            disabled_plugins = {
                'tutor',
                'netrwPlugin',
            },
        },
    },
    spec = {
        { import = 'plugin._spec' },
    },
    install = {
        colorscheme = { 'habamax' },
        missing = true,
    },
    rocks = {
        root = vim.fn.stdpath('data') .. '/lazy-rocks',
        server = 'https://nvim-neorocks.github.io/rocks-binaries/',
    },
    pkg = {
        cache = vim.fn.stdpath('state') .. '/lazy/pkg-cache.lua',
        versions = true,
        sources = (function()
            return executable('pathspec-find')
                    and {
                        'lazy',
                        'rockspec',
                        'pathspec',
                    }
                or { 'lazy', 'rockspec' }
        end)(),
    },
    dev = {
        path = '~/Projects',
        patterns = { 'DrKJeff16' },
        fallback = false,
    },
    change_detection = {
        enabled = true,
        notify = true,
    },
    checker = {
        enabled = true,
        notify = true,
        frequency = 1800,
        check_pinned = false,
    },
    ui = {
        backdrop = 75,
        border = 'double',
        title = 'L      A      Z      Y',
        wrap = true,
        title_pos = 'center',
        pills = true,
    },

    readme = {
        enabled = true,
        root = vim.fn.stdpath('state') .. '/lazy/readme',
        files = { 'README.md', 'lua/**/README.md' },

        -- only generate markdown helptags for plugins that dont have docs
        skip_if_doc_exists = false,
    },

    state = vim.fn.stdpath('state') .. '/lazy/state.json',

    profiling = {
        -- Enables extra stats on the debug tab related to the loader cache.
        -- Additionally gathers stats about all package.loaders
        loader = true,
        -- Track each new require in the Lazy profiling tab
        require = true,
    },
})

---@type LazyMods
local P = {
    colorschemes = require('plugin.colorschemes'),
}

---@param cmd 'ed'|'tabnew'|'split'|'vsplit'
---@return fun()
local key_variant = function(cmd)
    cmd = (is_str(cmd) and vim.tbl_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'ed'

    cmd = cmd .. ' '

    return function()
        local full_cmd = cmd .. vim.fn.stdpath('config') .. '/lua/plugins/init.lua'

        vim.cmd(full_cmd)
    end
end

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
        ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
        ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
        ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
        ['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
        ['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
        ['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
        ['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
        ['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
        ['<leader>Lr'] = { Lazy.reload, desc('Reload Lazy Plugins') },
        ['<leader>LL'] = { ':Lazy ', desc('Select `Lazy` Operation (Interactively)', false) },
    },
    v = {
        ['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
        ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
        ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
        ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
        ['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
        ['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
        ['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
        ['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
        ['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
        ['<leader>Lr'] = { Lazy.reload, desc('Reload Lazy Plugins') },
    },
}
---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>L'] = { name = '+Lazy' },
        ['<leader>Le'] = { name = '+Edit Lazy File' },
    },
    v = {
        ['<leader>L'] = { name = '+Lazy' },
        ['<leader>Le'] = { name = '+Edit Lazy File' },
    },
}

if WK.available() then
    map_dict(Names, 'wk.register', true)
end

map_dict(Keys, 'wk.register', true)

return P
