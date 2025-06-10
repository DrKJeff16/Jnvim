---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@type CscSubMod
local Spacemacs = {
    mod_cmd = 'colorscheme spacemacs-theme',
    setup = nil,
}

if vim.g.installed_spacemacs == 1 then
    User:register_plugin('plugin.colorschemes.spacemacs')

    function Spacemacs:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end
end

function Spacemacs.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Spacemacs })
end

return Spacemacs

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
