local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local modules = Check.exists.modules

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme gloombuddy',
    setup = nil,
}

if modules({ 'colorbuddy', 'gloombuddy' }) then
    User:register_plugin('plugin.colorschemes.gloombuddy')

    function M.setup(variant, transparent, override)
        require('colorbuddy').colorscheme('gloombuddy')
        vim.cmd(M.mod_cmd)
    end
end

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
