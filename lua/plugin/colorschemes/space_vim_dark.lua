---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local csc_t = User.types.colorschemes

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme space-vim-dark',
    mod_pfx = 'plugin.colorschemes.space_vim_dark',
}

if vim.g.installed_space_vim_dark then
    function M.setup()
        vim.cmd(M.mod_cmd)
    end
end

return M
