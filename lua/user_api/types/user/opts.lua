---@meta

---@alias User.Opts.Spec table|vim.bo|vim.wo

---@class User.Opts
---@field optset fun(opts: User.Opts.Spec)
---@field setup fun(self: User.Opts, override: User.Opts.Spec?)
---@field protected options table<string, string>
---@field protected DEFAULT_OPTIONS table|vim.wo|vim.bo

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
