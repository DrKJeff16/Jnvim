-- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Arch Linux packages)

---@diagnostic disable:missing-fields

---@module 'user_api.types.user.distro'

---@type User.Distro.Archlinux
local Archlinux = {}

Archlinux.rtpaths = {
    '/usr/local/share/nvim/runtime',
    '/usr/share/nvim/runtime',
    '/usr/local/share/vim/vimfiles',
    '/usr/local/share/vim/vimfiles/after',
    '/usr/share/vim/vimfiles',
    '/usr/share/vim/vimfiles/after',
}

---@param self User.Distro.Archlinux
---@return boolean
function Archlinux:validate()
    local Value = require('user_api.check.value')

    local empty = Value.empty

    local new_rtpaths = {}

    for _, p in next, self.rtpaths do
        if vim.fn.isdirectory(p) then
            table.insert(new_rtpaths, p)
        end
    end

    if empty(new_rtpaths) then
        return false
    end

    self.rtpaths = new_rtpaths
    return true
end

function Archlinux:setup()
    if not self:validate() then
        return
    end

    local Check = require('user_api.check')
    local Util = require('user_api.util')

    local is_dir = Check.exists.vim_isdir
    local empty = Check.value.empty
    local strip_values = Util.strip_values

    ---@type table
    ---@diagnostic disable-next-line
    local rtp = vim.opt.rtp:get()

    for _, path in next, vim.deepcopy(self.rtpaths) do
        if not (is_dir(path) or vim.tbl_contains(rtp, path)) then
            self.rtpaths = strip_values(self.rtpaths, { path })
        end
    end

    if not empty(self.rtpaths) then
        for _, path in next, self.rtpaths do
            vim.opt.rtp:append(path)
        end
    end

    ---@diagnostic disable-next-line
    pcall(vim.cmd, 'runtime! archlinux.vim')

    vim.schedule(function() vim.api.nvim_set_option_value('wrap', false, { scope = 'global' }) end)
end

---@param O? table
---@return table|User.Distro.Archlinux
function Archlinux.new(O)
    local is_tbl = require('user_api.check.value').is_tbl

    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Archlinux })
end

return Archlinux

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
