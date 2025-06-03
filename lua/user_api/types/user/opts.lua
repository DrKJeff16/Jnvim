---@meta

---@alias User.Opts.Spec table|vim.bo|vim.wo

---@class User.Opts
---@field optset fun(self: User.Opts, opts: User.Opts.Spec)
---@field setup fun(self: User.Opts, override: User.Opts.Spec?, verbose: boolean?)
---@field ALL_OPTIONS table<string, string>
---@field DEFAULT_OPTIONS User.Opts.Spec
---@field options User.Opts.Spec
---@field print_set_opts fun(self: User.Opts)
---@field setup_maps fun(self: User.Opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
