---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class User.Types
---@field user UserSubTypes
---@field autopairs table
---@field cmp table
---@field colorizer table
---@field colorschemes table
---@field comment table
---@field diffview table
---@field gitsigns table
---@field lazy table
---@field lspconfig table
---@field lualine table
---@field mini table
---@field notify table
---@field nvim_tree table
---@field telescope table
---@field todo_comments table
---@field toggleterm table
---@field treesitter table
---@field which_key table

---@class User.Opts

---@class User.Distro.Distrospec
---@field setup fun()

---@class User.Distro.Archlinux: User.Distro.Distrospec

---@class User.Distro
---@field archlinux? User.Distro.Archlinux

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table.
---@alias Maps table<'n'|'i'|'v'|'t'|'o'|'x', table<string, KeyMapRhsOptsArr>>

---@class PluginDependency
---@field enabled boolean
---@field required_by string[]

---@alias PluginKey boolean|PluginDependency

---@class User.ActivationFlags.Plugins.Spec
---@field conflicting? string[][]|nil

---@class User.ActivationFlags.Plugins.Essentials: User.ActivationFlags.Plugins.Spec
---@field startuptime? PluginKey
---@field which_key? PluginKey
---@field luarocks? PluginKey
---@field notify? PluginKey
---@field plenary? PluginKey
---@field mini? PluginKey
---@field scope? PluginKey
---@field nvim_web_devicons? PluginKey
---@field hover? PluginKey

---@class User.ActivationFlags.Plugins.Editing: User.ActivationFlags.Plugins.Spec
---@field persistence PluginKey
---@field persisted PluginKey
---@field comment PluginKey
---@field endwise PluginKey
---@field todo_comments PluginKey
---@field autopairs PluginKey
---@field template PluginKey

---@class User.ActivationFlags.Plugins.Completion: User.ActivationFlags.Plugins.Spec
---@field cmp PluginKey
---@field luasnip PluginKey
---@field vlime PluginKey
---@field coc PluginKey

---@class User.ActivationFlags.Plugins.Utils: User.ActivationFlags.Plugins.Spec
---@field mkdp PluginKey

---@class User.ActivationFlags.Plugins.Syntax: User.ActivationFlags.Plugins.Spec
---@field codeowners PluginKey
---@field doxygen_toolkit PluginKey

---@class User.ActivationFlags.Plugins.Neorg: User.ActivationFlags.Plugins.Spec
---@field neorg PluginKey
---@field zen_mode PluginKey

---@class User.ActivationFlags.Plugins.Lsp: User.ActivationFlags.Plugins.Spec
---@field lspconfig PluginKey
---@field schemastore PluginKey
---@field clangd PluginKey
---@field neoconf PluginKey
---@field lazydev PluginKey
---@field inc_rename PluginKey

---@class User.ActivationFlags.Plugins.UI: User.ActivationFlags.Plugins.Spec
---@field lualine PluginKey
---@field galaxyline PluginKey
---@field noice PluginKey
---@field bufferline PluginKey
---@field barbar PluginKey
---@field ibl PluginKey
---@field rainbow_delimiters PluginKey
---@field nvim_tree PluginKey
---@field neo_tree PluginKey
---@field colorful_winsep PluginKey
---@field hicolors PluginKey
---@field toggleterm PluginKey
---@field comment_box PluginKey
---@field dashboard PluginKey
---@field startup PluginKey
---@field alpha PluginKey

---@class User.ActivationFlags.Plugins.Telescope: User.ActivationFlags.Plugins.Spec
---@field telescope PluginKey
---@field file_browser PluginKey
---@field fzf_native PluginKey
---@field project PluginKey

---@class User.ActivationFlags.Plugins.TS: User.ActivationFlags.Plugins.Spec
---@field ts PluginKey
---@field context PluginKey
---@field commentstring PluginKey
---@field textobjects PluginKey

---@class User.ActivationFlags.Plugins.VCS: User.ActivationFlags.Plugins.Spec
---@field fugitive PluginKey
---@field gitsigns PluginKey
---@field diffview PluginKey
---@field lazygit PluginKey

---@alias User.ActivationFlags.Plugins.Csc table<string, PluginKey>|User.ActivationFlags.Plugins.Spec

---@class User.ActivationFlags.Plugins
---@field colorschemes User.ActivationFlags.Plugins.Csc
---@field completion User.ActivationFlags.Plugins.Completion|User.ActivationFlags.Plugins.Csc
---@field editing User.ActivationFlags.Plugins.Editing|User.ActivationFlags.Plugins.Csc
---@field essentials User.ActivationFlags.Plugins.Essentials|User.ActivationFlags.Plugins.Csc
---@field lsp User.ActivationFlags.Plugins.Lsp|User.ActivationFlags.Plugins.Csc
---@field syntax User.ActivationFlags.Plugins.Syntax|User.ActivationFlags.Plugins.Csc
---@field telescope User.ActivationFlags.Plugins.Telescope|User.ActivationFlags.Plugins.Csc
---@field treesitter User.ActivationFlags.Plugins.TS|User.ActivationFlags.Plugins.Csc
---@field ui User.ActivationFlags.Plugins.UI|User.ActivationFlags.Plugins.Csc
---@field utils User.ActivationFlags.Plugins.Utils|User.ActivationFlags.Plugins.Csc
---@field vcs User.ActivationFlags.Plugins.VCS|User.ActivationFlags.Plugins.Csc

---@class User.ActivationFlags.Autocmds
---@field jeffs_defaults boolean

---@class User.ActivationFlags
---@field plugins User.ActivationFlags.Plugins
---@field autocmds User.ActivationFlags.Autocmds

---@class User
---@field check User.Check
---@field maps User.Maps
---@field distro User.Distro
---@field highlight User.Hl
---@field opts User.Opts
---@field types User.Types
---@field util User.Util
---@field update User.Update
---@field commands User.Commands
---@field setup fun(opts: User.ActivationFlags?)

---@type User.Types
local M = {
    --- API-related annotations
    user = require('user.types.user'),

    --- Plugin config-related annotations below

    autopairs = require('user.types.autopairs'),
    colorizer = require('user.types.colorizer'),
    colorschemes = require('user.types.colorschemes'),
    cmp = require('user.types.cmp'),
    comment = require('user.types.comment'),
    diffview = require('user.types.diffview'),
    gitsigns = require('user.types.gitsigns'),
    lazy = require('user.types.lazy'),
    lspconfig = require('user.types.lspconfig'),
    lualine = require('user.types.lualine'),
    mini = require('user.types.mini'),
    notify = require('user.types.notify'),
    nvim_tree = require('user.types.nvim_tree'),
    telescope = require('user.types.telescope'),
    todo_comments = require('user.types.todo_comments'),
    toggleterm = require('user.types.toggleterm'),
    treesitter = require('user.types.treesitter'),
    which_key = require('user.types.which_key'),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
