---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local modules = Check.exists.modules
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local Gloombuddy = {
    mod_cmd = 'colorscheme gloombuddy',
}

if modules({ 'colorbuddy', 'gloombuddy' }) then
    User:register_plugin('plugin.colorschemes.gloombuddy')
end

function Gloombuddy:setup()
    require('colorbuddy').colorscheme('gloombuddy')
    vim.cmd(self.mod_cmd)
end

function Gloombuddy.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Gloombuddy })
end

return Gloombuddy

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
