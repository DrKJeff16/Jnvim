---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local is_tbl = Check.value.is_tbl

---@type CscSubMod
local Oak = {
    mod_cmd = 'silent! colorscheme oak',
}

---@return boolean
function Oak.valid() return vim.g.installed_oak == 1 end

---@param self CscSubMod
function Oak:setup() vim.cmd(self.mod_cmd) end

---@param O? table
---@return table|CscSubMod
function Oak.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Oak })
end

User:register_plugin('plugin.colorschemes.oak')

return Oak

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
