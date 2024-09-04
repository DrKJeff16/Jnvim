-- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Arch Linux packages)

require('user_api.types')

---@type User.Distro.Archlinux
---@diagnostic disable-next-line:missing-fields
local M = {}

function M:setup()
    local Check = require('user_api.check')
    local Util = require('user_api.util')

    local is_dir = Check.exists.vim_isdir
    local empty = Check.value.empty
    local strip_values = Util.strip_values

    local rtpaths = {
        '/usr/local/share/nvim/runtime',
        '/usr/share/nvim/runtime',
        '/usr/local/share/vim/vimfiles',
        '/usr/local/share/vim/vimfiles/after',
        '/usr/share/vim/vimfiles',
        '/usr/share/vim/vimfiles/after',
    }

    for _, path in next, vim.deepcopy(rtpaths) do
        ---@type table
        ---@diagnostic disable-next-line
        local rtp = vim.opt.rtp:get()

        if not (is_dir(path) or vim.tbl_contains(rtp, path)) then
            rtpaths = strip_values(rtpaths, { path })
        end
    end

    if not empty(rtpaths) then
        for _, path in next, rtpaths do
            vim.opt.rtp:append(path)
        end
    end

    vim.cmd('runtime! archlinux.vim')
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
