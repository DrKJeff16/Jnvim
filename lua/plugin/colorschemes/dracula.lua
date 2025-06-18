---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local is_tbl = Check.value.is_tbl

---@type DraculaSubMod
local Dracula = {
    mod_cmd = 'colorscheme dracula',
}

---@return boolean
function Dracula.valid() return vim.g.installed_dracula == 1 end

---@param self DraculaSubMod
function Dracula:setup() vim.cmd(self.mod_cmd) end

---@param O? table
function Dracula.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Dracula })
end

User:register_plugin('plugin.colorschemes.dracula')

return Dracula

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
