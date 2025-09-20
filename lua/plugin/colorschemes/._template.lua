local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class CscSubMod
local Template = {}

---@class CscSubMod.Variants
Template.variants = {}

Template.mod_cmd = 'silent! colorscheme template'

---@return boolean
function Template.valid()
    return exists('catppuccin')
end

function Template.setup()
    vim.cmd(Template.mod_cmd)
end

return Template

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
