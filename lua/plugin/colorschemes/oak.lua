---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
    mod_pfx = 'plugin.colorschemes.oak',
    mod_cmd = 'colorscheme oak',
}

if vim.g.installed_oak == 1 then
    function M.setup()
        vim.cmd(M.mod_cmd)
    end
end

return M
