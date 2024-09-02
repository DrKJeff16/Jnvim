-- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Arch Linux packages)

require('user_api.types')

---@type User.Distro.Spec
---@diagnostic disable-next-line:missing-fields
local M = {}

function M:setup()
    local Check = require('user_api.check')
    local Util = require('user_api.util')

    if not Check.exists.env_vars('PREFIX') then
        return
    end

    local is_dir = Check.exists.vim_isdir
    local empty = Check.value.empty
    local strip_values = Util.strip_values

    ---@type string
    local PREFIX = vim.fn.environ()['PREFIX']

    if not is_dir(PREFIX) then
        return
    end

    local rtpaths = {
        PREFIX .. '/local/share/nvim/runtime',
        PREFIX .. '/share/nvim/runtime',
        PREFIX .. '/local/share/vim/vimfiles',
        PREFIX .. '/local/share/vim/vimfiles/after',
        PREFIX .. '/share/vim/vimfiles',
        PREFIX .. '/share/vim/vimfiles/after',
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
            vim.opt.rtp:prepend(path)
        end
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
