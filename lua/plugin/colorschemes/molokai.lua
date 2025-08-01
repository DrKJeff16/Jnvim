---@diagnostic disable:missing-fields

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@class MolokaiSubMod
local Molokai = {}

Molokai.mod_cmd = 'silent! colorscheme molokai'

---@return boolean
function Molokai.valid()
    return vim.g.installed_molokai == 1
end

---@param self MolokaiSubMod
function Molokai:setup()
    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|MolokaiSubMod
function Molokai.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Molokai })
end

User.register_plugin('plugin.colorschemes.molokai')

return Molokai

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
