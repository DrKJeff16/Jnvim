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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
