---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')

local is_tbl = User.check.value.is_tbl

---@type CscSubMod
local Molokai = {
    mod_cmd = 'colorscheme molokai',
    setup = nil,
}

if vim.g.installed_molokai == 1 then
    User:register_plugin('plugin.colorschemes.molokai')

    function Molokai:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end
end

function Molokai.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Molokai })
end

return Molokai

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
