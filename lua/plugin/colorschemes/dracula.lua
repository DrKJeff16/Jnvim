---@diagnostic disable:missing-fields

local User = require('user_api')
local csc_t = User.types.colorschemes

---@type CscSubMod
local Dracula = {
    mod_cmd = 'colorscheme dracula',
}

if vim.g.installed_dracula == 1 then
    User:register_plugin('plugin.colorschemes.dracula')
end

function Dracula:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end

function Dracula.new(O)
    O = User.check.value.is_tbl(O) and O or {}
    return setmetatable(O, { __index = Dracula })
end

return Dracula

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
