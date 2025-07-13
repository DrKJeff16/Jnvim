---@module 'lazy'
---@module 'user_api.types.lazy'
---@module 'config._types'

local User = require('user_api')
local CfgUtil = require('config.util')
local Keymaps = require('config.keymaps')
local Archlinux = require('user_api.distro.archlinux')
local Termux = require('user_api.distro.termux')

local desc = require('user_api.maps.kmap').desc

local key_variant = CfgUtil.key_variant
local in_console = require('user_api.check').in_console
local is_root = require('user_api.check').is_root

local uv = vim.uv or vim.loop

_G.LAZY_DATA = vim.fn.stdpath('data') .. '/lazy'
_G.LAZY_STATE = vim.fn.stdpath('state') .. '/lazy'

--- Set installation dir for `Lazy`
_G.LAZYPATH = LAZY_DATA .. '/lazy.nvim'

_G.README_PATH = LAZY_STATE .. '/readme'

--- Install `Lazy` automatically
if not uv.fs_stat(LAZYPATH) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, LAZYPATH })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

--- Add `Lazy` to runtimepath
vim.opt.rtp:prepend(LAZYPATH)

local Lazy = require('lazy')

---@type LazyConfig
local Config = {
    spec = {
        { import = 'plugin._spec' },
    },

    defaults = {
        lazy = false,
        version = false,
    },

    root = LAZY_DATA,

    performance = {
        reset_packpath = true,

        rtp = {
            reset = true,
            disabled_plugins = {
                -- 'gzip',
                -- 'matchit',
                -- 'matchparen',
                'netrwPlugin',
                -- 'tarPlugin',
                -- 'tohtml',
                'tutor',
                -- 'zipPlugin',
            },
        },
    },

    install = {
        colorscheme = { 'habamax' },
        missing = true,
    },

    rocks = {
        enabled = not is_root() and CfgUtil.luarocks_check() or false,
        root = vim.fn.stdpath('data') .. '/lazy-rocks',
        server = 'https://nvim-neorocks.github.io/rocks-binaries/',
    },

    pkg = {
        enabled = true,
        cache = LAZY_STATE .. '/pkg-cache.lua',
        versions = true,
        sources = (function()
            ---@type LazySources
            local S = { 'lazy', 'packspec' }

            if not is_root() and require('config.util').luarocks_check() then
                --- If `luarocks` is available and configured
                table.insert(S, 'rockspec')
            end

            return S
        end)(),
    },

    dev = {
        path = '~/Projects/nvim',
        patterns = {},
        fallback = true,
    },

    change_detection = {
        enabled = true,
        notify = Archlinux:validate(),
    },

    checker = {
        enabled = not Termux:validate(),
        notify = Archlinux:validate(),
        frequency = 900,
        check_pinned = false,
    },

    ui = {
        backdrop = not in_console() and 60 or 100,
        border = 'double',
        title = 'L        A        Z        Y',
        wrap = true,
        title_pos = 'center',
        pills = true,
    },

    readme = {
        enabled = true,
        root = README_PATH,
        files = { 'README.md', 'lua/**/README.md' },

        -- only generate markdown helptags for plugins that dont have docs
        skip_if_doc_exists = true,
    },

    state = LAZY_STATE .. '/state.json',

    profiling = {
        -- Enables extra stats on the debug tab related to the loader cache.
        -- Additionally gathers stats about all package.loaders
        loader = true,
        -- Track each new require in the Lazy profiling tab
        require = true,
    },
}

Lazy.setup(Config)

---@type AllMaps
local Keys = {
    ['<leader>L'] = { group = '+Lazy' },
    ['<leader>Le'] = { group = '+Edit Lazy File' },

    ['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
    ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
    ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
    ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },

    ['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
    ['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
    ['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
    ['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
    ['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
    -- ['<leader>Lr'] = { Lazy.reload, desc('Reload Lazy Plugins') },

    ['<leader>LL'] = { ':Lazy ', desc('Select `Lazy` Operation (Interactively)', false) },
}

Keymaps({ n = Keys })

---@type Config.Lazy
local M = {}

---@return table|CscMod|fun(color?: string, ...)
function M.colorschemes()
    return require('plugin.colorschemes')
end

---@return table|Lsp.Server|fun()
function M.lsp()
    return require('plugin.lsp')
end

User:register_plugin('config.lazy', 1) -- Always put it on first place

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
