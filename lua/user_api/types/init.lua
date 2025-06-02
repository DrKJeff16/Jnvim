---@meta

---@diagnostic disable:missing-fields

---@class User.Types
---@field user UserSubTypes
---@field autopairs nil
---@field cmp nil
---@field colorizer nil
---@field colorschemes nil
---@field comment nil
---@field diffview nil
---@field gitsigns nil
---@field lazy nil
---@field lspconfig nil
---@field lualine nil
---@field mini nil
---@field notify nil
---@field nvim_tree nil
---@field telescope nil
---@field todo_comments nil
---@field toggleterm nil
---@field treesitter nil
---@field which_key nil

---@class User.Distro.Spec
---@field setup fun(self: User.Distro.Spec)

---@class User.Distro.Archlinux: User.Distro.Spec
---@field setup fun(self: User.Distro.Archlinux)

---@class User.Distro.Termux: User.Distro.Spec
---@field setup fun(self: User.Distro.Termux)

---@class User.Distro
---@field archlinux User.Distro.Archlinux
---@field termux User.Distro.Termux

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table
---@alias Maps table<'n'|'i'|'v'|'t'|'o'|'x', table<string, KeyMapRhsOptsArr>>

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
---@field registered_plugins string[]
---@field register_plugin fun(self: User, pathstr: string, i: integer?)
---@field reload_plugins fun(self: User): (failed: string[]|nil)
---@field setup_keys fun(self: User)
---@field new fun(O: table?): User|table
---@field print_loaded_plugins fun(self: User)

---@type User.Types
local Types = {}

-- API-related annotations
Types.user = require('user_api.types.user')

-- Plugin config-related annotations below
Types.autopairs = require('user_api.types.autopairs')
Types.colorizer = require('user_api.types.colorizer')
Types.colorschemes = require('user_api.types.colorschemes')
Types.cmp = require('user_api.types.cmp')
Types.comment = require('user_api.types.comment')
Types.diffview = require('user_api.types.diffview')
Types.gitsigns = require('user_api.types.gitsigns')
Types.lazy = require('user_api.types.lazy')
Types.lspconfig = require('user_api.types.lspconfig')
Types.lualine = require('user_api.types.lualine')
Types.mini = require('user_api.types.mini')
Types.notify = require('user_api.types.notify')
Types.nvim_tree = require('user_api.types.nvim_tree')
Types.telescope = require('user_api.types.telescope')
Types.todo_comments = require('user_api.types.todo_comments')
Types.toggleterm = require('user_api.types.toggleterm')
Types.treesitter = require('user_api.types.treesitter')
Types.which_key = require('user_api.types.which_key')

return Types

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
