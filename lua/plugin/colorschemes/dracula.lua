---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local csc_t = User.types.colorschemes

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme dracula',
    mod_pfx = 'plugin.colorschemes.dracula',
}

if vim.g.installed_dracula == 1 then
    function M.setup()
        vim.cmd(M.mod_cmd)
    end
end

return M
