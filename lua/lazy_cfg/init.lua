---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lazy
local Util = User.util
local Maps = User.maps
local kmap = Maps.kmap
local WK = Maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local env_vars = Check.exists.env_vars
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_fun = Check.value.is_fun
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local in_console = Check.in_console
local desc = kmap.desc
local map_dict = Maps.map_dict

--- Set installation dir for `Lazy`.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

--- Install `Lazy` automatically.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end

--- Add `Lazy` to runtimepath
vim.opt.rtp:prepend(lazypath)

--- Returns the string for the `build` field for `LuaSnip` depending on certain conditions.
---
--- ## Return
---
--- ### Unix
--- **The return string could be empty** or something akin to
--- ```sh
--- $ make install_jsregexp
--- ```
--- If `nproc` is found in `PATH` or a valid executable then the string could look like
--- ```sh
--- $ make -j"$(nproc)" install_jsregexp
--- ```
--- ### Windows
--- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
--- ---
---@return string
local function luasnip_build()
    local cmd = executable('nproc') and 'make -j"$(nproc)" install_jsregexp' or 'make install_jsregexp'

    if is_windows and executable('mingw32-make') then
        cmd = 'mingw32-' .. cmd
    elseif is_windows and not executable('make') then
        cmd = ''
    end

    return cmd
end

---@return boolean
local function luarocks_set()
    return executable('luarocks') and env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

--- Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions.
---
--- ## Return
---
--- ### Unix
--- **The return string could be empty** or something akin to
--- ```sh
--- $ make
--- ```
--- If `nproc` is found in `PATH` or a valid executable then the string could look like
--- ```sh
--- $ make -j"$(nproc)"
--- ```
--- ### Windows
--- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
--- If unsuccessful, **it'll return an empty string**.
--- ---
---@return string
local function tel_fzf_build()
    local cmd = executable('nproc') and 'make -j"$(nproc)"' or 'make'

    if is_windows and executable('mingw32-make') then
        cmd = 'mingw32-' .. cmd
    elseif not executable('make') then
        cmd = ''
    end

    return cmd
end

--- A `config` function to call your plugins.
---
--- ## Parameters
--- * `mod_str` This parameter must comply with the following format:
---```lua
--- source('lazy_cfg.<plugin_name>[.<...>]')
--- ```
--- as all the plugin configs MUST BE IN the repo's `lua/lazy_cfg/` directory.
--- **_That being said_**, you can use any module path if you wish to do so.
---
--- ## Return
--- A function that attempts to `require` the given `mod_str`.
--- ---
---@param mod_str string
---@return fun()
local function source(mod_str)
    return function()
        exists(mod_str, true)
    end
end

--- Set the global condition for a later submodule call.
---
--- ## Parameters
--- * `field`: Either a `string` that will be the name of a vim `g:...` variable, or
--- a `dictionary` with the keys as the vim `g:...` variable names, and the value
--- as whatever said variables are set to respectively.
---
--- ## Return
--- A `function` that sets the pre-loading for the colorscheme and initializes the `g:field` variable(s).
--- ---
---@param fields string|table<string, any>
---@return fun()
local function colorscheme_init(fields)
    if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
        error('(lazy_cfg:colorscheme_init): Unable to initialize colorscheme.')
    end

    return function()
        vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()

        if is_str(fields) then
            vim.g[fields] = 1
        else
            for field, val in next, fields do
                vim.g[field] = val
            end
        end
    end
end

local Lazy = require('lazy')

---@type table<string, LazyPlugs>
local M = {}

--- Colorscheme Plugins
M.COLORSCHEMES = {
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        main = 'onedark',
        version = false,
        init = colorscheme_init('installed_onedark'),
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        main = 'catppuccin',
        version = false,
        init = colorscheme_init('installed_catppuccin'),
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        main = 'tokyonight',
        version = false,
        init = colorscheme_init('installed_tokyonight'),
    },
    {
        'EdenEast/nightfox.nvim',
        priority = 1000,
        main = 'nightfox',
        version = false,
        init = colorscheme_init('installed_nightfox'),
    },
    {
        'bkegley/gloombuddy',
        priority = 1000,
        version = false,
        dependencies = { 'colorbuddy.vim' },
        init = colorscheme_init('installed_gloombuddy'),
    },
    {
        'vigoux/oak',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init({
            ['installed_oak'] = 1,
            ['oak_virtualtext_bg'] = 1,
        }),
    },
    {
        'tjdevries/colorbuddy.vim',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_colorbuddy'),
    },
    {
        'pineapplegiant/spaceduck',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_spaceduck'),
    },
    {
        'dracula/vim',
        lazy = false,
        priority = 1000,
        name = 'dracula',
        version = false,
        init = colorscheme_init('installed_dracula'),
    },
    {
        'liuchengxu/space-vim-dark',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_space_vim_dark'),
    },
    {
        'tomasr/molokai',
        lazy = false,
        priority = 1000,
        version = false,
        init = colorscheme_init('installed_molokai'),
    },
    {
        'colepeters/spacemacs-theme.vim',
        lazy = false,
        priority = 1000,
        name = 'spacemacs',
        version = false,
        init = colorscheme_init('installed_spacemacs'),
    },
}
--- Essential Plugins
M.ESSENTIAL = {
    {
        'dstein64/vim-startuptime',
        version = false,
        init = function()
            vim.g.installed_startuptime = 1
        end,
        config = source('lazy_cfg.startuptime'),
    },
    {
        'vhyrro/luarocks.nvim',
        lazy = false,
        priority = 1000,
        version = false,
        config = source('lazy_cfg.luarocks'),
        enabled = luarocks_set(),
    },
    {
        'folke/zen-mode.nvim',
        version = false,
        config = source('lazy_cfg.zen_mode'),
    },
    {
        'nvim-neorg/neorg',
        version = false,
        config = source('lazy_cfg.neorg'),
        enabled = luarocks_set(),
    },
    {
        'vim-scripts/L9',
        lazy = false,
        version = false,
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = source('lazy_cfg.mini'),
        enabled = not in_console(),
    },
    {
        'tiagovla/scope.nvim',
        version = false,
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.hid = true

            --- NOTE: Required for `scope`
            vim.opt.sessionoptions = {
                'buffers',
                'tabpages',
                'globals',
            }
        end,
        config = source('lazy_cfg.scope'),
    },

    {
        'nvim-lua/plenary.nvim',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },

    {
        'rcarriga/nvim-notify',
        main = 'notify',
        version = false,
        dependencies = { 'plenary.nvim' },
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.notify'),
        enabled = not in_console(),
    },

    {
        'lewis6991/hover.nvim',
        main = 'hover',
        version = false,
        config = source('lazy_cfg.hover'),
        enabled = not in_console(),
    },

    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },
}

--- Nvim Configurations
M.NVIM = {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        main = 'which-key',
        version = false,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
            vim.opt.ttimeout = true
            vim.opt.ttimeoutlen = -1
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.which_key'),
        enabled = vim_has('nvim-0.9'),
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        config = source('lazy_cfg.dashboard'),
        enabled = false,
    },
    {
        'startup-nvim/startup.nvim',
        event = 'VimEnter',
        version = false,
        dependencies = {
            'telescope.nvim',
            'plenary.nvim',
        },
        config = source('lazy_cfg.startup'),
        enabled = false,
    },
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('lazy_cfg.persistence'),
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        lazy = false,
        version = false,
        config = source('lazy_cfg.persisted'),
    },
}

--- Treesitter Plugins
M.TS = {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        version = false,
        dependencies = {
            'nvim-treesitter-context',
            'nvim-ts-context-commentstring',
            'nvim-treesitter-textobjects',
        },
        config = source('lazy_cfg.treesitter'),
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        version = false,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
        version = false,
    },
}
--- Editing Utils
M.EDITING = {
    {
        'numToStr/Comment.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter',
            'nvim-ts-context-commentstring',
        },
        config = source('lazy_cfg.Comment'),
    },

    {
        'tpope/vim-endwise',
        lazy = false,
        version = false,
    },
    --- TODO COMMENTS
    {
        'folke/todo-comments.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter',
            'plenary.nvim',
        },
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.todo_comments'),
        enabled = executable('rg') and not in_console(),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        version = false,
        config = source('lazy_cfg.autopairs'),
    },
    {
        'glepnir/template.nvim',
        version = false,
        config = source('lazy_cfg.template'),
        enabled = false,
    },
}
--- Version Control Plugins
M.VCS = {
    {
        'tpope/vim-fugitive',
        lazy = false,
        version = false,
        enabled = executable('git'),
    },
    {
        'lewis6991/gitsigns.nvim',
        version = false,
        config = source('lazy_cfg.gitsigns'),
        enabled = executable('git') and not in_console(),
    },
    {
        'sindrets/diffview.nvim',
        version = false,
        config = source('lazy_cfg.diffview'),
        enabled = executable('git'),
    },
    {
        'kdheepak/lazygit.nvim',
        version = false,
        dependencies = {
            'plenary.nvim',
            'telescope.nvim',
        },
        config = source('lazy_cfg.lazygit'),
        enabled = executable({ 'git', 'lazygit' }) and not in_console(),
    },
}
--- LSP Plugins
M.LSP = {
    {
        'neovim/nvim-lspconfig',
        version = false,
        dependencies = {
            'lazydev.nvim',
            'neoconf.nvim',
            'trouble.nvim',
            'SchemaStore',
        },
        config = source('lazy_cfg.lspconfig'),
        enabled = vim_has('nvim-0.8'), --- Constraint specified in the repo
    },
    {
        'b0o/SchemaStore',
        lazy = true,
        version = false,
        enabled = executable('vscode-json-language-server'),
    },
    --- Essential for Nvim Lua files.
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        version = false,
        dependencies = { 'Bilal2453/luvit-meta' },
        config = source('lazy_cfg.lspconfig.lazydev'),
        enabled = executable('lua-language-server'),
    },
    { 'Bilal2453/luvit-meta', lazy = true, version = false }, --- optional `vim.uv` typings
    {
        'folke/neoconf.nvim',
        lazy = false,
        version = false,
    },
    {
        'folke/trouble.nvim',
        lazy = false,
        version = false,
        dependencies = { 'nvim-web-devicons' },
        enabled = not in_console(),
    },
    {
        'p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp' },
        version = false,
        config = source('lazy_cfg.lspconfig.clangd'),
        enabled = executable('clangd') and not in_console(),
    },
    {
        'smjonas/inc-rename.nvim',
        config = source('lazy_cfg.lspconfig.inc_rename'),
    },
}
--- Completion and `cmp`-related Plugins
M.COMPLETION = {
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'neovim/nvim-lspconfig',
            'onsails/lspkind.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-document-symbol',
            'hrsh7th/cmp-nvim-lsp-signature-help',

            'hrsh7th/cmp-buffer',

            'hrsh7th/cmp-path',
            'https://codeberg.org/FelipeLema/cmp-async-path',

            'petertriho/cmp-git',
            'davidsierradz/cmp-conventionalcommits',

            'nvim-cmp-vlime',

            'hrsh7th/cmp-nvim-lua',

            'hrsh7th/cmp-cmdline',

            'cmp-doxygen',

            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
        },
        init = function()
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
            vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
        end,
        config = source('lazy_cfg.cmp'),
    },
    {
        'paopaol/cmp-doxygen',
        lazy = true,
        dependencies = {
            'nvim-treesitter',
            'nvim-treesitter-textobjects',
        },
    },
    {
        'L3MON4D3/LuaSnip',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = false,
        dependencies = { 'friendly-snippets' },
        build = luasnip_build(),
    },
    {
        'rafamadriz/friendly-snippets',
        ft = 'gitcommit',
        version = false,
    },
    {
        'HiPhish/nvim-cmp-vlime',
        ft = 'lisp',
        version = false,
        dependencies = { 'vlime' },
    },
    {
        'vlime/vlime',
        ft = 'lisp',
        version = false,
    },
}
--- Telescope
M.TELESCOPE = {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = {
            'telescope-file-browser.nvim',
            'telescope-fzf-native.nvim',
            'nvim-treesitter',
            'nvim-lspconfig',
            'plenary.nvim',
            'project.nvim',
        },
        config = source('lazy_cfg.telescope'),
        enabled = not in_console(),
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        lazy = true,
        version = false,
        dependencies = { 'plenary.nvim' },
        enabled = not in_console(),
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        lazy = true,
        version = false,
        build = tel_fzf_build(),
        enabled = executable('fzf') and not in_console(),
    },
    --- Project Manager
    {
        'ahmedkhalf/project.nvim',
        lazy = false,
        main = 'project_nvim',
        version = false,
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.o.autochdir = true
        end,
        config = source('lazy_cfg.project'),
    },
}
--- UI Plugins
M.UI = {
    --- Statusline
    {
        'nvim-lualine/lualine.nvim',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
        end,
        config = source('lazy_cfg.lualine'),
        cond = not is_nil(use_statusline) and (use_statusline == 'lualine') or false,
        enabled = not in_console(),
    },
    {
        'glepnir/galaxyline.nvim',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
            vim.opt.termguicolors = not in_console()
        end,
        config = source('lazy_cfg.galaxyline'),
        cond = not is_nil(use_statusline) and (use_statusline == 'galaxyline') or true,
        enabled = not in_console(),
    },
    --- Tabline
    {
        'akinsho/bufferline.nvim',
        version = false,
        dependencies = {
            'nvim-web-devicons',
            'scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.bufferline'),
        enabled = not in_console(),
    },
    --- Tabline
    {
        'romgrk/barbar.nvim',
        version = false,
        dependencies = {
            'gitsigns.nvim',
            'nvim-web-devicons',
            'scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.barbar'),
        -- enabled = not in_console(),
        enabled = false,
    },
    --- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        version = false,
        dependencies = { 'rainbow-delimiters.nvim' },
        config = source('lazy_cfg.blank_line'),
        enabled = not in_console(),
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        version = false,
        config = source('lazy_cfg.rainbow_delimiters'),
        enabled = not in_console(),
    },
    --- File Tree
    {
        'nvim-tree/nvim-tree.lua',
        main = 'nvim-tree',
        version = false,
        dependencies = {
            'nvim-web-devicons',
            'mini.nvim',
        },
        init = function()
            --- Disable `netrw`.
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.nvim_tree'),
        enable = not in_console(),
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = false,
        dependencies = {
            'plenary.nvim',
            'nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            --- '3rd/image.nvim',
        },
        init = function()
            --- Disable `netrw`.
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.neo_tree'),
        enabled = false,
    },
    {
        'nvim-zh/colorful-winsep.nvim',
        event = { 'WinNew' },
        version = false,
        config = source('lazy_cfg.colorful_winsep'),
        enabled = not in_console(),
    },
    {
        'brenoprata10/nvim-highlight-colors',
        main = 'nvim-highlight-colors',
        version = false,
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('lazy_cfg.hicolors'),
        enabled = vim_exists('+termguicolors'),
    },
    {
        'akinsho/toggleterm.nvim',
        version = false,
        config = source('lazy_cfg.toggleterm'),
        enabled = not in_console(),
    },
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'inc-rename.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-notify',
            'mini.nvim',
            'nvim-cmp',
            'nvim-treesitter',
        },
        config = source('lazy_cfg.noice'),
        enabled = not in_console(),
    },
    {
        'LudoPinelli/comment-box.nvim',
        version = false,
        config = source('lazy_cfg.commentbox'),
        --- enabled = not in_console(),
        enabled = false,
    },
}
--- File Syntax Plugins
M.SYNTAX = {
    {
        'rhysd/vim-syntax-codeowners',
        version = false,
    },
    {
        'vim-scripts/DoxygenToolkit.vim',
        version = false,
        enabled = executable('doxygen'),
    },
}

M.UTILS = {
    {
        'iamcco/markdown-preview.nvim',
        build = executable('yarn') and 'cd app && yarn install' or '',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        config = source('lazy_cfg.md_preview'),
        enabled = not in_console(),
    },
}

---@type LazyPlugs
local T = {}

--- INFO: Setup.
for _, plugs in next, M do
    for _, p in next, plugs do
        table.insert(T, p)
    end
end

if is_nil(called_lazy) then
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
        spec = T,
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
                return exists('pathspec')
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

    _G.called_lazy = true
end

---@type LazyMods
local P = {
    colorschemes = require('lazy_cfg.colorschemes'),
}

---@param cmd 'ed'|'tabnew'|'split'|'vsplit'
---@return fun()
local key_variant = function(cmd)
    cmd = (is_str(cmd) and vim.tbl_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'ed'

    cmd = cmd .. ' '

    return function()
        local full_cmd = cmd .. vim.fn.stdpath('config') .. '/lua/lazy_cfg/init.lua'

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
