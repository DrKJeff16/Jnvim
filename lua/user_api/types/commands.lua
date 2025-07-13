---@meta

error('(user_api.types.commands): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@alias CtxFun fun(ctx: table)
---@alias User.Commands.Mappings AllModeMaps

---@class User.Commands.CtxSpec
---@field [1] CtxFun
---@field [2] vim.api.keyset.user_command
---@field mappings? User.Commands.Mappings

---@alias User.Commands.Spec table<string, User.Commands.CtxSpec>

---@class User.Commands
---@field commands User.Commands.Spec
---@field new_command fun(self: User.Commands, name: string, C: table|User.Commands.CtxSpec)
---@field setup fun(self: User.Commands)
---@field setup_keys fun(self: User.Commands)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
