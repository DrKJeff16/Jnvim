---@class OakSubMod
local Oak = {}

Oak.mod_cmd = 'silent! colorscheme oak'

---@return boolean
function Oak.valid()
    return vim.g.installed_oak == 1
end

function Oak.setup()
    vim.cmd(Oak.mod_cmd)
end

return Oak

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
