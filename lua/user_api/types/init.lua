---@meta

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
---@field setup fun()

---@class User.Distro.Archlinux: User.Distro.Spec

---@class User.Distro
---@field archlinux? User.Distro.Archlinux

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
---@field register_plugin fun(path: string)
---@field reload_plugins fun(self: User): string[]?
---@field new fun(o: table?): User

---@type User.Types
local M = {
    --- API-related annotations
    user = require('user_api.types.user'),

    --- Plugin config-related annotations below

    autopairs = require('user_api.types.autopairs'),
    colorizer = require('user_api.types.colorizer'),
    colorschemes = require('user_api.types.colorschemes'),
    cmp = require('user_api.types.cmp'),
    comment = require('user_api.types.comment'),
    diffview = require('user_api.types.diffview'),
    gitsigns = require('user_api.types.gitsigns'),
    lazy = require('user_api.types.lazy'),
    lspconfig = require('user_api.types.lspconfig'),
    lualine = require('user_api.types.lualine'),
    mini = require('user_api.types.mini'),
    notify = require('user_api.types.notify'),
    nvim_tree = require('user_api.types.nvim_tree'),
    telescope = require('user_api.types.telescope'),
    todo_comments = require('user_api.types.todo_comments'),
    toggleterm = require('user_api.types.toggleterm'),
    treesitter = require('user_api.types.treesitter'),
    which_key = require('user_api.types.which_key'),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
