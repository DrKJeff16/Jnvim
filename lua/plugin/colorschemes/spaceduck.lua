local User = require('user_api')
local csc_t = User.types.colorschemes

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme spaceduck',
    setup = nil,
}

if vim.g.installed_spaceduck == 1 then
    User:register_plugin('plugin.colorschemes.spaceduck')

    function M.setup(variant, transparent, override) vim.cmd(M.mod_cmd) end
end

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
