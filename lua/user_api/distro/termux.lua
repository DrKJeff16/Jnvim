--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local fmt = string.format

local function is_dir(dir)
    return vim.fn.isdirectory(dir) == 1
end

local environ = vim.fn.environ
local copy = vim.deepcopy

local ERROR = vim.log.levels.ERROR

---@class User.Distro.Termux
local Termux = {}

---@type string|''
Termux.PREFIX = vim.fn.has_key(environ(), 'PREFIX') and environ()['PREFIX'] or ''

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
        if not (Termux.validate() and is_dir(Termux.PREFIX)) then
            return
        end

        for _, path in next, copy(self.rtpaths) do
            if is_dir(path) == 1 then
                vim.go.rtp = vim.go.rtp .. ',' .. path
            end
        end

        vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
    end,
})

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
