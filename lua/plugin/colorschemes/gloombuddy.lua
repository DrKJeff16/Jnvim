---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme gloombuddy',
    mod_pfx = 'plugin.colorschemes.gloombuddy',
}

if exists('colorbuddy') then
    function M.setup()
        local Colorbuddy = require('colorbuddy')
        Colorbuddy.colorscheme('gloombuddy')

        vim.cmd(M.mod_cmd)
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
