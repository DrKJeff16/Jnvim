---@meta

error('(user_api.types.opts): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@alias User.Opts.Spec table|vim.bo|vim.wo

---@alias User.Opts.CallerFun fun(override: table|User.Opts.Spec?, verbose: boolean?)

---@class User.Opts
---@field optset fun(self: User.Opts, opts: User.Opts.Spec, verbose: boolean?)
---@field toggleable string[]
---@field long_opts_convert fun(T: User.Opts.Spec, verbose: boolean?): parsed_opts: User.Opts.Spec
---@field get_all_opts fun(): table<string, string>
---@field DEFAULT_OPTIONS User.Opts.Spec
---@field options User.Opts.Spec
---@field print_set_opts fun()
---@field setup_keys fun(self: User.Opts)
---@field new fun(O: table?):table|User.Opts|fun(override: table|User.Opts.Spec?, verbose: boolean?)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
