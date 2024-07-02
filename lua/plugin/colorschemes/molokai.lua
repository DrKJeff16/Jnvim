---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local csc_t = User.types.colorschemes

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme molokai',
}

if vim.g.installed_molokai == 1 then
    function M:setup(variant, transparent, override)
        vim.cmd(self.mod_cmd)
    end
end

function M.new()
    return setmetatable({}, { __index = M })
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
