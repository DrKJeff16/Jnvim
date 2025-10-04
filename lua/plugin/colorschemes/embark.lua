---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class EmbarkSubMod
local Embark = {}

Embark.mod_cmd = 'silent! colorscheme embark'

---@return boolean
function Embark.valid()
    return vim.g.installed_embark == 1
end

function Embark.setup()
    vim.o.termguicolors = true
    vim.cmd(Embark.mod_cmd)
end

return Embark
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
