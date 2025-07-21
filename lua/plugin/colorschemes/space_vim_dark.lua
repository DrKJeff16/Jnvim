---@diagnostic disable:missing-fields

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@class SpaceVimSubMod
local SpaceVimDark = {}

SpaceVimDark.mod_cmd = 'silent! colorscheme space-vim-dark'

---@return boolean
function SpaceVimDark.valid()
    return vim.g.installed_space_vim_dark
end

---@param self SpaceVimSubMod
function SpaceVimDark:setup()
    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|SpaceVimSubMod
function SpaceVimDark.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = SpaceVimDark })
end

User:register_plugin('plugin.colorschemes.space_vim_dark')

return SpaceVimDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
