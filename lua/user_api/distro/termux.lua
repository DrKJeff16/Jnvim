--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

---@diagnostic disable:missing-fields

---@module 'user_api.types.user.distro'

local environ = vim.fn.environ

---@type User.Distro.Termux
local Termux = {}

Termux.PREFIX = vim.fn.has_key(environ(), 'PREFIX') and environ()['PREFIX'] or ''

_G.PREFIX = Termux.PREFIX

Termux.rtpaths = {
    PREFIX .. '/local/share/nvim/runtime',
    PREFIX .. '/share/nvim/runtime',
    PREFIX .. '/local/share/vim/vimfiles',
    PREFIX .. '/local/share/vim/vimfiles/after',
    PREFIX .. '/share/vim/vimfiles',
    PREFIX .. '/share/vim/vimfiles/after',
}

---@param self User.Distro.Termux
---@return boolean
function Termux:validate()
    local empty = require('user_api.check.value').empty

    if self.PREFIX == '' then
        return false
    end

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

---@param self User.Distro.Termux
function Termux:setup()
    if not self:validate() then
        return
    end

    local Check = require('user_api.check')
    local Util = require('user_api.util')

    local is_dir = Check.exists.vim_isdir
    local empty = Check.value.empty
    local strip_values = Util.strip_values

    if not is_dir(PREFIX) then
        return
    end

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

    vim.schedule(function() vim.api.nvim_set_option_value('wrap', true, { scope = 'global' }) end)
end

---@param O? table
---@return table|User.Distro.Termux
function Termux.new(O)
    local is_tbl = require('user_api.check.value').is_tbl

    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Termux })
end

return Termux

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
