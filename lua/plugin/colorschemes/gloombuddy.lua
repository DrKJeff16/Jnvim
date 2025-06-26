---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local type_not_empty = Check.value.type_not_empty
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local Gloombuddy = {
    mod_cmd = 'silent! colorscheme gloombuddy',
}

---@return boolean
function Gloombuddy.valid()
    return (
        type_not_empty('integer', vim.g.installed_colorbuddy)
        and type_not_empty('integer', vim.g.installed_gloombuddy)
    )
end

function Gloombuddy:setup()
    require('colorbuddy').colorscheme('gloombuddy')
    vim.cmd(self.mod_cmd)
end

function Gloombuddy.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Gloombuddy })
end

User:register_plugin('plugin.colorschemes.gloombuddy')

return Gloombuddy

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
