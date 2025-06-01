---@meta

---@alias CtxFun fun(ctx: table): any?

---@class User.Commands.CtxSpec
---@field [1] CtxFun
---@field [2] vim.api.keyset.user_command

---@alias User.Commands.Spec table<string, User.Commands.CtxSpec>

---@class User.Commands
---@field commands User.Commands.Spec
---@field setup fun(self: User.Commands)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
