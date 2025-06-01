---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local is_tbl = Check.value.is_tbl

---@type CscSubMod
local Oak = {
    mod_cmd = 'colorscheme oak',
    setup = nil,
}

if vim.g.installed_oak == 1 then
    User:register_plugin('plugin.colorschemes.oak')

    function Oak:setup(variant, transparent, override) vim.cmd(self.mod_cmd) end
end

function Oak.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Oak })
end

return Oak

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
