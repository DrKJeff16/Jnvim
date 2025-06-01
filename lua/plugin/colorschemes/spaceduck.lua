---@diagnostic disable:missing-fields

local User = require('user_api')
local csc_t = User.types.colorschemes

local is_tbl = User.check.value.is_tbl

---@type CscSubMod
local SpaceDuck = {
    mod_cmd = 'colorscheme spaceduck',
    setup = nil,
}

if vim.g.installed_spaceduck == 1 then
    User:register_plugin('plugin.colorschemes.spaceduck')

    function SpaceDuck:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end
end

function SpaceDuck.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = SpaceDuck })
end

return SpaceDuck

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
