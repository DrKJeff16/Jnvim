--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local fmt = string.format

local is_dir = require('user_api.check.exists').vim_isdir

local environ = vim.fn.environ
local in_tbl = vim.tbl_contains
local copy = vim.deepcopy

local ERROR = vim.log.levels.ERROR

---@class User.Distro.Termux
local Termux = {}

---@type string|''
Termux.PREFIX = vim.fn.has_key(environ(), 'PREFIX') and environ()['PREFIX'] or ''

_G.PREFIX = Termux.PREFIX

Termux.rtpaths = {
    fmt('%s/share/vim/vimfiles/after', Termux.PREFIX),
    fmt('%s/share/vim/vimfiles', Termux.PREFIX),
    fmt('%s/share/nvim/runtime', Termux.PREFIX),
    fmt('%s/local/share/vim/vimfiles/after', Termux.PREFIX),
    fmt('%s/local/share/vim/vimfiles', Termux.PREFIX),
    fmt('%s/local/share/nvim/runtime', Termux.PREFIX),
}

---@return boolean
function Termux.validate()
    local empty = require('user_api.check.value').empty

    if Termux.PREFIX == '' or not is_dir(Termux.PREFIX) then
        return false
    end

    ---@type string[]|table
    local new_rtpaths = {}

    for _, path in next, Termux.rtpaths do
        if is_dir(path) then
            table.insert(new_rtpaths, path)
        end
    end

    if empty(new_rtpaths) then
        return false
    end

    Termux.rtpaths = copy(new_rtpaths)
    return true
end

---@type User.Distro.Termux|fun()
local M = setmetatable({}, {
    __index = Termux,

    __newindex = function(_, _, _)
        error('This module is read-only!', ERROR)
    end,

    ---@param self User.Distro.Termux
    __call = function(self)
        if not (self.validate() and is_dir(self.PREFIX)) then
            return
        end

        for _, path in next, copy(self.rtpaths) do
            ---@diagnostic disable-next-line:param-type-mismatch
            if is_dir(path) and not in_tbl(vim.opt.rtp:get(), path) then
                vim.opt.rtp:append(path)
            end
        end

        vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
    end,
})

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
