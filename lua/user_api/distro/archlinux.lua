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
    local type_not_empty = require('user_api.check.value').type_not_empty

    ---@type string[]|table
    local new_rtpaths = {}

    -- First check for each dir's existance
    for _, p in next, self.rtpaths do
        if vim.fn.isdirectory(p) then
            table.insert(new_rtpaths, p)
        end
    end

    -- If no dirs...
    if not type_not_empty('table', new_rtpaths) then
        return false
    end

    self.rtpaths = vim.tbl_deep_extend('force', {}, new_rtpaths)

    return true
end

function Archlinux:setup()
    if not self:validate() then
        return
    end

    local Check = require('user_api.check')
    local Util = require('user_api.util')

    local is_dir = vim.fn.isdirectory
    local type_not_empty = Check.value.type_not_empty
    local strip_values = Util.strip_values

    -- Check if path is in rtp already
    for _, path in next, self.rtpaths do
        if not (is_dir(path) ~= 1 or vim.tbl_contains(vim.opt.rtp:get(), path)) then ---@diagnostic disable-line
            self.rtpaths = strip_values(self.rtpaths, { path })
        end
    end

    if not type_not_empty('table', self.rtpaths) then
        error('(user_api.distro.archlinux:setup()): Runtimepaths are empty or not a table')
    end

    for _, path in next, self.rtpaths do
        vim.opt.rtp:append(path)
    end

    ---@diagnostic disable-next-line
    local ok, _ = pcall(vim.cmd, 'runtime! archlinux.vim')

    assert(ok, 'BAD SETUP FOR Archlinux!')

    if ok then
        _G.I_USE_ARCH = 'BTW'
    end
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
