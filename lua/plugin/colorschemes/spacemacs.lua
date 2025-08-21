---@class SpacemacsSubMod
local Spacemacs = {}

Spacemacs.mod_cmd = 'silent! colorscheme spacemacs-theme'

---@return boolean
function Spacemacs.valid()
    return vim.g.installed_spacemacs == 1
end

function Spacemacs.setup()
    vim.cmd(Spacemacs.mod_cmd)
end

return Spacemacs

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
