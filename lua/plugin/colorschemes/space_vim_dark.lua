---@diagnostic disable:missing-fields

local User = require('user_api')
local csc_t = User.types.colorschemes

local is_tbl = User.check.value.is_tbl

---@type CscSubMod
local SpaceVimDark = {
    mod_cmd = 'colorscheme space-vim-dark',
    setup = nil,
}

if vim.g.installed_space_vim_dark then
    User:register_plugin('plugin.colorschemes.space_vim_dark')

    function SpaceVimDark:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end
end

function SpaceVimDark.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = SpaceVimDark })
end

return SpaceVimDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
