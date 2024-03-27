---@alias VimOption
---|string
---|number
---|boolean
---|table

---@alias ModTbl
---|string[]
---|{ [string]: string }
---|table<string, boolean>

---@alias OptPairTbl table<string, VimOption>

---@alias MapOpts vim.api.keyset.keymap

---@class OptsTbl
---@field set? OptPairTbl
---@field opt? OptPairTbl
---|table

---@class MapTbl
---@field lhs string
---@field rhs string
---@field opts? MapOpts

---@class UserOptsMod
---@field pfx? string
---@field __index? UserOptsMod
---@field opt_tbl OptsTbl
---@field new? fun(): UserOptsMod
---@field optset fun(opts: OptPairTbl, vim_tbl?: table)
---@field setup? fun(self?: UserOptsMod)

---@class UserMod
---@field pfx? string
---@field cond? table
---@field opts fun(): UserOptsMod
---@field new fun(self: UserMod, prefix?: string): UserMod
---@field multisrc? fun(self: UserMod, mods: ModTbl, prefix: string): any
---@field exists fun(mod: string): boolean
---@field assoc fun()
