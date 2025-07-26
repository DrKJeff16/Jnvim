-- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Arch Linux packages)

---@diagnostic disable:missing-fields

local WARN = vim.log.levels.WARN

---@alias User.Distro.Archlinux.CallerFun fun()

---@class User.Distro.Archlinux
---@field rtpaths string[]
---@field validate fun(): boolean
---@field new fun(self: User.Distro.Archlinux?): table|User.Distro.Archlinux|User.Distro.Archlinux.CallerFun
local Archlinux = {}

Archlinux.rtpaths = {
    '/usr/share/vim/vimfiles/after',
    '/usr/share/vim/vimfiles',
    '/usr/share/nvim/runtime',
    '/usr/local/share/vim/vimfiles/after',
    '/usr/local/share/vim/vimfiles',
    '/usr/local/share/nvim/runtime',
}

---@return boolean
function Archlinux.validate()
    local type_not_empty = require('user_api.check.value').type_not_empty

    ---@type string[]|table
    local new_rtpaths = {}

    -- First check for each dir's existance
    for _, p in next, Archlinux.rtpaths do
        if vim.fn.isdirectory(p) == 1 and not vim.tbl_contains(new_rtpaths, p) then
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

---@param O? table
---@return table|User.Distro.Archlinux|User.Distro.Archlinux.CallerFun
function Archlinux.new(O)
    local is_tbl = require('user_api.check.value').is_tbl

    O = is_tbl(O) and O or {}
    return setmetatable(O, {
        __index = Archlinux,

        ---@param self User.Distro.Archlinux
        __call = function(self)
            if not self.validate() then
                return
            end

            local is_dir = vim.fn.isdirectory

            -- Check if path is in rtp already
            for _, path in next, self.rtpaths do
                if is_dir(path) == 1 and not vim.tbl_contains(vim.opt.rtp:get(), path) then
                    vim.opt.rtp:append(path)
                end
            end

            ---@diagnostic disable-next-line
            local ok, _ = pcall(vim.cmd, 'runtime! archlinux.vim')

            if not ok then
                vim.notify('BAD SETUP FOR Archlinux!', WARN)
                return
            end

            _G.I_USE_ARCH = 'BTW'
        end,
    })
end

return Archlinux.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
