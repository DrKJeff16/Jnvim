---@diagnostic disable:missing-fields

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@class SpaceDuckSubMod
local SpaceDuck = {}

SpaceDuck.mod_cmd = 'silent! colorscheme spaceduck'

---@return boolean
function SpaceDuck.valid()
    return vim.g.installed_spaceduck == 1
end

---@param self SpaceDuckSubMod
function SpaceDuck:setup()
    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|SpaceDuckSubMod
function SpaceDuck.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = SpaceDuck })
end

User:register_plugin('plugin.colorschemes.spaceduck')

return SpaceDuck

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
