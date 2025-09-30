local exists = require('user_api.check.exists').module

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class AriakeSubMod
local Template = {}

---@class AriakeSubMod.Variants
Template.variants = {}

Template.mod_cmd = 'silent! colorscheme ariake'

---@return boolean
function Template.valid()
    return exists('ariake')
end

function Template.setup()
    require('ariake').setup()
    vim.cmd(Template.mod_cmd)
end

return Template

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
