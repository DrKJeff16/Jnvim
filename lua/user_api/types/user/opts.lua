---@meta

---@alias User.Opts.Spec table|vim.bo|vim.wo

---@class User.Opts
---@field optset fun(opts: User.Opts.Spec)
---@field setup fun(self: User.Opts, override: User.Opts.Spec?, verbose: boolean?): (msg: table?)
---@field ALL_OPTIONS table<string, string>
---@field DEFAULT_OPTIONS User.Opts.Spec

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
