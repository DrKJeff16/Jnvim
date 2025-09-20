---@class MolokaiSubMod
local Molokai = {}

Molokai.mod_cmd = 'silent! colorscheme molokai'

---@return boolean
function Molokai.valid()
    return vim.g.installed_molokai == 1
end

function Molokai.setup()
    vim.cmd(Molokai.mod_cmd)
end

return Molokai

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
