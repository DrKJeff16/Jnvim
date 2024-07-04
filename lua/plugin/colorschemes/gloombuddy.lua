---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
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
    function M.setup(variant, transparent, override)
        require('colorbuddy').colorscheme('gloombuddy')
        vim.cmd(M.mod_cmd)
    end
end

function M.new()
    return setmetatable({}, { __index = M })
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
