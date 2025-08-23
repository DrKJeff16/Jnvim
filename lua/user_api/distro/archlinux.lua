---Modify runtimepath to also search the system-wide Vim directory
---(e.g. for Vim runtime files from Arch Linux packages)

local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR

local in_tbl = vim.tbl_contains
local is_dir = vim.fn.isdirectory

---@class User.Distro.Archlinux
local Archlinux = {}

---@class User.Distro.Archlinux.RTP
local RTPATHS = {
    '/usr/share/vim/vimfiles/after',
    '/usr/share/vim/vimfiles',
    '/usr/share/nvim/runtime',
    '/usr/local/share/vim/vimfiles/after',
    '/usr/local/share/vim/vimfiles',
    '/usr/local/share/nvim/runtime',
}

---@type User.Distro.Archlinux.RTP
Archlinux.rtpaths = setmetatable({}, {
    __index = RTPATHS,

    __newindex = function(_, _, _)
        error('User.Distro.Archlinux.RTP table is Read-Only!', ERROR)
    end,
})

---@return boolean
function Archlinux.validate()
    local type_not_empty = require('user_api.check.value').type_not_empty

    ---@type string[]|table
    local new_rtpaths = {}

    -- First check for each dir's existance
    for _, p in next, Archlinux.rtpaths do
        if vim.fn.isdirectory(p) == 1 and not in_tbl(new_rtpaths, p) then
            table.insert(new_rtpaths, p)
        end
    end

    -- If no dirs...
    if not type_not_empty('table', new_rtpaths) then
        return false
    end

    Archlinux.rtpaths = vim.deepcopy(new_rtpaths)

    return true
end

---@type User.Distro.Archlinux|fun()
return setmetatable({}, {
    __index = Archlinux,

    __newindex = function(_, _, _)
        error('User.Distro.Archlinux table is Read-Only!', ERROR)
    end,

    ---@param self User.Distro.Archlinux
    __call = function(self)
        if not Archlinux.validate() then
            return
        end

        -- Check if path is in rtp already
        for _, path in next, self.rtpaths do
            if is_dir(path) == 1 and not in_tbl(vim.opt.rtp:get(), path) then
                vim.opt.rtp:append(path)
            end
        end

        local ok = pcall(vim.cmd.runtime, { 'archlinux.vim', bang = true })

        if not ok then
            vim.notify('Bad setup for Arch Linux!', WARN)
            return
        end
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
