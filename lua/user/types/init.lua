---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class User.Types
---@field user UserSubTypes
---@field autopairs table
---@field cmp table
---@field colorizer table
---@field colorschemes table
---@field comment table
---@field galaxyline table
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
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table.
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
    user = require('user.types.user'),

    --- Plugin config-related annotations below

    autopairs = require('user.types.autopairs'),
    colorizer = require('user.types.colorizer'),
    colorschemes = require('user.types.colorschemes'),
    cmp = require('user.types.cmp'),
    comment = require('user.types.comment'),
    galaxyline = require('user.types.galaxyline'),
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
