local User = require('user_api')
local Check = User.check

local type_not_empty = Check.value.type_not_empty

---@class GloombuddySubMod
local Gloombuddy = {}

Gloombuddy.mod_cmd = 'silent! colorscheme gloombuddy'

---@return boolean
function Gloombuddy.valid()
    return (
        type_not_empty('integer', vim.g.installed_colorbuddy)
        and type_not_empty('integer', vim.g.installed_gloombuddy)
    )
end

function Gloombuddy.setup()
    require('colorbuddy').colorscheme('gloombuddy')

    vim.cmd(Gloombuddy.mod_cmd)
end

return Gloombuddy

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
