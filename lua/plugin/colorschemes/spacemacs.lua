---@diagnostic disable:missing-fields

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@class SpacemacsSubMod
local Spacemacs = {}

Spacemacs.mod_cmd = 'silent! colorscheme spacemacs-theme'

---@return boolean
function Spacemacs.valid()
    return vim.g.installed_spacemacs == 1
end

---@param self SpacemacsSubMod
function Spacemacs:setup()
    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|SpacemacsSubMod
function Spacemacs.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Spacemacs })
end

User.register_plugin('plugin.colorschemes.spacemacs')

return Spacemacs

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
