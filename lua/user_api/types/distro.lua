---@meta

error('(user_api.types.distro): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@class User.Distro.Spec
---@field rtpaths string[]
---@field validate fun(self: User.Distro.Spec): boolean
---@field setup fun(self: User.Distro.Spec)
---@field new fun(self: User.Distro.Spec?): table|User.Distro.Spec

---@class User.Distro.Archlinux: User.Distro.Spec
---@field validate fun(self: User.Distro.Archlinux): boolean
---@field setup fun(self: User.Distro.Archlinux)
---@field new fun(self: User.Distro.Archlinux?): table|User.Distro.Archlinux

---@class User.Distro.Termux: User.Distro.Spec
---@field PREFIX string|''
---@field validate fun(self: User.Distro.Termux): boolean
---@field setup fun(self: User.Distro.Termux)
---@field new fun(self: User.Distro.Termux?): table|User.Distro.Termux

---@class User.Distro
---@field archlinux User.Distro.Archlinux
---@field termux User.Distro.Termux
---@field new fun(O: table?): table|User.Distro|fun(verbose: boolean?)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
