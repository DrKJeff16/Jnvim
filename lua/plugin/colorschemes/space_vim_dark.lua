---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@type CscSubMod
local SpaceVimDark = {
    mod_cmd = 'colorscheme space-vim-dark',
}

---@return boolean
function SpaceVimDark.valid() return vim.g.installed_space_vim_dark end

function SpaceVimDark:setup() vim.cmd(self.mod_cmd) end

---@param O? table
---@return table|CscSubMod
function SpaceVimDark.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = SpaceVimDark })
end

User:register_plugin('plugin.colorschemes.space_vim_dark')

return SpaceVimDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
