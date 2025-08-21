---@class SpaceVimSubMod
local SpaceVimDark = {}

SpaceVimDark.mod_cmd = 'silent! colorscheme space-vim-dark'

---@return boolean
function SpaceVimDark.valid()
    return vim.g.installed_space_vim_dark == 1
end

function SpaceVimDark.setup()
    vim.cmd(SpaceVimDark.mod_cmd)
end

return SpaceVimDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
