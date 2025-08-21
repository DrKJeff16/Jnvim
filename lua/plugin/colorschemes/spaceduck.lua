---@class SpaceDuckSubMod
local SpaceDuck = {}

SpaceDuck.mod_cmd = 'silent! colorscheme spaceduck'

---@return boolean
function SpaceDuck.valid()
    return vim.g.installed_spaceduck == 1
end

function SpaceDuck.setup()
    vim.cmd(SpaceDuck.mod_cmd)
end

return SpaceDuck

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
