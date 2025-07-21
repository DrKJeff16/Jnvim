---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check

local is_tbl = Check.value.is_tbl

---@class OakSubMod
local Oak = {}

Oak.mod_cmd = 'silent! colorscheme oak'

---@return boolean
function Oak.valid()
    return vim.g.installed_oak == 1
end

---@param self OakSubMod
function Oak:setup()
    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|OakSubMod
function Oak.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Oak })
end

User:register_plugin('plugin.colorschemes.oak')

return Oak

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
